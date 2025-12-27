import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'news_card_content.dart';

class SwipeableNewsStack extends StatefulWidget {
  final List<NewsModel> newsList;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;
  final VoidCallback? onStackEmpty;

  const SwipeableNewsStack({
    super.key,
    required this.newsList,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    this.onStackEmpty,
  });

  @override
  State<SwipeableNewsStack> createState() => _SwipeableNewsStackState();
}

class _SwipeableNewsStackState extends State<SwipeableNewsStack>
    with TickerProviderStateMixin {
  late List<NewsModel> _remainingNews;
  int _currentIndex = 0;
  Offset _position = Offset.zero;
  double _angle = 0.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _remainingNews = List.from(widget.newsList);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      _angle = _position.dx * 0.01;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final swipeThreshold = 100.0;
    final velocity = details.velocity.pixelsPerSecond.dx;

    if (_position.dx.abs() > swipeThreshold || velocity.abs() > 500) {
      if (_position.dx > 0) {
        // Swipe droite - Like
        _swipeCard(true);
      } else {
        // Swipe gauche - Ignore
        _swipeCard(false);
      }
    } else {
      // Retour à la position initiale
      _resetCard();
    }
  }

  void _swipeCard(bool isRight) {
    _controller.forward().then((_) {
      if (isRight) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }

      setState(() {
        _currentIndex++;
        _position = Offset.zero;
        _angle = 0.0;
      });

      _controller.reset();

      if (_currentIndex >= _remainingNews.length) {
        widget.onStackEmpty?.call();
      }
    });
  }

  void _resetCard() {
    _controller.forward().then((_) {
      setState(() {
        _position = Offset.zero;
        _angle = 0.0;
      });
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingNews.isEmpty || _currentIndex >= _remainingNews.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Toutes les news ont été parcourues',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final currentNews = _remainingNews[_currentIndex];
    final nextNewsIndex = _currentIndex + 1;
    final hasNext = nextNewsIndex < _remainingNews.length;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Carte suivante (en arrière-plan)
        if (hasNext)
          Transform.scale(
            scale: 0.95,
            child: Opacity(
              opacity: 0.7,
              child: NewsCardContent(news: _remainingNews[nextNewsIndex]),
            ),
          ),
        // Carte actuelle
        Positioned(
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Transform.translate(
              offset: _position,
              child: Transform.rotate(
                angle: _angle,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_controller.value * 0.1),
                      child: Opacity(
                        opacity: 1.0 - _controller.value,
                        child: NewsCardContent(news: currentNews),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        // Indicateurs de swipe
        if (_position.dx.abs() > 10)
          Positioned(
            top: 50,
            child: _position.dx > 0
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(204),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'LIKE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(204),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.close, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'PASS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
      ],
    );
  }
}

