import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import 'local_db_service.dart';

class LocalAuthService {
  final LocalDbService _db = LocalDbService();
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  // Hash le mot de passe
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Vérifie le mot de passe
  bool _verifyPassword(String password, String hash) {
    return _hashPassword(password) == hash;
  }

  // Génère un UID unique
  String _generateUid() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           (1000 + (9999 - 1000) * (DateTime.now().microsecond / 1000000)).round().toString();
  }

  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _db.getUserByEmail(email);
      if (user == null) {
        throw Exception('Email ou mot de passe incorrect');
      }

      final storedPassword = await _db.getUserPassword(email);
      if (storedPassword == null || !_verifyPassword(password, storedPassword)) {
        throw Exception('Email ou mot de passe incorrect');
      }

      _currentUser = user;
      _authStateController.add(user);
      return user;
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(String name, String email, String password) async {
    try {
      // Vérifier si l'email existe déjà
      final existingUser = await _db.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Cet email est déjà utilisé');
      }

      final hashedPassword = _hashPassword(password);
      final uid = _generateUid();

      final userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _db.insertUser(userModel, hashedPassword);

      _currentUser = userModel;
      _authStateController.add(userModel);
      return userModel;
    } catch (e) {
      throw Exception('Erreur d\'inscription: ${e.toString()}');
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      return await _db.getUserById(uid);
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _db.updateUser(uid, data);
      // Mettre à jour l'utilisateur actuel
      final updatedUser = await _db.getUserById(uid);
      if (updatedUser != null) {
        _currentUser = updatedUser;
        _authStateController.add(updatedUser);
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}

