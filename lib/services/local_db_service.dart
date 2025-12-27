import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/news_model.dart';

// Import conditionnel pour SQLite (mobile uniquement)
import 'package:sqflite/sqflite.dart' if (dart.library.html) 'local_db_service_stub.dart';
import 'package:path/path.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._internal();
  factory LocalDbService() => _instance;
  LocalDbService._internal();

  SharedPreferences? _prefs;
  Database? _database;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Utiliser SQLite sur mobile, SharedPreferences sur web
  bool get _useSQLite => !kIsWeb;

  // ========== Initialisation ==========

  Future<void> _init() async {
    if (_useSQLite) {
      await _initSQLite();
    } else {
      await prefs;
    }
  }

  Future<void> _initSQLite() async {
    if (_database != null) return;
    String path = join(await getDatabasesPath(), 'news_app.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateSQLite,
    );
  }

  Future<void> _onCreateSQLite(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        uid TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        photoUrl TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE news (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT,
        source TEXT NOT NULL,
        publishedAt TEXT NOT NULL,
        url TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE liked_news (
        userId TEXT NOT NULL,
        newsId TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT,
        source TEXT NOT NULL,
        publishedAt TEXT NOT NULL,
        url TEXT NOT NULL,
        category TEXT NOT NULL,
        PRIMARY KEY (userId, newsId)
      )
    ''');

    await db.execute('CREATE INDEX idx_news_category ON news(category)');
    await db.execute('CREATE INDEX idx_news_publishedAt ON news(publishedAt)');
    await db.execute('CREATE INDEX idx_liked_news_userId ON liked_news(userId)');
  }

  // ========== Méthodes pour les utilisateurs ==========

  Future<void> insertUser(UserModel user, String password) async {
    await _init();
    
    if (_useSQLite) {
      await _database!.insert(
        'users',
        {...user.toMap(), 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      final prefs = await this.prefs;
      final usersKey = 'users_${user.email}';
      final userData = {
        ...user.toMap(),
        'password': password,
      };
      await prefs.setString(usersKey, jsonEncode(userData));
      await prefs.setString('user_email_${user.email}', user.uid);
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    await _init();
    
    if (_useSQLite) {
      final maps = await _database!.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      final map = Map<String, dynamic>.from(maps.first);
      map.remove('password');
      return UserModel.fromMap(map);
    } else {
      final prefs = await this.prefs;
      final usersKey = 'users_$email';
      final userJson = prefs.getString(usersKey);
      if (userJson == null) return null;
      final map = jsonDecode(userJson) as Map<String, dynamic>;
      map.remove('password');
      return UserModel.fromMap(map);
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    await _init();
    
    if (_useSQLite) {
      final maps = await _database!.query(
        'users',
        where: 'uid = ?',
        whereArgs: [uid],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      final map = Map<String, dynamic>.from(maps.first);
      map.remove('password');
      return UserModel.fromMap(map);
    } else {
      final prefs = await this.prefs;
      // Sur web, on doit parcourir tous les utilisateurs
      final keys = prefs.getKeys().where((k) => k.startsWith('users_'));
      for (final key in keys) {
        final userJson = prefs.getString(key);
        if (userJson != null) {
          final map = jsonDecode(userJson) as Map<String, dynamic>;
          if (map['uid'] == uid) {
            map.remove('password');
            return UserModel.fromMap(map);
          }
        }
      }
      return null;
    }
  }

  Future<String?> getUserPassword(String email) async {
    await _init();
    
    if (_useSQLite) {
      final maps = await _database!.query(
        'users',
        columns: ['password'],
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return maps.first['password'] as String?;
    } else {
      final prefs = await this.prefs;
      final usersKey = 'users_$email';
      final userJson = prefs.getString(usersKey);
      if (userJson == null) return null;
      final map = jsonDecode(userJson) as Map<String, dynamic>;
      return map['password'] as String?;
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _init();
    
    if (_useSQLite) {
      await _database!.update('users', data, where: 'uid = ?', whereArgs: [uid]);
    } else {
      final prefs = await this.prefs;
      final keys = prefs.getKeys().where((k) => k.startsWith('users_'));
      for (final key in keys) {
        final userJson = prefs.getString(key);
        if (userJson != null) {
          final map = jsonDecode(userJson) as Map<String, dynamic>;
          if (map['uid'] == uid) {
            map.addAll(data);
            await prefs.setString(key, jsonEncode(map));
            break;
          }
        }
      }
    }
  }

  // ========== Méthodes pour les news ==========

  Future<void> insertNews(NewsModel news) async {
    await _init();
    
    if (_useSQLite) {
      await _database!.insert('news', news.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      final prefs = await this.prefs;
      final newsKey = 'news_${news.id}';
      await prefs.setString(newsKey, jsonEncode(news.toMap()));
      // Garder une liste des IDs par catégorie
      final categoryKey = 'news_category_${news.category}';
      final categoryList = prefs.getStringList(categoryKey) ?? [];
      if (!categoryList.contains(news.id)) {
        categoryList.add(news.id);
        await prefs.setStringList(categoryKey, categoryList);
      }
    }
  }

  Future<void> insertNewsList(List<NewsModel> newsList) async {
    await _init();
    
    if (_useSQLite) {
      final batch = _database!.batch();
      for (var news in newsList) {
        batch.insert('news', news.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    } else {
      final prefs = await this.prefs;
      for (var news in newsList) {
        final newsKey = 'news_${news.id}';
        await prefs.setString(newsKey, jsonEncode(news.toMap()));
        final categoryKey = 'news_category_${news.category}';
        final categoryList = prefs.getStringList(categoryKey) ?? [];
        if (!categoryList.contains(news.id)) {
          categoryList.add(news.id);
          await prefs.setStringList(categoryKey, categoryList);
        }
      }
    }
  }

  Future<List<NewsModel>> getNewsByCategory(String category, {int limit = 20}) async {
    await _init();
    
    if (_useSQLite) {
      final maps = await _database!.query(
        'news',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'publishedAt DESC',
        limit: limit,
      );
      return maps.map((map) => NewsModel.fromMap(map)).toList();
    } else {
      final prefs = await this.prefs;
      final categoryKey = 'news_category_$category';
      final newsIds = prefs.getStringList(categoryKey) ?? [];
      final newsList = <NewsModel>[];
      
      for (final id in newsIds.take(limit)) {
        final newsKey = 'news_$id';
        final newsJson = prefs.getString(newsKey);
        if (newsJson != null) {
          try {
            final map = jsonDecode(newsJson) as Map<String, dynamic>;
            if (map['category'] == category) {
              newsList.add(NewsModel.fromMap(map));
            }
          } catch (e) {
            print('Erreur parsing news $id: $e');
          }
        }
      }
      
      // Trier par date
      newsList.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return newsList.take(limit).toList();
    }
  }

  // ========== Méthodes pour les news likées ==========

  Future<void> likeNews(String userId, NewsModel news) async {
    await _init();
    
    if (_useSQLite) {
      await _database!.insert(
        'liked_news',
        {'userId': userId, 'newsId': news.id, ...news.toMap()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      final prefs = await this.prefs;
      final likedKey = 'liked_${userId}_${news.id}';
      await prefs.setString(likedKey, jsonEncode(news.toMap()));
      final userLikedKey = 'user_liked_$userId';
      final likedList = prefs.getStringList(userLikedKey) ?? [];
      if (!likedList.contains(news.id)) {
        likedList.add(news.id);
        await prefs.setStringList(userLikedKey, likedList);
      }
    }
  }

  Future<void> unlikeNews(String userId, String newsId) async {
    await _init();
    
    if (_useSQLite) {
      await _database!.delete('liked_news', where: 'userId = ? AND newsId = ?', whereArgs: [userId, newsId]);
    } else {
      final prefs = await this.prefs;
      final likedKey = 'liked_${userId}_$newsId';
      await prefs.remove(likedKey);
      final userLikedKey = 'user_liked_$userId';
      final likedList = prefs.getStringList(userLikedKey) ?? [];
      likedList.remove(newsId);
      await prefs.setStringList(userLikedKey, likedList);
    }
  }

  Future<bool> isNewsLiked(String userId, String newsId) async {
    await _init();
    
    if (_useSQLite) {
      final maps = await _database!.query(
        'liked_news',
        where: 'userId = ? AND newsId = ?',
        whereArgs: [userId, newsId],
        limit: 1,
      );
      return maps.isNotEmpty;
    } else {
      final prefs = await this.prefs;
      final likedKey = 'liked_${userId}_$newsId';
      return prefs.containsKey(likedKey);
    }
  }

  Future<List<NewsModel>> getLikedNews(String userId) async {
    await _init();
    
    if (_useSQLite) {
      final maps = await _database!.query(
        'liked_news',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'publishedAt DESC',
      );
      return maps.map((map) {
        final newsMap = Map<String, dynamic>.from(map);
        newsMap.remove('userId');
        newsMap['id'] = map['newsId'];
        return NewsModel.fromMap(newsMap);
      }).toList();
    } else {
      final prefs = await this.prefs;
      final userLikedKey = 'user_liked_$userId';
      final likedIds = prefs.getStringList(userLikedKey) ?? [];
      final newsList = <NewsModel>[];
      
      for (final id in likedIds) {
        final likedKey = 'liked_${userId}_$id';
        final newsJson = prefs.getString(likedKey);
        if (newsJson != null) {
          try {
            final map = jsonDecode(newsJson) as Map<String, dynamic>;
            newsList.add(NewsModel.fromMap(map));
          } catch (e) {
            print('Erreur parsing liked news $id: $e');
          }
        }
      }
      
      newsList.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      return newsList;
    }
  }

  // ========== Méthodes utilitaires ==========

  Future<void> clearAllData() async {
    await _init();
    
    if (_useSQLite) {
      await _database!.delete('liked_news');
      await _database!.delete('news');
      await _database!.delete('users');
    } else {
      final prefs = await this.prefs;
      final keys = prefs.getKeys().toList();
      for (final key in keys) {
        if (key.startsWith('users_') || key.startsWith('news_') || key.startsWith('liked_') || key.startsWith('user_')) {
          await prefs.remove(key);
        }
      }
    }
  }

  Future<void> close() async {
    if (_useSQLite && _database != null) {
      await _database!.close();
    }
  }
}
