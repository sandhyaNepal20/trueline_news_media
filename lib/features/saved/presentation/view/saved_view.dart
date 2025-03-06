import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trueline_news_media/features/news_details/presentation/view/news_details_view.dart';

class SaveView extends StatefulWidget {
  const SaveView({super.key});

  @override
  State<SaveView> createState() => _SaveViewState();
}

class _SaveViewState extends State<SaveView> {
  List<Map<String, String?>> savedNews = [];

  @override
  void initState() {
    super.initState();
    _loadSavedNews();
  }

  /// **Load saved news from SharedPreferences**
  Future<void> _loadSavedNews() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedNewsList = prefs.getStringList('saved_news') ?? [];
    setState(() {
      savedNews = savedNewsList
          .map((news) => Map<String, String?>.from(jsonDecode(news)))
          .toList();
    });
  }

  /// **Remove news from saved items**
  Future<void> _removeSavedNews(Map<String, String?> newsItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedNewsList = prefs.getStringList('saved_news') ?? [];
    savedNewsList.remove(jsonEncode(newsItem));
    await prefs.setStringList('saved_news', savedNewsList);
    setState(() {
      savedNews.remove(newsItem);
    });
  }

  void _navigateToNewsDetails(Map<String, String?> newsItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsView(newsData: newsItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      body: savedNews.isEmpty
          ? const Center(child: Text('No saved news available'))
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24.0 : 10.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: savedNews.length,
                itemBuilder: (context, index) {
                  final news = savedNews[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.all(isTablet ? 20 : 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(isTablet ? 16.0 : 10.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          news['image'] ?? '',
                          width: isTablet ? 120 : 80,
                          height: isTablet ? 120 : 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            size: isTablet ? 60 : 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      title: Text(
                        news['title'] ?? 'No Title',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: isTablet ? 20 : 16),
                      ),
                      subtitle: Text(
                        news['category'] ?? 'Uncategorized',
                        style: TextStyle(fontSize: isTablet ? 18 : 14),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: Colors.red, size: isTablet ? 30 : 24),
                        onPressed: () => _removeSavedNews(news),
                      ),
                      onTap: () => _navigateToNewsDetails(news),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
