#!/usr/bin/env python3
"""
Client Python pour l'API de classification des prunes.
Cet utilitaire permet de tester l'API sans utiliser l'interface web.
"""

import requests
import argparse
import os
import json
import sys
from datetime import datetime
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image
import io

# URL de base de l'API (à modifier selon votre configuration)
BASE_URL = "https://api-prune.onrender.com"

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

def check_api_health():
    """Vérifie l'état de santé de l'API."""
    try:
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        if response.status_code == 200:
            data = response.json()
            if data.get("status") == "healthy" and data.get("model_loaded"):
                print("✅ API en bon état et modèle chargé correctement")
                return True
            else:
                print("⚠️ API en ligne mais état anormal:", data)
                return False
        else:
            print(f"⚠️ API en ligne mais code d'état anormal: {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Impossible de se connecter à l'API: {e}")
        return False

def predict_image(image_path, visualize=False, save_output=None):
    """
    Envoie une image à l'API pour classification.
    
    Args:
        image_path: Chemin vers l'image à classifier
        visualize: Afficher une visualisation graphique des résultats
        save_output: Chemin où sauvegarder les résultats en JSON (optionnel)
    
    Returns:
        Les résultats de la prédiction ou None en cas d'erreur
    """
    if not os.path.exists(image_path):
        print(f"❌ L'image {image_path} n'existe pas")
        return None
    
    try:
        # Préparer la requête multipart/form-data
        files = {'file': (os.path.basename(image_path), open(image_path, 'rb'), 'image/jpeg')}
        
        # Envoyer la requête
        print(f"📤 Envoi de l'image {os.path.basename(image_path)} à l'API...")
        start_time = datetime.now()
        
        response = requests.post(f"{BASE_URL}/predict/", files=files)
        
        # Calcul du temps total (client + API)
        total_time = (datetime.now() - start_time).total_seconds() * 1000
        
        # Traiter la réponse
        if response.status_code == 200:
            result = response.json()
            
            # Ajouter le temps total pour référence
            result["total_time_ms"] = total_time
            
            # Afficher les résultats
            print_results(result)
            
            # Visualiser les résultats si demandé
            if visualize:
                visualize_results(image_path, result)
            
            # Sauvegarder les résultats si demandé
            if save_output:
                save_results(result, save_output, image_path)
            
            return result
        else:
            try:
                error = response.json()
                print(f"❌ Erreur API ({response.status_code}): {error.get('detail', 'Erreur inconnue')}")
            except json.JSONDecodeError:
                print(f"❌ Erreur API ({response.status_code}): {response.text}")
            return None
    
    except Exception as e:
        print(f"❌ Erreur lors de la classification: {str(e)}")
        return None

def print_results(result):
    """Affiche les résultats de la prédiction de manière formatée."""
    print("\n📊 RÉSULTATS DE LA CLASSIFICATION")
    print("=" * 40)
    
    predicted_class = result["predicted_class"]
    predicted_class_fr = result["predicted_class_fr"]
    confidence = result["confidence"]
    
    print(f"🏷️  Classe prédite: {predicted_class_fr} ({predicted_class})")
    print(f"🎯 Confiance: {confidence:.2%}")
    print(f"⏱️  Temps de traitement API: {result['processing_time_ms']:.1f} ms")
    if "total_time_ms" in result:
        print(f"⏱️  Temps total (client + API): {result['total_time_ms']:.1f} ms")
    
    print("\n📈 Probabilités par classe:")
    print("-" * 40)
    
    # Trier les probabilités par ordre décroissant
    sorted_probs = sorted(
        result["probabilities"].items(), 
        key=lambda x: x[1], 
        reverse=True
    )
    
    # Afficher les probabilités avec barres de progression
    terminal_width = get_terminal_width()
    bar_width = min(50, terminal_width - 30)
    
    for class_name, prob in sorted_probs:
        class_fr = PLUM_TRANSLATIONS.get(class_name, class_name)
        bar = "█" * int(prob * bar_width)
        spaces = " " * (bar_width - len(bar))
        print(f"{class_fr:12} │ {bar}{spaces} │ {prob:.2%}")
    
    print("=" * 40)

def get_terminal_width():
    """Obtient la largeur du terminal."""
    try:
        return os.get_terminal_size().columns
    except:
        return 80  # Valeur par défaut

def visualize_results(image_path, result):
    """
    Visualise les résultats de la classification avec matplotlib.
    
    Args:
        image_path: Chemin vers l'image classifiée
        result: Dictionnaire des résultats de la prédiction
    """
    try:
        # Charger l'image
        img = Image.open(image_path)
        
        # Créer la figure avec deux sous-graphiques
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 7))
        
        # Afficher l'image
        ax1.imshow(img)
        ax1.set_title("Image analysée")
        ax1.axis('off')
        
        # Ajouter un texte avec la prédiction
        predicted_class = result["predicted_class"]
        confidence = result["confidence"]
        predicted_class_fr = result["predicted_class_fr"]
        
        # Ajouter un texte avec fond coloré pour la prédiction
        text_box = dict(
            boxstyle="round,pad=0.5",
            facecolor=PLUM_COLORS.get(predicted_class, "#666666"),
            alpha=0.8,
            edgecolor="none"
        )
        
        ax1.text(0.5, 0.05, 
                f"{predicted_class_fr}\nConfiance: {confidence:.2%}", 
                transform=ax1.transAxes,
                fontsize=14,
                color="white",
                bbox=text_box,
                horizontalalignment='center',
                verticalalignment='bottom')
        
        # Graphique des probabilités
        ax2.set_title("Probabilités par classe")
        
        # Trier les probabilités
        sorted_probs = sorted(
            [(PLUM_TRANSLATIONS.get(cls, cls), prob, cls) 
             for cls, prob in result["probabilities"].items()],
            key=lambda x: x[1],
            reverse=True
        )
        
        classes_fr = [item[0] for item in sorted_probs]
        probs = [item[1] for item in sorted_probs]
        orig_classes = [item[2] for item in sorted_probs]
        colors = [PLUM_COLORS.get(cls, "#666666") for cls in orig_classes]
        
        # Créer un graphique à barres horizontales
        y_pos = np.arange(len(classes_fr))
        bars = ax2.barh(y_pos, probs, color=colors)
        ax2.set_yticks(y_pos)
        ax2.set_yticklabels(classes_fr)
        ax2.set_xlim(0, 1)
        ax2.set_xlabel('Probabilité')
        ax2.grid(axis='x', linestyle='--', alpha=0.7)
        
        # Ajouter les valeurs de probabilité
        for i, bar in enumerate(bars):
            width = bar.get_width()
            ax2.text(width + 0.01, bar.get_y() + bar.get_height()/2, 
                   f"{width:.1%}", va='center')
        
        # Ajouter des informations supplémentaires
        proc_time = result["processing_time_ms"]
        total_time = result.get("total_time_ms", proc_time)
        
        plt.figtext(0.5, 0.01, 
                   f"Temps de traitement (API): {proc_time:.1f} ms | Total: {total_time:.1f} ms", 
                   ha='center', fontsize=10, style='italic')
        
        plt.tight_layout()
        plt.show()
        
    except Exception as e:
        print(f"❌ Erreur lors de la visualisation: {str(e)}")

def save_results(result, output_path, image_path):
    """
    Sauvegarde les résultats au format JSON.
    
    Args:
        result: Dictionnaire des résultats
        output_path: Chemin où sauvegarder les résultats
        image_path: Chemin de l'image analysée
    """
    try:
        # Ajouter des métadonnées
        result["metadata"] = {
            "image_path": image_path,
            "image_name": os.path.basename(image_path),
            "timestamp": datetime.now().isoformat(),
            "api_url": BASE_URL
        }
        
        # Déterminer le chemin de sortie
        if os.path.isdir(output_path):
            # Si c'est un répertoire, créer un nouveau fichier
            base_name = os.path.splitext(os.path.basename(image_path))[0]
            json_path = os.path.join(output_path, f"{base_name}_result.json")
        else:
            # Sinon utiliser le chemin directement
            json_path = output_path
        
        # Sauvegarder le fichier JSON
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        
        print(f"✅ Résultats sauvegardés dans {json_path}")
    
    except Exception as e:
        print(f"❌ Erreur lors de la sauvegarde des résultats: {str(e)}")

def batch_predict(input_dir, output_dir=None, visualize=False):
    """
    Traite plusieurs images en lot.
    
    Args:
        input_dir: Répertoire contenant les images à traiter
        output_dir: Répertoire où sauvegarder les résultats
        visualize: Afficher les visualisations
    """
    if not os.path.isdir(input_dir):
        print(f"❌ Le répertoire {input_dir} n'existe pas")
        return
    
    # Créer le répertoire de sortie si nécessaire
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # Obtenir la liste des images
    extensions = ['.jpg', '.jpeg', '.png']
    images = [
        os.path.join(input_dir, f) for f in os.listdir(input_dir)
        if os.path.splitext(f.lower())[1] in extensions
    ]
    
    if not images:
        print(f"❌ Aucune image trouvée dans {input_dir}")
        return
    
    print(f"📁 Traitement par lot de {len(images)} images...")
    
    # Statistiques
    successful = 0
    failed = 0
    results = []
    
    # Traiter chaque image
    for i, image_path in enumerate(images):
        print(f"\n[{i+1}/{len(images)}] Traitement de {os.path.basename(image_path)}")
        
        # Préparer le chemin de sortie si nécessaire
        json_path = None
        if output_dir:
            base_name = os.path.splitext(os.path.basename(image_path))[0]
            json_path = os.path.join(output_dir, f"{base_name}_result.json")
        
        # Prédire
        result = predict_image(image_path, visualize, json_path)
        
        if result:
            successful += 1
            results.append({
                "image": os.path.basename(image_path),
                "predicted_class": result["predicted_class"],
                "confidence": result["confidence"]
            })
        else:
            failed += 1
    
    # Afficher le résumé
    print("\n📊 RÉSUMÉ DU TRAITEMENT PAR LOT")
    print("=" * 40)
    print(f"✅ Images traitées avec succès: {successful}")
    print(f"❌ Échecs: {failed}")
    print(f"📁 Dossier de sortie: {output_dir or 'Non spécifié'}")
    print("=" * 40)
    
    # Si on a un dossier de sortie, créer un fichier de résumé
    if output_dir and successful > 0:
        summary_path = os.path.join(output_dir, "batch_summary.json")
        try:
            with open(summary_path, 'w', encoding='utf-8') as f:
                json.dump({
                    "timestamp": datetime.now().isoformat(),
                    "total": len(images),
                    "successful": successful,
                    "failed": failed,
                    "results": results
                }, f, ensure_ascii=False, indent=2)
            print(f"✅ Résumé sauvegardé dans {summary_path}")
        except Exception as e:
            print(f"❌ Erreur lors de la sauvegarde du résumé: {str(e)}")

def main():
    """Fonction principale."""
    parser = argparse.ArgumentParser(description="Client pour l'API de classification des prunes")
    
    # Paramètres généraux
    parser.add_argument("--url", default=BASE_URL, help=f"URL de base de l'API (défaut: {BASE_URL})")
    parser.add_argument("--health", action="store_true", help="Vérifier l'état de santé de l'API")
    
    # Sous-parseurs pour les différentes commandes
    subparsers = parser.add_subparsers(dest="command", help="Commande à exécuter")
    
    # Parser pour la commande "predict"
    predict_parser = subparsers.add_parser("predict", help="Classifier une image de prune")
    predict_parser.add_argument("image", help="Chemin vers l'image à classifier")
    predict_parser.add_argument("--visualize", "-v", action="store_true", help="Afficher une visualisation graphique")
    predict_parser.add_argument("--output", "-o", help="Chemin où sauvegarder les résultats en JSON")
    
    # Parser pour la commande "batch"
    batch_parser = subparsers.add_parser("batch", help="Classifier plusieurs images en lot")
    batch_parser.add_argument("input_dir", help="Répertoire contenant les images à classifier")
    batch_parser.add_argument("--output-dir", "-o", help="Répertoire où sauvegarder les résultats")
    batch_parser.add_argument("--visualize", "-v", action="store_true", help="Afficher les visualisations")
    
    # Analyser les arguments
    args = parser.parse_args()
    
    # Mettre à jour l'URL de base si spécifiée
    global BASE_URL
    if args.url:
        BASE_URL = args.url
    
    # Vérifier l'état de santé si demandé ou avant chaque commande
    if args.health or args.command:
        if not check_api_health():
            print("❌ L'API n'est pas disponible ou en bon état. Arrêt.")
            sys.exit(1)
    
    # Si aucune commande n'est spécifiée, afficher l'aide
    if not args.command and not args.health:
        parser.print_help()
        sys.exit(0)
    
    # Exécuter la commande appropriée
    if args.command == "predict":
        predict_image(args.image, args.visualize, args.output)
    elif args.command == "batch":
        batch_predict(args.input_dir, args.output_dir, args.visualize)

if __name__ == "__main__":
    main()
