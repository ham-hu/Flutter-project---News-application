import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news_model.dart';
import 'local_db_service.dart';

class NewsService {
  final LocalDbService _db = LocalDbService();
  // Remplacez par votre clé API NewsAPI
  final String apiKey = '';
  final String baseUrl = 'https://newsapi.org/v2';

  // Récupérer les news depuis l'API
  Future<List<NewsModel>> fetchNewsFromAPI(String category) async {
    try {
      String endpoint = '';
      
      switch (category) {
        case 'world':
          endpoint = '$baseUrl/top-headlines?category=general&language=en&pageSize=20&apiKey=$apiKey';
          break;
       case 'morocco':
          endpoint =
              '$baseUrl/everything?q=maroc OR morocco&language=fr&pageSize=20&apiKey=$apiKey';
          break;
        case 'sports':
          endpoint = '$baseUrl/top-headlines?category=sports&language=en&pageSize=20&apiKey=$apiKey';
          break;
        default:
          endpoint = '$baseUrl/top-headlines?language=en&pageSize=20&apiKey=$apiKey';
      }

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> articles = data['articles'] ?? [];

        List<NewsModel> newsList = articles
            .where((article) =>
                article['title'] != null &&
                article['description'] != null &&
                article['title'] != '[Removed]')
            .map((article) {
          Map<String, dynamic> articleData = Map<String, dynamic>.from(article);
          articleData['category'] = category;
          return NewsModel.fromMap(articleData);
        }).toList();

        // Sauvegarder dans la base locale
        await _saveNewsToLocal(newsList, category);

        return newsList;
      } else {
        // En cas d'erreur API, récupérer depuis la base locale
        return await fetchNewsFromLocal(category);
      }
    } catch (e) {
      // En cas d'erreur, récupérer depuis la base locale
      return await fetchNewsFromLocal(category);
    }
  }

  // Sauvegarder les news dans la base locale
  Future<void> _saveNewsToLocal(
      List<NewsModel> newsList, String category) async {
    try {
      await _db.insertNewsList(newsList);
    } catch (e) {
      print('Erreur lors de la sauvegarde: $e');
    }
  }

  // Récupérer les news depuis la base locale
  Future<List<NewsModel>> fetchNewsFromLocal(String category) async {
    try {
      return await _db.getNewsByCategory(category, limit: 20);
    } catch (e) {
      return [];
    }
  }

  // Alias pour compatibilité
  Future<List<NewsModel>> fetchNewsFromFirestore(String category) async {
    return await fetchNewsFromLocal(category);
  }

  // Ajouter une news likée
  Future<void> likeNews(String userId, NewsModel news) async {
    try {
      await _db.likeNews(userId, news);
    } catch (e) {
      throw Exception('Erreur lors du like: ${e.toString()}');
    }
  }

  // Retirer un like
  Future<void> unlikeNews(String userId, String newsId) async {
    try {
      await _db.unlikeNews(userId, newsId);
    } catch (e) {
      throw Exception('Erreur lors du unlike: ${e.toString()}');
    }
  }

  // Récupérer les news likées
  Future<List<NewsModel>> getLikedNews(String userId) async {
    try {
      return await _db.getLikedNews(userId);
    } catch (e) {
      return [];
    }
  }

  // Vérifier si une news est likée
  Future<bool> isNewsLiked(String userId, String newsId) async {
    try {
      return await _db.isNewsLiked(userId, newsId);
    } catch (e) {
      return false;
    }
  }
}
