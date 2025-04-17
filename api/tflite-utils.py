import numpy as np
import tensorflow as tf
from PIL import Image
import io
import os
import argparse
import time
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

# Classes de prunes avec traductions
PLUM_CLASSES = ["bruised", "cracked", "rotten", "spotted", "unaffected", "unripe"]
PLUM_TRANSLATIONS = {
    "bruised": "Meurtrie",
    "cracked": "Fissurée",
    "rotten": "Pourrie",
    "spotted": "Tachetée",
    "unaffected": "Bonne qualité",
    "unripe": "Non mûre"
}

# Couleurs pour la visualisation
PLUM_COLORS = {
    "bruised": "#FFA726",  # Orange
    "cracked": "#EF5350",  # Rouge
    "rotten": "#8D6E63",   # Marron
    "spotted": "#FFEE58",  # Jaune
    "unaffected": "#66BB6A",  # Vert
    "unripe": "#42A5F5"   # Bleu
}

class PlumTFLiteModel:
    """Classe pour charger et utiliser un modèle TFLite de classification de prunes."""
    
    def __init__(self, model_path):
        """
        Initialise le modèle TFLite.
        
        Args:
            model_path: Chemin vers le fichier du modèle TFLite
        """
        self.model_path = model_path
        self.interpreter = None
        self.input_details = None
        self.output_details = None
        self.input_shape = None
        
        # Charger le modèle
        self._load_model()
    
    def _load_model(self):
        """Charge le modèle TFLite et configure l'interpréteur."""
        if not os.path.exists(self.model_path):
            raise FileNotFoundError(f"Le modèle TFLite n'a pas été trouvé: {self.model_path}")
        
        try:
            # Charger l'interpréteur TFLite
            self.interpreter = tf.lite.Interpreter(model_path=self.model_path)
            self.interpreter.allocate_tensors()
            
            # Obtenir les détails des tenseurs d'entrée et de sortie
            self.input_details = self.interpreter.get_input_details()
            self.output_details = self.interpreter.get_output_details()
            
            # Extraire la forme attendue de l'entrée
            self.input_shape = tuple(self.input_details[0]['shape'][1:3])  # (hauteur, largeur)
            
            print(f"Modèle TFLite chargé: {self.model_path}")
            print(f"Forme d'entrée attendue: {self.input_shape}")
            
            # Afficher les détails des tenseurs pour le débogage
            print("\nDétails du tenseur d'entrée:")
            print(f"  Nom: {self.input_details[0]['name']}")
            print(f"  Forme: {self.input_details[0]['shape']}")
            print(f"  Type: {self.input_details[0]['dtype']}")
            
            print("\nDétails du tenseur de sortie:")
            print(f"  Nom: {self.output_details[0]['name']}")
            print(f"  Forme: {self.output_details[0]['shape']}")
            print(f"  Type: {self.output_details[0]['dtype']}")
            
        except Exception as e:
            raise RuntimeError(f"Erreur lors du chargement du modèle: {str(e)}")
    
    def preprocess_image(self, image):
        """
        Prétraite une image pour l'inférence.
        
        Args:
            image: Chemin vers l'image, objet PIL.Image, ou bytes de l'image
            
        Returns:
            Tableau numpy normalisé (0-1) de forme adaptée au modèle
        """
        try:
            # Traiter différents types d'entrée
            if isinstance(image, str):
                # Si l'entrée est un chemin de fichier
                img = Image.open(image)
            elif isinstance(image, bytes):
                # Si l'entrée est un tableau de bytes
                img = Image.open(io.BytesIO(image))
            elif isinstance(image, Image.Image):
                # Si l'entrée est déjà un objet PIL.Image
                img = image
            else:
                raise ValueError("Format d'image non pris en charge. Utilisez un chemin de fichier, des bytes ou un objet PIL.Image.")
            
            # Convertir en RGB si nécessaire
            if img.mode != "RGB":
                img = img.convert("RGB")
            
            # Redimensionner à la taille attendue par le modèle
            img = img.resize(self.input_shape[::-1])  # Inverser car PIL utilise (largeur, hauteur)
            
            # Convertir en tableau numpy et normaliser (0-1)
            img_array = np.array(img, dtype=np.float32) / 255.0
            
            # Ajouter la dimension du batch
            img_array = np.expand_dims(img_array, axis=0)
            
            return img_array
        
        except Exception as e:
            raise ValueError(f"Erreur lors du prétraitement de l'image: {str(e)}")
    
    def predict(self, image):
        """
        Prédit la classe d'une image de prune.
        
        Args:
            image: Chemin vers l'image, objet PIL.Image, ou bytes de l'image
            
        Returns:
            Dictionnaire avec les résultats de la prédiction
        """
        start_time = time.time()
        
        # Prétraiter l'image
        input_data = self.preprocess_image(image)
        
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
    
    def predict_and_visualize(self, image_path):
        """
        Prédit la classe d'une image et affiche une visualisation des résultats.
        
        Args:
            image_path: Chemin vers l'image à classifier
        """
        # Charger l'image
        try:
            img = Image.open(image_path)
            prediction = self.predict(img)
            
            # Préparer la visualisation
            fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 7))
            
            # Afficher l'image
            ax1.imshow(img)
            ax1.set_title("Image d'entrée")
            ax1.axis('off')
            
            # Ajouter un encadré avec la prédiction
            predicted_class = prediction["predicted_class"]
            predicted_class_fr = prediction["predicted_class_fr"]
            confidence = prediction["confidence"]
            
            # Couleur du rectangle basée sur la classe prédite
            rect_color = PLUM_COLORS.get(predicted_class, "#666666")
            
            # Ajouter un rectangle en bas de l'image
            rect = Rectangle((0, img.height*0.8), img.width, img.height*0.2, 
                            linewidth=0, edgecolor='none', facecolor=rect_color, alpha=0.7)
            ax1.add_patch(rect)
            
            # Ajouter le texte de prédiction
            ax1.text(img.width/2, img.height*0.9, 
                    f"{predicted_class_fr}\nConfiance: {confidence:.2%}", 
                    color='white', fontsize=12, fontweight='bold', 
                    ha='center', va='center')
            
            # Afficher les probabilités pour toutes les classes
            ax2.set_title('Probabilités par classe')
            
            # Trier les probabilités
            sorted_probs = sorted(
                [(PLUM_TRANSLATIONS.get(cls, cls), prob) 
                for cls, prob in prediction["probabilities"].items()],
                key=lambda x: x[1],
                reverse=True
            )
            
            classes_fr = [item[0] for item in sorted_probs]
            probs = [item[1] for item in sorted_probs]
            colors = [PLUM_COLORS.get(list(PLUM_TRANSLATIONS.keys())[list(PLUM_TRANSLATIONS.values()).index(cls_fr)], "#666666") 
                     if cls_fr in PLUM_TRANSLATIONS.values() else "#666666" 
                     for cls_fr in classes_fr]
            
            # Créer un graphique à barres horizontales
            bars = ax2.barh(classes_fr, probs, color=colors)
            ax2.set_xlim(0, 1)
            ax2.set_xlabel('Probabilité')
            ax2.grid(axis='x', linestyle='--', alpha=0.7)
            
            # Ajouter les valeurs de probabilité
            for i, bar in enumerate(bars):
                width = bar.get_width()
                ax2.text(width + 0.01, bar.get_y() + bar.get_height()/2, 
                        f"{width:.1%}", va='center')
            
            # Ajouter des informations supplémentaires
            processing_time = prediction["processing_time_ms"]
            plt.figtext(0.5, 0.01, 
                       f"Temps de traitement: {processing_time:.1f} ms | Taille d'image: {self.input_shape[1]}x{self.input_shape[0]}", 
                       ha='center', fontsize=10, style='italic')
            
            plt.tight_layout()
            plt.show()
            
            return prediction
            
        except Exception as e:
            print(f"Erreur lors de la visualisation: {str(e)}")
            return None

def main():
    """Fonction principale pour utiliser le script en ligne de commande."""
    parser = argparse.ArgumentParser(description="Tester le modèle TFLite de classification de prunes")
    parser.add_argument("--model", default="final_simple_plum_model.tflite", help="Chemin vers le modèle TFLite")
    parser.add_argument("--image", required=True, help="Chemin vers l'image à classifier")
    parser.add_argument("--visualize", action="store_true", help="Afficher une visualisation des résultats")
    
    args = parser.parse_args()
    
    try:
        # Charger le modèle
        model = PlumTFLiteModel(args.model)
        
        if args.visualize:
            # Prédire et visualiser
            result = model.predict_and_visualize(args.image)
        else:
            # Simplement prédire
            result = model.predict(args.image)
            
            # Afficher les résultats
            print(f"\n=== Résultats de la classification pour {os.path.basename(args.image)} ===")
            print(f"Classe prédite: {result['predicted_class_fr']} ({result['predicted_class']})")
            print(f"Confiance: {result['confidence']:.2%}")
            print(f"Temps de traitement: {result['processing_time_ms']:.1f} ms\n")
            
            print("Probabilités par classe:")
            sorted_probs = sorted(result["probabilities"].items(), key=lambda x: x[1], reverse=True)
            for class_name, prob in sorted_probs:
                print(f"  {PLUM_TRANSLATIONS.get(class_name, class_name)}: {prob:.2%}")
        
    except Exception as e:
        print(f"Erreur: {str(e)}")

if __name__ == "__main__":
    main()
