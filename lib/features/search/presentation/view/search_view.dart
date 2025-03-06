import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:trueline_news_media/features/news_details/presentation/view/news_details_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // Adjust horizontal padding based on device type
    final horizontalPadding = isTablet ? screenWidth * 0.15 : 16.0;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 20), // Pushes search bar slightly down
              _buildSearchBar(isTablet),
              const SizedBox(height: 25), // More spacing before search results
              Expanded(
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    // Show nothing until the user types a query
                    if (searchQuery.isEmpty) {
                      return const Center(
                        child: Text(
                          "Search for news...",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.error != null) {
                      return Center(child: Text('Error: ${state.error}'));
                    }

                    List<NewsEntity> filteredNews = state.news.where((news) {
                      return news.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                    }).toList();

                    if (filteredNews.isEmpty) {
                      return const Center(
                        child: Text("No news found matching your search."),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredNews.length,
                      itemBuilder: (context, index) {
                        return _buildNewsCard(filteredNews[index], isTablet);
                      },
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

  Widget _buildSearchBar(bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(30), // Rounded corners for modern look
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4), // Shadow effect
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search news...",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {}, // Search updates automatically on text change
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(NewsEntity news, bool isTablet) {
    return GestureDetector(
      onTap: () => _navigateToNewsDetails(news),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: isTablet ? 15 : 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                "http://10.0.2.2:3000/news_image/${news.image}",
                height: isTablet ? 120 : 100,
                width: isTablet ? 140 : 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.broken_image,
                  size: isTablet ? 120 : 100,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 15.0 : 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 18 : 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${news.categoryId?.categoryName} - ${news.created_at}',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNewsDetails(NewsEntity newsItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsView(
          newsData: {
            'title': newsItem.title,
            'category': newsItem.categoryId?.categoryName,
            'content': newsItem.content,
            'date': newsItem.created_at,
            'image': "http://10.0.2.2:3000/news_image/${newsItem.image}",
          },
        ),
      ),
    );
  }
}
