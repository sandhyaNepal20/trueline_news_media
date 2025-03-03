import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // Sample news data (You can replace this with real data)
  final List<Map<String, String>> newsData = [
    {
      'title':
          'Prime Minister Oli, Foreign Minister Deuba brief President Paudel on China visit',
      'category': 'Politics',
      'date': '2024-12-12',
      'image': 'assets/images/news1.jpg',
    },
    {
      'title': 'FNJ election today',
      'category': 'Politics',
      'date': '2024-12-13',
      'image': 'assets/images/news6.png',
    },
    {
      'title':
          'Park Police say no more major crimes reported along San Antonio trails',
      'category': 'World News',
      'date': '2024-12-12',
      'image': 'assets/images/news5.png',
    },
    {
      'title': 'Goat Life: How Indian Cinema Neglects Social Issues',
      'category': 'World News',
      'date': '2024-11-30',
      'image': 'assets/images/news3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search news...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        // Implement search functionality if needed
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // News Cards List
              Expanded(
                child: ListView.builder(
                  itemCount: newsData.length,
                  itemBuilder: (context, index) {
                    final news = newsData[index];

                    // Filter news based on search query
                    if (searchQuery.isNotEmpty &&
                        !news['title']!.toLowerCase().contains(searchQuery)) {
                      return const SizedBox.shrink();
                    }

                    return _buildNewsCard(
                      title: news['title']!,
                      category: news['category']!,
                      date: news['date']!,
                      imagePath: news['image']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String category,
    required String date,
    required String imagePath,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              height: 100,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          // News Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$category - $date',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
