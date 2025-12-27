import 'package:flutter/foundation.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsController extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  
  List<NewsModel> _worldNews = [];
  List<NewsModel> _moroccoNews = [];
  List<NewsModel> _sportsNews = [];
  List<NewsModel> _likedNews = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCategory = 'world';

  List<NewsModel> get worldNews => _worldNews;
  List<NewsModel> get moroccoNews => _moroccoNews;
  List<NewsModel> get sportsNews => _sportsNews;
  List<NewsModel> get likedNews => _likedNews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentCategory => _currentCategory;

  List<NewsModel> getNewsByCategory(String category) {
    switch (category) {
      case 'world':
        return _worldNews;
      case 'morocco':
        return _moroccoNews;
      case 'sports':
        return _sportsNews;
      default:
        return _worldNews;
    }
  }

  Future<void> fetchNews(String category) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentCategory = category;
      notifyListeners();

      List<NewsModel> news = await _newsService.fetchNewsFromAPI(category);

      switch (category) {
        case 'world':
          _worldNews = news;
          break;
        case 'morocco':
          _moroccoNews = news;
          break;
        case 'sports':
          _sportsNews = news;
          break;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchAllNews() async {
    await Future.wait([
      fetchNews('world'),
      fetchNews('morocco'),
      fetchNews('sports'),
    ]);
  }

  Future<void> likeNews(String userId, NewsModel news) async {
    try {
      await _newsService.likeNews(userId, news);
      if (!_likedNews.any((n) => n.id == news.id)) {
        _likedNews.add(news);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchLikedNews(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _likedNews = await _newsService.getLikedNews(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}



