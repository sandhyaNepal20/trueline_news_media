import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
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
  // Sensor variables for parallax effect
  Offset offset = Offset.zero;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

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
    // Fetch news and categories when the view is initialized.
    context.read<DashboardBloc>().add(LoadNews());
    context.read<DashboardBloc>().add(LoadCategories());

    // Subscribe to accelerometer events to get sensor data.
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      // Adjust the multiplier as needed for the desired movement sensitivity.
      double dx = event.x * 5.0;
      double dy = event.y * 5.0;
      setState(() {
        offset = Offset(dx, dy);
      });
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive UI adjustments.
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Wrap the dashboard content in a Transform widget using the sensor offset.
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryButtons(),
        Expanded(
          child: _selectedIndex == 0
              ? BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state.isLoading && state.news.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.error != null) {
                      return Center(child: Text('Error: ${state.error}'));
                    }

                    List<NewsEntity> filteredNews = selectedCategory == 'All'
                        ? state.news
                        : state.news
                            .where((news) =>
                                news.categoryId?.categoryName ==
                                selectedCategory)
                            .toList();

                    if (filteredNews.isEmpty) {
                      return const Center(
                          child: Text('No news available for this category'));
                    }

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.03),
                            _buildHighlightedNews(filteredNews, screenWidth),
                            SizedBox(height: screenHeight * 0.03),
                            _buildLatestNews(filteredNews, screenWidth),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : lstBottomScreen[_selectedIndex],
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        // Apply the sensor offset to the entire dashboard content.
        body: Transform.translate(
          offset: offset,
          child: content,
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        List<String> categories = ['All'];
        categories
            .addAll(state.categories.map((category) => category.categoryName));

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: categories
                  .map((category) => _buildCategoryButton(category))
                  .toList(),
            ),
          ),
        );
      },
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
                : const Color(0xFF004AAD),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedNews(List<NewsEntity> news, double screenWidth) {
    final highlightedNews = news.first;
    // Adjust container height based on screen width.
    double containerHeight = screenWidth > 600 ? 400 : 300;

    return GestureDetector(
      onTap: () => _navigateToNewsDetails(highlightedNews),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
              "http://192.168.1.81:3000/news_image/${highlightedNews.image}",
            ),
            fit: BoxFit.cover,
          ),
        ),
        height: containerHeight,
      ),
    );
  }

  Widget _buildLatestNews(List<NewsEntity> news, double screenWidth) {
    // Adjust grid columns based on screen width.
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    // Adjust header font size based on screen width.
    double headerFontSize = screenWidth > 600 ? 22 : 19;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest News',
          style:
              TextStyle(fontSize: headerFontSize, fontWeight: FontWeight.bold),
        ),
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
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                newsItem.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
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
            'image': "http://192.168.1.81:3000/news_image/${newsItem.image}",
          },
        ),
      ),
    );
  }
}
