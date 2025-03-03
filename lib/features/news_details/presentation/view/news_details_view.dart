import 'package:flutter/material.dart';

class NewsDetailsView extends StatelessWidget {
  final Map<String, String?> newsData; // ✅ Allow null values

  const NewsDetailsView({
    super.key,
    required this.newsData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **News Image**
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  newsData['image'] ?? '', // ✅ Handle null image
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 100, color: Colors.grey);
                  },
                ),
              ),
              const SizedBox(height: 15),

              // **Category & Date**
              Text(
                newsData['category'] ??
                    "Uncategorized", // ✅ Handle null category
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Published on: ${newsData['date'] ?? "Unknown"}', // ✅ Handle null date
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // **Title**
              Text(
                newsData['title'] ??
                    "No Title Available", // ✅ Handle null title
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // **News Content**
              Text(
                newsData['content'] ??
                    "Content not available", // ✅ Display full content
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // **Share & Like Section**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {}, // TODO: Implement sharing feature
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {}, // TODO: Implement like feature
                      ),
                      const Text("1.2k"), // Example like count
                    ],
                  ),
                ],
              ),

              const Divider(),
              const SizedBox(height: 10),

              // **Comments Section**
              const Text(
                "Comments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    onPressed: () {}, // TODO: Implement comment posting
                    child: const Text("Publish"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
