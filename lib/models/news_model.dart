class NewsModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String source;
  final DateTime publishedAt;
  final String url;
  final String category; // 'world', 'morocco', 'sports'

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.url,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt.toIso8601String(),
      'url': url,
      'category': category,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'] ?? map['url'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? map['urlToImage'],
      source: map['source'] is String
          ? map['source']
          : map['source']?['name'] ?? 'Unknown',
      publishedAt: map['publishedAt'] != null
          ? DateTime.parse(map['publishedAt'])
          : DateTime.now(),
      url: map['url'] ?? '',
      category: map['category'] ?? 'world',
    );
  }

  NewsModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? source,
    DateTime? publishedAt,
    String? url,
    String? category,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      publishedAt: publishedAt ?? this.publishedAt,
      url: url ?? this.url,
      category: category ?? this.category,
    );
  }
}



