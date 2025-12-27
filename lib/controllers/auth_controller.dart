import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthController() {
    _initAuth();
  }

  void _initAuth() {
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        try {
          _currentUser = await _authService.getUserData(user.uid);
        } catch (e) {
          _errorMessage = 'Erreur lors de la récupération des données: ${e.toString()}';
          _currentUser = null;
        }
        notifyListeners();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _authService.signInWithEmailAndPassword(
          email, password);

      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser =
          await _authService.signUpWithEmailAndPassword(name, email, password);

      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProfile(String? photoUrl) async {
    if (_currentUser == null) return;

    try {
      await _authService.updateUserProfile(_currentUser!.uid, {
        'photoUrl': photoUrl,
      });
      _currentUser = _currentUser!.copyWith(photoUrl: photoUrl);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


