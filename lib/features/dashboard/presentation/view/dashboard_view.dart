import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:trueline_news_media/features/myprofile/presentation/view/myprofile_view.dart';
import 'package:trueline_news_media/features/news_details/presentation/view/news_details_view.dart';
import 'package:trueline_news_media/features/saved/presentation/view/saved_view.dart';
import 'package:trueline_news_media/features/search/presentation/view/search_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final int _selectedIndex = 0;
  String selectedCategory = 'All';

  List<Widget> lstBottomScreen = [
    const SearchView(),
    const SaveView(),
    const MyProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadNews()); // Fetch news on load
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            body: _selectedIndex == 0
                ? BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.error != null) {
                        return Center(child: Text('Error: ${state.error}'));
                      } else if (state.news.isEmpty) {
                        return const Center(child: Text('No news available'));
                      }

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryButtons(),
                              const SizedBox(height: 20),
                              _buildHighlightedNews(state.news),
                              const SizedBox(height: 20),
                              _buildLatestNews(
                                  state.news, constraints.maxWidth),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : lstBottomScreen[_selectedIndex],
          ),
        );
      },
    );
  }

  Widget _buildCategoryButtons() {
    List<String> categories = [
      'All',
      'Politics',
      'Sports',
      'Education',
      'Technology',
      'Entertainment',
      'Science'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map((category) => _buildCategoryButton(category))
            .toList(),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category
              ? const Color(0xFF004AAD)
              : Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          category,
          style: TextStyle(
              color: selectedCategory == category
                  ? Colors.white
                  : const Color(0xFF004AAD)),
        ),
      ),
    );
  }

  Widget _buildHighlightedNews(List<NewsEntity> news) {
    final highlightedNews = news.first;

    return GestureDetector(
      onTap: () => _navigateToNewsDetails(highlightedNews),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
                "http://192.168.1.81:3000/news_image/${highlightedNews.image}"),
            fit: BoxFit.cover,
          ),
        ),
        height: 380,
      ),
    );
  }

  Widget _buildLatestNews(List<NewsEntity> news, double screenWidth) {
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest News',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: news.length,
          itemBuilder: (context, index) {
            return _buildNewsCard(news[index]);
          },
        ),
      ],
    );
  }

  Widget _buildNewsCard(NewsEntity newsItem) {
    return GestureDetector(
      onTap: () => _navigateToNewsDetails(newsItem),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                "http://192.168.1.81:3000/news_image/${newsItem.image}",
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(newsItem.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 19)),
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
            'category': newsItem.categoryId?.categoryName ??
                "Uncategorized", // ✅ Safe null handling
            'date': newsItem.created_at,
            'content': newsItem.content, // ✅ Added content field

            'image': "http://192.168.1.81:3000/news_image/${newsItem.image}",
          },
        ),
      ),
    );
  }
}
