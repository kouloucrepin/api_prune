import io
import os
import time
import numpy as np
import tensorflow as tf
from enum import Enum
from typing import Dict, List, Optional
from pathlib import Path
from datetime import datetime

from fastapi import FastAPI, File, UploadFile, HTTPException, Query, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

# Configuration
MODEL_PATH = "final_simple_plum_model.tflite"
IMAGE_SIZE = (160, 160)  # Taille d'image attendue par le modèle
PLUM_CLASSES = ["bruised", "cracked", "rotten", "spotted", "unaffected", "unripe"]

# Traductions des classes pour l'affichage
PLUM_TRANSLATIONS = {
    "bruised": "Meurtrie",
    "cracked": "Fissurée",
    "rotten": "Pourrie",
    "spotted": "Tachetée",
    "unaffected": "Bonne qualité",
    "unripe": "Non mûre"
}

# Couleurs pour visualisation
PLUM_COLORS = {
    "bruised": "#FFA726",  # Orange
    "cracked": "#EF5350",  # Rouge
    "rotten": "#8D6E63",   # Marron
    "spotted": "#FFEE58",  # Jaune
    "unaffected": "#66BB6A",  # Vert
    "unripe": "#42A5F5"   # Bleu
}

# Modèles Pydantic pour la validation des données
class PredictionResult(BaseModel):
    predicted_class: str = Field(..., description="Classe prédite (en anglais)")
    predicted_class_fr: str = Field(..., description="Classe prédite (en français)")
    confidence: float = Field(..., description="Score de confiance (0-1)")
    probabilities: Dict[str, float] = Field(..., description="Probabilités pour toutes les classes")
    processing_time_ms: float = Field(..., description="Temps de traitement en millisecondes")

class HealthStatus(BaseModel):
    status: str
    model_loaded: bool
    model_path: str
    model_shape: Optional[List[int]] = None
    timestamp: str

# Classe du classificateur
class PlumClassifier:
    def __init__(self, model_path: str):
        """Initialise le classificateur avec le modèle TFLite spécifié."""
        self.model_path = model_path
        self.interpreter = None
        self.input_details = None
        self.output_details = None
        self.input_shape = None
        
        self._load_model()
    
    def _load_model(self):
        """Charge le modèle TFLite en mémoire."""
        if not os.path.exists(self.model_path):
            raise FileNotFoundError(f"Le modèle TFLite n'a pas été trouvé: {self.model_path}")
        
        try:
            self.interpreter = tf.lite.Interpreter(model_path=self.model_path)
            self.interpreter.allocate_tensors()
            
            # Récupérer les détails d'entrée et de sortie
            self.input_details = self.interpreter.get_input_details()
            self.output_details = self.interpreter.get_output_details()
            
            # Récupérer la forme d'entrée attendue
            self.input_shape = self.input_details[0]['shape'][1:3]  # (hauteur, largeur)
            
            print(f"Modèle TFLite chargé: {self.model_path}")
            print(f"Forme d'entrée attendue: {self.input_shape}")
        except Exception as e:
            print(f"Erreur lors du chargement du modèle: {str(e)}")
            raise RuntimeError(f"Erreur lors du chargement du modèle: {str(e)}")
    
    def preprocess_image(self, image_bytes: bytes) -> np.ndarray:
        """
        Prétraite l'image pour l'inférence.
        
        Args:
            image_bytes: Image en bytes
            
        Returns:
            Image prétraitée sous forme de tableau numpy
        """
        import io
        from PIL import Image
        
        # Charger l'image depuis les bytes
        image = Image.open(io.BytesIO(image_bytes))
        
        # Convertir en RGB si nécessaire
        if image.mode != "RGB":
            image = image.convert("RGB")
        
        # Redimensionner à la taille attendue par le modèle
        if self.input_shape is not None:
            image = image.resize((self.input_shape[1], self.input_shape[0]))
        else:
            image = image.resize(IMAGE_SIZE)
        
        # Convertir en array numpy et normaliser (0-1)
        image_array = np.array(image, dtype=np.float32) / 255.0
        
        # Ajouter la dimension du batch
        image_array = np.expand_dims(image_array, axis=0)
        
        return image_array
    
    def predict(self, image_bytes: bytes) -> Dict:
        """
        Prédit la classe d'une image de prune.
        
        Args:
            image_bytes: Image en bytes
            
        Returns:
            Dictionnaire avec les résultats de prédiction
        """
        start_time = time.time()
        
        # Prétraiter l'image
        input_data = self.preprocess_image(image_bytes)
        
        # Définir les données d'entrée
        self.interpreter.set_tensor(self.input_details[0]['index'], input_data)
        
        # Exécuter l'inférence
        self.interpreter.invoke()
        
        # Obtenir les résultats
        output_data = self.interpreter.get_tensor(self.output_details[0]['index'])
        
        # Calculer les probabilités et la classe prédite
        probabilities = output_data[0]
        predicted_class_index = np.argmax(probabilities)
        predicted_class = PLUM_CLASSES[predicted_class_index]
        confidence = float(probabilities[predicted_class_index])
        
        # Créer un dictionnaire avec les probabilités pour toutes les classes
        all_probabilities = {PLUM_CLASSES[i]: float(probabilities[i]) for i in range(len(PLUM_CLASSES))}
        
        # Calculer le temps de traitement
        processing_time_ms = (time.time() - start_time) * 1000
        
        # Obtenir la traduction de la classe
        predicted_class_fr = PLUM_TRANSLATIONS.get(predicted_class, predicted_class)
        
        return {
            "predicted_class": predicted_class,
            "predicted_class_fr": predicted_class_fr,
            "confidence": confidence,
            "probabilities": all_probabilities,
            "processing_time_ms": processing_time_ms
        }

# Créer l'application FastAPI
app = FastAPI(
    title="API de Classification des Prunes Africaines",
    description="""
    Cette API permet de classifier des images de prunes africaines en 6 catégories différentes 
    en utilisant un modèle de deep learning.
    
    **Catégories:**
    - Bonne qualité (unaffected)
    - Non mûres (unripe)
    - Tachetées (spotted)
    - Fissurées (cracked)
    - Meurtries (bruised)
    - Pourries (rotten)
    """,
    version="1.0.0",
)

# Configurer CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # À ajuster en production pour plus de sécurité
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialiser le classificateur
try:
    classifier = PlumClassifier(MODEL_PATH)
except Exception as e:
    print(f"ATTENTION: Erreur lors de l'initialisation du classificateur: {str(e)}")
    print("L'API démarrera mais les prédictions échoueront.")
    classifier = None

# Points d'accès API
@app.get("/", response_class=HTMLResponse)
async def read_root():
    """Page d'accueil avec redirection vers l'interface utilisateur."""
    return """
    <html>
        <head>
            <title>API de Classification des Prunes Africaines</title>
            <meta http-equiv="refresh" content="0;url=/ui" />
        </head>
        <body>
            <p>Redirection vers l'interface utilisateur...</p>
        </body>
    </html>
    """

@app.get("/health", response_model=HealthStatus)
async def health_check():
    """
    Vérifie l'état de santé de l'API.
    
    Returns:
        Informations sur l'état du service et du modèle
    """
    if classifier is None or classifier.interpreter is None:
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "model_loaded": False,
                "model_path": MODEL_PATH,
                "model_shape": None,
                "timestamp": datetime.now().isoformat()
            }
        )
    
    return {
        "status": "healthy",
        "model_loaded": True,
        "model_path": classifier.model_path,
        "model_shape": classifier.input_shape.tolist() if classifier.input_shape is not None else None,
        "timestamp": datetime.now().isoformat()
    }

@app.post("/predict/", response_model=PredictionResult)
async def predict_plum(
    file: UploadFile = File(..., description="Image de prune à classifier (JPG, PNG)")
):
    """
    Classifie une image de prune et retourne la catégorie prédite.
    
    Args:
        file: Fichier image à classifier
        
    Returns:
        Résultats de la prédiction avec la classe et les probabilités
    """
    # Vérifier que le classificateur est chargé
    if classifier is None or classifier.interpreter is None:
        raise HTTPException(
            status_code=500,
            detail="Le modèle n'a pas été correctement initialisé. Vérifiez les logs du serveur."
        )
    
    # Vérifier le type de fichier
    allowed_types = ["image/jpeg", "image/png", "image/jpg"]
    if file.content_type not in allowed_types:
        raise HTTPException(
            status_code=400,
            detail=f"Type de fichier non supporté. Types acceptés: {', '.join(allowed_types)}"
        )
    
    try:
        # Lire le contenu du fichier
        file_content = await file.read()
        
        # Vérifier que le fichier n'est pas vide
        if len(file_content) == 0:
            raise HTTPException(status_code=400, detail="Le fichier est vide")
        
        # Effectuer la prédiction
        result = classifier.predict(file_content)
        
        return result
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Erreur lors de la prédiction: {str(e)}"
        )

@app.get("/ui", response_class=HTMLResponse)
async def get_ui():
    """Interface utilisateur HTML pour tester l'API."""
    
    return """"
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Classificateur de Prunes Africaines</title>
        <style>
            :root {
                --primary-color: #4CAF50;
                --primary-dark: #3e8e41;
                --secondary-color: #f5f5f5;
                --text-color: #333;
                --error-color: #f44336;
                --success-color: #4CAF50;
                --border-radius: 8px;
                --box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                --font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            
            body {
                font-family: var(--font-family);
                line-height: 1.6;
                color: var(--text-color);
                max-width: 900px;
                margin: 0 auto;
                padding: 20px;
            }
            
            h1, h2, h3 {
                margin-top: 0;
                color: var(--primary-color);
            }
            
            .title-section {
                display: flex;
                flex-direction: column;
                align-items: center;
                margin-bottom: 20px;
                text-align: center;
            }
            
            .title-section h1 {
                margin-bottom: 10px;
            }
            
            .title-section .link-btn {
                margin-top: 5px;
            }
            
            .container {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }
            
            @media (min-width: 768px) {
                .container {
                    flex-direction: row;
                }
                
                .upload-section, .result-section {
                    flex: 1;
                }
            }
            
            .panel {
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .upload-section {
                margin-bottom: 20px;
            }
            
            .result-section {
                display: none;
            }
            
            #dropArea {
                border: 2px dashed #ccc;
                border-radius: var(--border-radius);
                padding: 40px 20px;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s;
            }
            
            #dropArea.highlight {
                border-color: var(--primary-color);
                background-color: rgba(76, 175, 80, 0.1);
            }
            
            .btn {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 10px 0;
                cursor: pointer;
                border-radius: var(--border-radius);
                transition: background-color 0.3s;
            }
            
            .btn:hover {
                background-color: var(--primary-dark);
            }
            
            .btn:disabled {
                background-color: #cccccc;
                cursor: not-allowed;
            }
            
            .button-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .link-btn {
                background-color: #2196F3;
                color: white;
                border: none;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                cursor: pointer;
                border-radius: var(--border-radius);
                transition: background-color 0.3s;
            }
            
            .link-btn:hover {
                background-color: #0b7dda;
            }
            
            #previewContainer {
                margin-top: 20px;
                text-align: center;
                display: none;
            }
            
            #imagePreview {
                max-width: 100%;
                max-height: 300px;
                border-radius: var(--border-radius);
                box-shadow: var(--box-shadow);
            }
            
            .probability-item {
                display: flex;
                align-items: center;
                margin-bottom: 8px;
            }
            
            .probability-label {
                width: 110px;
                font-weight: bold;
            }
            
            .probability-bar-container {
                flex-grow: 1;
                height: 20px;
                background-color: #f1f1f1;
                border-radius: 10px;
                margin: 0 10px;
                overflow: hidden;
            }
            
            .probability-bar {
                height: 100%;
                border-radius: 10px;
            }
            
            .probability-value {
                width: 60px;
                text-align: right;
                font-weight: bold;
            }
            
            .result-card {
                background-color: #f9f9f9;
                border-radius: var(--border-radius);
                padding: 15px;
                margin-top: 20px;
                box-shadow: var(--box-shadow);
            }
            
            .prediction-label {
                font-size: 24px;
                font-weight: bold;
                text-align: center;
                margin: 10px 0;
                padding: 10px;
                border-radius: var(--border-radius);
                color: white;
            }
            
            .confidence-info {
                display: flex;
                align-items: center;
                justify-content: center;
                margin-top: 10px;
            }
            
            .confidence-info span {
                font-weight: bold;
                margin-left: 5px;
            }
            
            .spinner-container {
                display: none;
                justify-content: center;
                align-items: center;
                margin: 20px 0;
            }
            
            .spinner {
                border: 5px solid #f3f3f3;
                border-top: 5px solid var(--primary-color);
                border-radius: 50%;
                width: 40px;
                height: 40px;
                animation: spin 1s linear infinite;
            }
            
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
            
            .hidden {
                display: none;
            }
            
            .error-message {
                color: var(--error-color);
                background-color: #ffebee;
                padding: 10px;
                border-radius: var(--border-radius);
                margin-top: 10px;
                display: none;
            }
            
            footer {
                margin-top: 40px;
                text-align: center;
                color: #666;
                font-size: 14px;
            }
            
            .info-box {
                background-color: #e3f2fd;
                border-left: 4px solid #2196F3;
                padding: 10px 15px;
                margin-bottom: 20px;
                border-radius: 0 var(--border-radius) var(--border-radius) 0;
            }
            
            .info-box h3 {
                margin-top: 0;
                color: #2196F3;
            }
        </style>
    </head>
    <body>
        <div class="title-section">
            <h1>Classificateur de Prunes Africaines</h1>
            <a href="https://firebasestorage.googleapis.com/v0/b/itchop-9bf14.appspot.com/o/PlumAnalyserApp.apk?alt=media&token=dd547405-7c50-4dd5-9e72-6d694a7acdb8" target="_blank" class="link-btn">Télécharger l'application</a>
        </div>
        
        <div class="info-box">
            <h3>À propos de cette application</h3>
            <p>
                Cette application utilise l'intelligence artificielle pour analyser des images de prunes africaines 
                et détecter leur qualité. Elle peut identifier les prunes en bon état, non mûres, tachetées, 
                fissurées, meurtries ou pourries.
            </p>
        </div>
        
        <div class="container">
            <div class="upload-section panel">
                <h2>Télécharger une image</h2>
                
                <div id="dropArea">
                    <p>Glissez-déposez une image de prune ici ou cliquez pour sélectionner un fichier</p>
                    <input type="file" id="fileInput" accept="image/jpeg, image/png, image/jpg" style="display: none;">
                </div>
                
                <div id="previewContainer">
                    <h3>Aperçu de l'image</h3>
                    <img id="imagePreview" src="#" alt="Aperçu de l'image de prune">
                </div>
                
                <button id="predictBtn" class="btn" disabled>Classifier l'image</button>
                
                <div class="spinner-container" id="loadingSpinner">
                    <div class="spinner"></div>
                    <p style="margin-left: 10px;">Classification en cours...</p>
                </div>
                
                <div class="error-message" id="errorMessage"></div>
            </div>
            
            <div class="result-section panel" id="resultSection">
                <h2>Résultats de la classification</h2>
                
                <div class="result-card">
                    <h3>Classe prédite:</h3>
                    <div class="prediction-label" id="predictionLabel">Non classifiée</div>
                    
                    <div class="confidence-info">
                        Niveau de confiance: <span id="confidenceValue">0%</span>
                    </div>
                </div>
                
                <div class="result-card">
                    <h3>Probabilités par classe:</h3>
                    <div id="probabilitiesContainer"></div>
                </div>
                
                <div style="margin-top: 15px; font-size: 14px; color: #666;">
                    Temps de traitement: <span id="processingTime">0</span> ms
                </div>
            </div>
        </div>
        
        <footer>
            <p>JCIA Hackathon 2025 - Tri Automatique des Prunes</p>
        </footer>
        
        <script>
            // Éléments DOM
            const dropArea = document.getElementById('dropArea');
            const fileInput = document.getElementById('fileInput');
            const previewContainer = document.getElementById('previewContainer');
            const imagePreview = document.getElementById('imagePreview');
            const predictBtn = document.getElementById('predictBtn');
            const loadingSpinner = document.getElementById('loadingSpinner');
            const resultSection = document.getElementById('resultSection');
            const predictionLabel = document.getElementById('predictionLabel');
            const confidenceValue = document.getElementById('confidenceValue');
            const probabilitiesContainer = document.getElementById('probabilitiesContainer');
            const processingTime = document.getElementById('processingTime');
            const errorMessage = document.getElementById('errorMessage');
            
            // Mapping des classes et couleurs
            const classColors = {
                'bruised': '#FFA726',  // Orange
                'cracked': '#EF5350',  // Rouge
                'rotten': '#8D6E63',   // Marron
                'spotted': '#FFEE58',  // Jaune
                'unaffected': '#66BB6A', // Vert
                'unripe': '#42A5F5'    // Bleu
            };
            
            const classTranslations = {
                'bruised': 'Meurtrie',
                'cracked': 'Fissurée',
                'rotten': 'Pourrie',
                'spotted': 'Tachetée',
                'unaffected': 'Bonne qualité',
                'unripe': 'Non mûre'
            };
            
            // Événements de glisser-déposer
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                dropArea.addEventListener(eventName, preventDefaults, false);
            });
            
            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }
            
            ['dragenter', 'dragover'].forEach(eventName => {
                dropArea.addEventListener(eventName, highlight, false);
            });
            
            ['dragleave', 'drop'].forEach(eventName => {
                dropArea.addEventListener(eventName, unhighlight, false);
            });
            
            function highlight() {
                dropArea.classList.add('highlight');
            }
            
            function unhighlight() {
                dropArea.classList.remove('highlight');
            }
            
            // Gestion du dépôt de fichier
            dropArea.addEventListener('drop', handleDrop, false);
            
            function handleDrop(e) {
                const dt = e.dataTransfer;
                const files = dt.files;
                
                if (files.length) {
                    handleFiles(files);
                }
            }
            
            // Gérer la sélection de fichier via le bouton
            dropArea.addEventListener('click', () => {
                fileInput.click();
            });
            
            fileInput.addEventListener('change', function() {
                if (this.files.length) {
                    handleFiles(this.files);
                }
            });
            
            function handleFiles(files) {
                const file = files[0];
                
                // Vérifier que c'est une image
                if (!file.type.match('image.*')) {
                    showError("Veuillez sélectionner une image (JPEG ou PNG)");
                    return;
                }
                
                // Afficher l'aperçu
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    previewContainer.style.display = 'block';
                    predictBtn.disabled = false;
                    resultSection.style.display = 'none';
                    hideError();
                };
                
                reader.readAsDataURL(file);
            }
            
            // Gestion du bouton de prédiction
            predictBtn.addEventListener('click', predictImage);
            
            function predictImage() {
                if (fileInput.files.length === 0) {
                    showError("Veuillez d'abord sélectionner une image");
                    return;
                }
                
                const file = fileInput.files[0];
                const formData = new FormData();
                formData.append('file', file);
                
                // Afficher le spinner de chargement
                loadingSpinner.style.display = 'flex';
                predictBtn.disabled = true;
                hideError();
                
                // Appeler l'API
                fetch('/predict/', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => {
                            throw new Error(err.detail || 'Erreur lors de la prédiction');
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    // Masquer le spinner
                    loadingSpinner.style.display = 'none';
                    
                    // Afficher les résultats
                    displayResults(data);
                    
                    // Réactiver le bouton
                    predictBtn.disabled = false;
                })
                .catch(error => {
                    loadingSpinner.style.display = 'none';
                    predictBtn.disabled = false;
                    showError(error.message);
                });
            }
            
            function displayResults(data) {
                // Afficher la section des résultats
                resultSection.style.display = 'block';
                
                // Classe prédite
                const predictedClass = data.predicted_class;
                const predictedClassFr = data.predicted_class_fr;
                
                predictionLabel.textContent = predictedClassFr;
                predictionLabel.style.backgroundColor = classColors[predictedClass] || '#666';
                
                // Confiance
                const confidencePct = (data.confidence * 100).toFixed(1);
                confidenceValue.textContent = `${confidencePct}%`;
                
                // Temps de traitement
                processingTime.textContent = data.processing_time_ms.toFixed(1);
                
                // Probabilités
                displayProbabilities(data.probabilities);
                
                // Faire défiler jusqu'aux résultats
                resultSection.scrollIntoView({ behavior: 'smooth' });
            }
            
            function displayProbabilities(probabilities) {
                // Vider le conteneur
                probabilitiesContainer.innerHTML = '';
                
                // Trier les probabilités par ordre décroissant
                const sortedProbs = Object.entries(probabilities)
                    .sort((a, b) => b[1] - a[1]);
                
                // Créer les barres pour chaque classe
                sortedProbs.forEach(([className, probability]) => {
                    const probPct = (probability * 100).toFixed(1);
                    const classFr = classTranslations[className] || className;
                    
                    const item = document.createElement('div');
                    item.className = 'probability-item';
                    
                    const label = document.createElement('div');
                    label.className = 'probability-label';
                    label.textContent = classFr;
                    
                    const barContainer = document.createElement('div');
                    barContainer.className = 'probability-bar-container';
                    
                    const bar = document.createElement('div');
                    bar.className = 'probability-bar';
                    bar.style.width = `${probPct}%`;
                    bar.style.backgroundColor = classColors[className] || '#666';
                    
                    const value = document.createElement('div');
                    value.className = 'probability-value';
                    value.textContent = `${probPct}%`;
                    
                    barContainer.appendChild(bar);
                    item.appendChild(label);
                    item.appendChild(barContainer);
                    item.appendChild(value);
                    
                    probabilitiesContainer.appendChild(item);
                });
            }
            
            function showError(message) {
                errorMessage.textContent = message;
                errorMessage.style.display = 'block';
            }
            
            function hideError() {
                errorMessage.style.display = 'none';
            }
            
            // Vérifier l'état de santé de l'API au chargement
            window.addEventListener('load', checkApiHealth);
            
            function checkApiHealth() {
                fetch('/health')
                    .then(response => response.json())
                    .then(data => {
                        if (data.status !== 'healthy' || !data.model_loaded) {
                            showError("L'API n'est pas en bon état ou le modèle n'est pas chargé correctement.");
                        }
                    })
                    .catch(error => {
                        showError("Impossible de contacter l'API. Veuillez vérifier que le serveur est en cours d'exécution.");
                    });
            }
        </script>
    </body>
    </html>
"""



# Démarrage de l'application
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
