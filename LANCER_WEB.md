# 🌐 Lancer l'application dans le navigateur (localhost)

## 🚀 Méthode rapide

### Option 1 : Chrome (recommandé)

```bash
flutter run -d chrome
```

L'application s'ouvrira automatiquement dans Chrome sur `http://localhost:port`

### Option 2 : Port personnalisé

```bash
flutter run -d chrome --web-port=3000
```

L'application sera accessible sur `http://localhost:3000`

### Option 3 : Edge

```bash
flutter run -d edge
```

## 📋 Prérequis

1. **Flutter Web activé** ✅ (déjà fait)
2. **Chrome ou Edge installé**
3. **Dépendances installées** :
   ```bash
   flutter pub get
   ```

## 🔧 Configuration

### Base de données

L'application utilise automatiquement :
- **SQLite** sur mobile (Android/iOS)
- **SharedPreferences** sur web (navigateur)

Aucune configuration supplémentaire n'est nécessaire !

## 🌍 Accéder depuis un autre appareil (même réseau)

Si vous voulez accéder depuis votre téléphone sur le même réseau WiFi :

1. **Trouvez votre adresse IP locale** :
   ```bash
   # Windows PowerShell
   ipconfig
   
   # Cherchez "Adresse IPv4" (ex: 192.168.1.100)
   ```

2. **Lancez Flutter avec l'option host** :
   ```bash
   flutter run -d chrome --web-hostname=0.0.0.0 --web-port=3000
   ```

3. **Sur votre téléphone**, ouvrez dans le navigateur :
   ```
   http://VOTRE_IP:3000
   ```
   Exemple : `http://192.168.1.100:3000`

## 📱 QR Code pour accès mobile

Une fois l'application lancée :

1. **Notez l'URL** affichée dans la console (ex: `http://192.168.1.100:3000`)
2. **Générez un QR Code** avec cette URL :
   - https://www.qr-code-generator.com/
   - https://qr-code-generator.com/
   - Ou utilisez une extension Chrome "QR Code Generator"
3. **Scannez le QR Code** avec votre téléphone
4. L'application s'ouvrira dans le navigateur de votre téléphone

## 🐛 Dépannage

### Erreur : "Port déjà utilisé"
```bash
# Utilisez un autre port
flutter run -d chrome --web-port=3001
```

### Erreur : "No devices found"
```bash
flutter devices
```
Vérifiez que Chrome/Edge est détecté.

### L'application ne se charge pas
1. Vérifiez la console pour les erreurs
2. Essayez de vider le cache du navigateur (Ctrl+Shift+Delete)
3. Redémarrez Flutter :
   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```

### Erreur SQLite sur web
C'est normal ! L'application utilise automatiquement SharedPreferences sur web. Aucune action nécessaire.

## ✅ Vérification

Une fois lancé, vous devriez voir :
- ✅ L'application s'ouvre dans Chrome
- ✅ L'URL dans la barre d'adresse (ex: `http://localhost:3000`)
- ✅ L'écran de démarrage de l'application
- ✅ Vous pouvez créer un compte et vous connecter

## 📝 Notes importantes

- **Données stockées** : Dans le **LocalStorage** du navigateur
- **Effacement des données** : Si vous effacez les données du navigateur, les comptes seront supprimés
- **Hors ligne** : L'application fonctionne entièrement hors ligne après le premier chargement
- **Cache** : Les news sont mises en cache localement
- **Multi-navigateurs** : Chaque navigateur a ses propres données (pas de partage entre Chrome et Edge)

## 🎯 Commandes utiles

```bash
# Lister les appareils disponibles
flutter devices

# Lancer sur Chrome (port par défaut)
flutter run -d chrome

# Lancer sur Chrome (port 3000)
flutter run -d chrome --web-port=3000

# Lancer avec accès réseau (pour téléphone)
flutter run -d chrome --web-hostname=0.0.0.0 --web-port=3000

# Build pour production web
flutter build web
```

## 📦 Build pour production

Pour créer une version de production :

```bash
flutter build web
```

Les fichiers seront dans `build/web/`. Vous pouvez les déployer sur n'importe quel serveur web.

---

**L'application est maintenant accessible dans votre navigateur ! 🎉**

**URL par défaut** : `http://localhost:port` (le port est affiché dans la console)
