# 📰 News App - Application Mobile Flutter

Application mobile moderne de news avec Flutter, Firebase et API externe (NewsAPI).

## 🚀 Fonctionnalités

- ✅ Authentification Firebase (Email/Password)
- ✅ News en temps réel depuis NewsAPI
- ✅ Cartes swipeables style Tinder
- ✅ 3 catégories : World News, Maroc, Sports
- ✅ Historique des news likées
- ✅ Profil utilisateur avec photo
- ✅ Design moderne (Bleu nuit / Blanc cassé)
- ✅ Architecture MVC avec Provider

## 🛠️ Technologies

- **Flutter** (latest stable)
- **Firebase** :
  - Authentication
  - Cloud Firestore
  - Storage
- **NewsAPI** (API externe)
- **Provider** (State Management)
- **Architecture MVC**

## 📋 Prérequis

1. **Flutter SDK** : Installez Flutter depuis [flutter.dev](https://flutter.dev)
2. **Firebase Project** : Créez un projet Firebase
3. **NewsAPI Key** : Obtenez une clé API gratuite sur [newsapi.org](https://newsapi.org)

## 🔧 Installation

### 1. Cloner le projet

```bash
cd Projrt-flutter
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configuration Firebase

#### a. Créer un projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com)
2. Créez un nouveau projet
3. Activez :
   - **Authentication** → Email/Password
   - **Cloud Firestore** → Créez une base de données
   - **Storage** → Activez le stockage

#### b. Configurer Firebase pour Flutter

**Android :**
1. Téléchargez `google-services.json`
2. Placez-le dans `android/app/`

**iOS :**
1. Téléchargez `GoogleService-Info.plist`
2. Placez-le dans `ios/Runner/`

#### c. Installer Firebase CLI (optionnel)

```bash
npm install -g firebase-tools
```

### 4. Configuration NewsAPI

1. Inscrivez-vous sur [newsapi.org](https://newsapi.org)
2. Obtenez votre clé API gratuite
3. Modifiez `lib/services/news_service.dart` :

```dart
final String apiKey = 'VOTRE_CLE_API_ICI';
```

### 5. Lancer l'application

```bash
flutter run
```

## 📱 Utilisation

### Connexion
- Créez un compte avec email/mot de passe
- Connectez-vous avec vos identifiants

### Navigation
- **World** : News internationales
- **Maroc** : News du Maroc uniquement
- **Sports** : News sportives
- **Profil** : Votre profil et news likées

### Swipe des News
- 👉 **Swipe droite** : Liker la news
- 👈 **Swipe gauche** : Ignorer la news

## 📁 Structure du Projet

```
lib/
├── controllers/          # Contrôleurs MVC (Provider)
│   ├── auth_controller.dart
│   └── news_controller.dart
├── models/              # Modèles de données
│   ├── user_model.dart
│   └── news_model.dart
├── screens/             # Écrans de l'application
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── news/
│   │   └── news_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   ├── home_screen.dart
│   └── splash_screen.dart
├── services/            # Services (API, Firebase)
│   ├── auth_service.dart
│   └── news_service.dart
├── utils/               # Utilitaires
│   └── app_theme.dart
├── widgets/             # Widgets réutilisables
│   ├── news_card.dart
│   └── liked_news_item.dart
└── main.dart
```

## 🎨 Design

- **Couleur principale** : Bleu nuit (#1A1F3A)
- **Couleur secondaire** : Blanc cassé (#F5F5F5)
- **Couleur accent** : Bleu (#4A90E2)
- **Cards arrondies** avec ombres légères
- **Animations Flutter** fluides

## 🧪 Test sur Mobile

### Option 1 : Flutter Run (Recommandé)

1. Connectez votre téléphone via USB
2. Activez le mode développeur et le débogage USB
3. Exécutez :

```bash
flutter run
```

### Option 2 : Build APK

```bash
flutter build apk
```

L'APK sera dans `build/app/outputs/flutter-apk/app-release.apk`

### Option 3 : QR Code (si Flutter Web)

Si vous avez configuré Flutter Web :

```bash
flutter run -d chrome
```

Puis scannez le QR code affiché dans la console.

## 📝 Notes Importantes

1. **NewsAPI** : La clé API gratuite a des limitations (100 requêtes/jour)
2. **Firebase** : Configurez correctement les règles de sécurité Firestore
3. **Images** : Les images sont mises en cache automatiquement
4. **Offline** : L'app utilise Firestore comme cache si l'API est indisponible

## 🔒 Règles de Sécurité Firestore

Ajoutez ces règles dans Firebase Console → Firestore → Rules :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /liked_news/{newsId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    match /news/{newsId} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## 🐛 Dépannage

### Erreur Firebase
- Vérifiez que `google-services.json` est bien placé
- Vérifiez que Firebase est initialisé dans `main.dart`

### Erreur NewsAPI
- Vérifiez votre clé API
- Vérifiez votre connexion internet
- L'app utilisera Firestore en cache si l'API échoue

### Erreur de build
```bash
flutter clean
flutter pub get
flutter run
```

## 📄 Licence

Ce projet est un exemple éducatif.

## 👨‍💻 Support

Pour toute question ou problème, vérifiez :
1. La configuration Firebase
2. La clé API NewsAPI
3. Les dépendances Flutter (`flutter pub get`)

---

**Bon développement ! 🚀**



