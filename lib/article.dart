import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleDetailPage({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article['title'] ?? 'Article Detail',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article['urlToImage'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    article['urlToImage'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 80),
                  ),
                )
              else
                Icon(Icons.image, size: 200),
              SizedBox(height: 16),
              Text(
                article['title'] ?? 'No Title',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                article['content'] ?? 'No Content Available',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}