# 🚀 Démarrage Rapide

## ⚡ Installation en 5 minutes

### 1. Installer les dépendances

```bash
flutter pub get
```

### 2. Configurer Firebase

**Option A : FlutterFire CLI (Recommandé)**

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

**Option B : Manuel**

1. Téléchargez `google-services.json` depuis Firebase Console
2. Placez-le dans `android/app/google-services.json`
3. Modifiez `lib/firebase_options.dart` avec vos clés Firebase

### 3. Configurer NewsAPI

1. Créez un compte sur [newsapi.org](https://newsapi.org) (gratuit)
2. Obtenez votre clé API
3. Modifiez `lib/services/news_service.dart` ligne 8 :

```dart
final String apiKey = 'VOTRE_CLE_API';
```

### 4. Lancer l'application

```bash
flutter run
```

## ✅ Vérification

- [ ] `flutter pub get` exécuté sans erreur
- [ ] Firebase configuré (voir `SETUP_FIREBASE.md`)
- [ ] Clé NewsAPI configurée
- [ ] Appareil/émulateur connecté (`flutter devices`)

## 🎯 Test Rapide

1. Lancez l'app : `flutter run`
2. Créez un compte avec email/mot de passe
3. Naviguez entre les onglets (World, Maroc, Sports)
4. Swipez les cartes de news (droite = like, gauche = ignore)
5. Vérifiez votre profil et les news likées

## 📱 Build APK

```bash
flutter build apk --release
```

APK dans : `build/app/outputs/flutter-apk/app-release.apk`

---

**Besoin d'aide ?** Consultez `README.md` ou `INSTRUCTIONS.md`



