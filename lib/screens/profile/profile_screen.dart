import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../controllers/auth_controller.dart';
import '../../controllers/news_controller.dart';
import '../../widgets/liked_news_item.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(context, listen: false);
      final newsController = Provider.of<NewsController>(context, listen: false);
      if (authController.isAuthenticated) {
        newsController.fetchLikedNews(authController.currentUser!.uid);
      }
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final authController =
          Provider.of<AuthController>(context, listen: false);
      // Ici, vous devriez uploader l'image vers Firebase Storage
      // Pour simplifier, on met juste le chemin local
      // await authController.updateProfile(image.path);
    }
  }

  Future<void> _handleLogout() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, _) {
          if (!authController.isAuthenticated) {
            return const Center(child: Text('Non connecté'));
          }

          final user = authController.currentUser!;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Photo de profil
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 20),
                          color: Colors.white,
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Nom
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                // Email
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),
                // Historique des news likées
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'News likées',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Consumer<NewsController>(
                  builder: (context, newsController, _) {
                    if (newsController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final likedNews = newsController.likedNews;

                    if (likedNews.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucune news likée',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: likedNews.length,
                      itemBuilder: (context, index) {
                        return LikedNewsItem(news: likedNews[index]);
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                // Bouton logout
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Déconnexion'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}



