import '../models/user_model.dart';
import 'local_auth_service.dart';

class AuthService {
  final LocalAuthService _localAuth = LocalAuthService();

  UserModel? get currentUser => _localAuth.currentUser;

  Stream<UserModel?> get authStateChanges => _localAuth.authStateChanges;

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _localAuth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      return await _localAuth.signUpWithEmailAndPassword(name, email, password);
    } catch (e) {
      throw Exception('Erreur d\'inscription: ${e.toString()}');
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      return await _localAuth.getUserData(uid);
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _localAuth.updateUserProfile(uid, data);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _localAuth.signOut();
  }
}
