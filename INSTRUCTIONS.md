# 📱 Instructions pour Tester l'Application

## 🚀 Démarrage Rapide

### 1. Installation des Dépendances

```bash
flutter pub get
```

### 2. Configuration Firebase (OBLIGATOIRE)

Suivez les instructions dans `SETUP_FIREBASE.md` pour configurer Firebase.

**Important** : Sans Firebase, l'authentification ne fonctionnera pas.

### 3. Configuration NewsAPI (OBLIGATOIRE)

1. Créez un compte gratuit sur [newsapi.org](https://newsapi.org)
2. Obtenez votre clé API
3. Modifiez `lib/services/news_service.dart` ligne 8 :

```dart
final String apiKey = 'VOTRE_CLE_API_ICI';
```

### 4. Lancer l'Application

#### Option A : Sur un Émulateur/Simulateur

```bash
# Android
flutter emulators --launch <nom_emulateur>
flutter run

# iOS (sur Mac uniquement)
flutter run
```

#### Option B : Sur un Appareil Physique

**Android :**
1. Activez le mode développeur sur votre téléphone
2. Activez le débogage USB
3. Connectez votre téléphone via USB
4. Exécutez :
```bash
flutter devices  # Vérifier que votre appareil est détecté
flutter run
```

**iOS :**
1. Connectez votre iPhone via USB
2. Faites confiance à l'ordinateur sur votre iPhone
3. Exécutez :
```bash
flutter run
```

### 5. Build APK pour Android

Pour créer un fichier APK installable :

```bash
flutter build apk --release
```

Le fichier APK sera dans : `build/app/outputs/flutter-apk/app-release.apk`

Transférez-le sur votre téléphone et installez-le.

## 📋 Checklist de Vérification

Avant de lancer l'application, vérifiez :

- [ ] Flutter est installé (`flutter --version`)
- [ ] Les dépendances sont installées (`flutter pub get`)
- [ ] Firebase est configuré (voir `SETUP_FIREBASE.md`)
- [ ] La clé NewsAPI est configurée dans `lib/services/news_service.dart`
- [ ] Un appareil/émulateur est connecté (`flutter devices`)

## 🐛 Résolution de Problèmes

### Erreur : "Firebase not initialized"

➡️ Configurez Firebase selon `SETUP_FIREBASE.md`

### Erreur : "API key invalid" ou pas de news

➡️ Vérifiez votre clé NewsAPI dans `lib/services/news_service.dart`

### Erreur : "No devices found"

➡️ Vérifiez que votre appareil est connecté :
```bash
flutter devices
```

### Erreur de build Android

➡️ Nettoyez et reconstruisez :
```bash
flutter clean
flutter pub get
flutter run
```

### L'application se lance mais l'authentification ne fonctionne pas

➡️ Vérifiez :
1. Firebase Authentication est activé dans Firebase Console
2. La méthode Email/Password est activée
3. `google-services.json` est bien placé dans `android/app/`

## 📱 Test sur Téléphone via QR Code

### Option 1 : Flutter Web (si configuré)

```bash
flutter run -d chrome
```

Puis scannez le QR code affiché dans la console avec votre téléphone.

### Option 2 : AppFlowy / Flutter DevTools

Utilisez Flutter DevTools pour générer un QR code de connexion.

### Option 3 : APK (Recommandé)

1. Build l'APK :
```bash
flutter build apk --release
```

2. Transférez `build/app/outputs/flutter-apk/app-release.apk` sur votre téléphone

3. Installez l'APK (autorisez l'installation depuis des sources inconnues)

4. Lancez l'application

## 🎯 Fonctionnalités à Tester

1. **Authentification**
   - Créer un compte
   - Se connecter
   - Se déconnecter

2. **Navigation**
   - Naviguer entre World, Maroc, Sports, Profil
   - Vérifier que les onglets fonctionnent

3. **News Swipeables**
   - Swiper vers la droite (like)
   - Swiper vers la gauche (ignore)
   - Vérifier les animations

4. **Profil**
   - Voir les news likées
   - Changer la photo de profil (optionnel)

## 📞 Support

Si vous rencontrez des problèmes :

1. Vérifiez les logs : `flutter run -v` (mode verbose)
2. Consultez le README.md
3. Vérifiez la configuration Firebase et NewsAPI

---

**Bon test ! 🚀**



