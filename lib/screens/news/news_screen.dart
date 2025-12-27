import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/news_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/swipeable_news_stack.dart';

class NewsScreen extends StatefulWidget {
  final String category;
  final String title;

  const NewsScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsController = Provider.of<NewsController>(context, listen: false);
      if (newsController.getNewsByCategory(widget.category).isEmpty) {
        newsController.fetchNews(widget.category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<NewsController>(
        builder: (context, newsController, _) {
          if (newsController.isLoading &&
              newsController.getNewsByCategory(widget.category).isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final newsList = newsController.getNewsByCategory(widget.category);

          if (newsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune news disponible',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      newsController.fetchNews(widget.category);
                    },
                    child: const Text('Actualiser'),
                  ),
                ],
              ),
            );
          }

          return SwipeableNewsStack(
            newsList: newsList,
            onSwipeRight: () {
              final authController =
                  Provider.of<AuthController>(context, listen: false);
              if (authController.isAuthenticated && newsList.isNotEmpty) {
                final currentNews = newsList[0];
                newsController.likeNews(
                  authController.currentUser!.uid,
                  currentNews,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('News likée ! ❤️'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            onSwipeLeft: () {
              // Ignorer la news
            },
            onStackEmpty: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toutes les news ont été parcourues. Actualisez pour en voir plus !'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

