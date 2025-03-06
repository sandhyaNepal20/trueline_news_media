import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailsView extends StatefulWidget {
  final Map<String, String?> newsData;

  const NewsDetailsView({super.key, required this.newsData});

  @override
  _NewsDetailsViewState createState() => _NewsDetailsViewState();
}

class _NewsDetailsViewState extends State<NewsDetailsView> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNews = prefs.getStringList('saved_news') ?? [];
    setState(() {
      isSaved = savedNews.contains(jsonEncode(widget.newsData));
    });
  }

  Future<void> _toggleSaveNews() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedNews = prefs.getStringList('saved_news') ?? [];
    final newsString = jsonEncode(widget.newsData);

    setState(() {
      if (isSaved) {
        savedNews.remove(newsString);
      } else {
        savedNews.add(newsString);
      }
      isSaved = !isSaved;
    });

    await prefs.setStringList('saved_news', savedNews);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: const Color(0xFF004AAD),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? screenWidth * 0.1 : 16,
          vertical: isTablet ? 30 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.newsData['image'] ?? '',
                width: double.infinity,
                height: isTablet ? 450 : 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 100, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.newsData['category'] ?? "Uncategorized",
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Published on: ${widget.newsData['date'] ?? "Unknown"}',
              style:
                  TextStyle(fontSize: isTablet ? 18 : 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              widget.newsData['title'] ?? "No Title Available",
              style: TextStyle(
                fontSize: isTablet ? 28 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.newsData['content'] ?? "Content not available",
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: isTablet ? 40 : 32,
                    color: Colors.black,
                  ),
                  onPressed: _toggleSaveNews,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              "Comments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type your comment here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16 : 10,
                      horizontal: isTablet ? 24 : 12,
                    ),
                  ),
                  child: Text(
                    "Publish",
                    style: TextStyle(fontSize: isTablet ? 20 : 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
