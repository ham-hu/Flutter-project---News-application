# Base de Données Locale - Guide d'utilisation

## ✅ Migration terminée

Le projet a été migré de Firebase vers une base de données locale SQLite. Vous pouvez maintenant utiliser l'application sans configuration Firebase.

## 📦 Installation

### 1. Installer les dépendances

```bash
flutter pub get
```

Les nouvelles dépendances ajoutées :
- `sqflite` : Base de données SQLite pour Flutter
- `path` : Gestion des chemins de fichiers
- `crypto` : Hashage des mots de passe (SHA-256)

### 2. Lancer l'application

```bash
flutter run
```

## 🗄️ Structure de la base de données

La base de données SQLite (`news_app.db`) contient 3 tables :

### Table `users`
- `uid` : Identifiant unique de l'utilisateur
- `name` : Nom complet
- `email` : Email (unique)
- `password` : Mot de passe hashé (SHA-256)
- `photoUrl` : URL de la photo de profil (optionnel)
- `createdAt` : Date de création

### Table `news`
- `id` : Identifiant unique de la news
- `title` : Titre
- `description` : Description
- `imageUrl` : URL de l'image (optionnel)
- `source` : Source de la news
- `publishedAt` : Date de publication
- `url` : URL de l'article
- `category` : Catégorie ('world', 'morocco', 'sports')

### Table `liked_news`
- `userId` : ID de l'utilisateur
- `newsId` : ID de la news
- Tous les champs de la news (pour un accès rapide)

## 🔐 Authentification locale

### Fonctionnalités
- ✅ Inscription avec email et mot de passe
- ✅ Connexion avec vérification du mot de passe
- ✅ Hashage sécurisé des mots de passe (SHA-256)
- ✅ Gestion de session
- ✅ Mise à jour du profil

### Sécurité
- Les mots de passe sont hashés avec SHA-256 avant stockage
- Les emails doivent être uniques
- Pas de mots de passe en clair dans la base de données

## 📱 Utilisation

### Créer un compte
1. Allez sur l'écran d'inscription
2. Remplissez le formulaire
3. Cliquez sur "S'inscrire"
4. Le compte est créé localement dans SQLite

### Se connecter
1. Entrez votre email et mot de passe
2. Cliquez sur "Se connecter"
3. Vous êtes authentifié localement

### Compte de test
Utilisez le bouton "Remplir identifiants de test" pour :
- Email : `test@example.com`
- Mot de passe : `test123`

## 🔄 Synchronisation des news

Les news sont récupérées depuis l'API NewsAPI et sauvegardées localement :
- Si l'API fonctionne : les news sont récupérées et mises en cache localement
- Si l'API échoue : les news sont récupérées depuis le cache local

## 📍 Emplacement de la base de données

La base de données est stockée localement sur l'appareil :
- **Android** : `/data/data/com.example.news_app/databases/news_app.db`
- **iOS** : Dans le répertoire Documents de l'application

## 🛠️ Maintenance

### Réinitialiser la base de données

Si vous voulez supprimer toutes les données :

```dart
final db = LocalDbService();
await db.clearAllData();
```

### Voir la base de données

Vous pouvez utiliser un outil comme [DB Browser for SQLite](https://sqlitebrowser.org/) pour visualiser la base de données.

## ⚠️ Notes importantes

1. **Pas de synchronisation cloud** : Les données sont uniquement locales
2. **Pas de récupération de compte** : Si vous supprimez l'application, les données sont perdues
3. **Pas de partage entre appareils** : Chaque appareil a sa propre base de données
4. **NewsAPI** : Vous devez toujours configurer votre clé API NewsAPI pour récupérer les actualités

## 🚀 Avantages de la base locale

- ✅ Fonctionne sans internet (après le premier chargement)
- ✅ Pas de configuration Firebase nécessaire
- ✅ Données stockées localement (privacy)
- ✅ Performance rapide
- ✅ Pas de coûts de serveur

## 📝 Migration depuis Firebase

Si vous aviez des données dans Firebase, elles ne seront pas automatiquement migrées. Vous devrez :
1. Recréer vos comptes utilisateurs
2. Les news seront rechargées depuis l'API

## 🐛 Dépannage

### Erreur "database locked"
- Fermez et rouvrez l'application
- Vérifiez qu'aucun autre processus n'utilise la base

### Erreur de connexion
- Vérifiez que le compte existe (créez-le d'abord)
- Vérifiez que le mot de passe est correct

### News ne se chargent pas
- Vérifiez votre connexion internet
- Vérifiez votre clé API NewsAPI
- Les news en cache seront affichées si l'API échoue

---

**L'application est maintenant entièrement locale et fonctionne sans Firebase ! 🎉**

