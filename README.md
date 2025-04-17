# 🍑 Prune Classifier - Application Mobile de Tri Automatique des Prunes
![WhatsApp Image 2025-04-16 à 09 42 38_07cc5576](https://github.com/user-attachments/assets/da72853e-bb34-457d-bfc2-09c3bf939e14)





Flutter  apps links download  : https://firebasestorage.googleapis.com/v0/b/itchop-9bf14.appspot.com/o/PlumAnalyserAppV1.apk?alt=media&token=1295c76b-97c0-4ab5-bdd5-527527a63bc4  <br>
API LINK : https://api-prune.onrender.com/docs

## 📱 Aperçu du Projet

**Prune Classifier** est une application mobile Flutter qui permet de classifier des prunes africaines en six catégories différentes à l'aide d'un modèle de Deep Learning embarqué avec TensorFlow Lite. Ce projet a été développé dans le cadre du JCIA Hackathon 2025 (Journée Internationale de l'Intelligence Artificielle), organisé au Cameroun.



## 🎯 Objectif

L'application vise à faciliter le tri automatique des prunes en permettant aux agriculteurs et aux professionnels de l'agroalimentaire d'identifier rapidement la qualité et les défauts des prunes à l'aide d'un simple smartphone, contribuant ainsi à:

- Réduire le gaspillage alimentaire
- Améliorer la qualité des produits commercialisés
- Optimiser la chaîne de valeur agricole
- Augmenter les revenus des producteurs locaux

## 🔍 Classification des Prunes

L'application peut classifier les prunes dans les catégories suivantes:

| Catégorie | Description | Visuel |
|-----------|-------------|--------|
| **Bonne qualité** (unaffected) | Prunes sans défaut | 🟢 |
| **Non mûres** (unripe) | Prunes pas encore arrivées à maturité | 🔵 |
| **Tachetées** (spotted) | Prunes avec des taches sur la surface | 🟡 |
| **Fissurées** (cracked) | Prunes présentant des fissures | 🔴 |
| **Meurtries** (bruised) | Prunes ayant subi des chocs | 🟠 |
| **Pourries** (rotten) | Prunes en décomposition | 🟤 |

## ✨ Fonctionnalités

- **Capture d'image** : Prise de photo directe ou importation depuis la galerie
- **Classification en temps réel** : Résultats rapides grâce au modèle TensorFlow Lite embarqué
- **Interface intuitive** : Design simple et efficace pour une utilisation sur le terrain
- **Mode hors-ligne** : Fonctionne sans connexion internet
- **Visualisation des résultats** : Affichage des probabilités pour chaque catégorie
- **Historique des analyses** : Sauvegarde des résultats précédents pour suivi
- **Multilangue** : Support du français et de l'anglais

## 🧠 Technologie

L'application utilise un modèle de Deep Learning basé sur l'architecture VGG16 pré-entraînée sur ImageNet avec des couches supplémentaires entraînées spécifiquement sur le dataset "African Plums". Le modèle atteint une précision de ~80% sur l'ensemble de test.

### Pipeline de traitement:

1. **Prétraitement**: Redimensionnement (160×160px), normalisation
2. **Inférence**: Analyse via TensorFlow Lite
3. **Post-traitement**: Interprétation des scores de confiance
4. **Visualisation**: Affichage graphique des résultats

## 🚀 Installation

```bash
# Cloner le dépôt
git clone https://github.com/kouloucrepin/api_prune.git

# Naviguer dans le dossier du projet
cd prune_classifier

# Installer les dépendances
flutter pub get

# Exécuter l'application
flutter run
```

## 📋 Prérequis

- Flutter 3.0+
- Dart 2.17+
- Android 5.0+ ou iOS 11.0+
- Caméra fonctionnelle sur l'appareil

## 📁 Structure du Projet

```
prune_classifier/
├── assets/                  # Ressources (images, modèle TF Lite)
│   ├── model/
│   │   └── model.tflite
│   └── images/
├── lib/
│   ├── main.dart            # Point d'entrée de l'application
│   ├── screens/             # Écrans de l'application
│   │   ├── home_screen.dart
│   │   ├── camera_screen.dart
│   │   └── result_screen.dart
│   ├── models/              # Modèles de données
│   │   └── plum_class.dart
│   ├── services/            # Services (TF Lite, caméra)
│   │   ├── classifier.dart
│   │   └── camera_service.dart
│   └── widgets/             # Widgets réutilisables
│       ├── probability_bar.dart
│       └── camera_preview.dart
├── android/                 # Configuration Android
├── ios/                     # Configuration iOS
└── pubspec.yaml             # Dépendances du projet
```

## 📊 Performance du Modèle

| Métrique | Valeur |
|----------|--------|
| Précision (test) | ~80% |
| Temps d'inférence moyen | ~300ms |
| Taille du modèle | 17MB |

## 🔮 Perspectives Futures

- Intégration avec des systèmes de tri automatisés
- Analyse de lots par traitement d'images multiples
- Module de suivi de la qualité dans le temps
- Extension à d'autres types de fruits et légumes locaux
- API pour intégration avec d'autres applications agricoles

## 👥 Équipe

Ce projet a été développé par [Votre Équipe] dans le cadre du JCIA Hackathon 2025.

## 📄 Licence

Ce projet est sous licence [Votre Licence]. Voir le fichier `LICENSE` pour plus de détails.

## 🙏 Remerciements

- JCIA pour l'organisation du hackathon
- Kaggle et l'équipe qui a créé le dataset "African Plums"
- Tous les agriculteurs qui ont contribué à la collecte des données

---

<div align="center">
  <p>Développé avec ❤️ pour l'agriculture africaine</p>
  <p>JCIA Hackathon 2025 - "Intelligence Artificielle et Développement Économique : Innover pour transformer"</p>
</div>
