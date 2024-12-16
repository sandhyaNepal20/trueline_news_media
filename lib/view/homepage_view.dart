import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All'; // Track selected category

  final List<Map<String, String>> newsData = [
    {
      'title':
          'Prime Minister Oli, Foreign Minister Deuba brief President Paudel on China visit',
      'category': 'Politics',
      'date': '2024-12-12',
      'image': 'lib/assets/images/news1.jpg',
    },
    {
      'title': 'FNJ election today',
      'category': 'Politics',
      'date': '2024-12-13',
      'image': 'lib/assets/images/news6.png',
    },
    {
      'title':
          'Park Police say no more major crimes reported along San Antonio trails',
      'category': 'World News',
      'date': '2024-12-12',
      'image': 'lib/assets/images/news5.png',
    },
    {
      'title':
          'Prime Minister Oli, Foreign Minister Deuba brief President Paudel on China visit',
      'category': 'Politics',
      'date': '2024-12-12',
      'image': 'lib/assets/images/news1.jpg',
    },
    {
      'title': 'Goat Life: How Indian Cinema Neglects Social Issues',
      'category': 'World News',
      'date': '2024-11-30',
      'image': 'lib/assets/images/news3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF004AAD)),
            onPressed: () {}, // Handle menu button
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/logo1.png', height: 40), // Logo
              const SizedBox(width: 5),
              const Text(
                'Trueline News',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004AAD),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF004AAD)),
              onPressed: () {}, // Handle notifications
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryButton('All'),
                      _buildCategoryButton('Politics'),
                      _buildCategoryButton('Sports'),
                      _buildCategoryButton('Education'),
                      _buildCategoryButton('Technology'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Highlighted News
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage('lib/assets/images/news7.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 380, // Increased height for a larger panel
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Park Police say no more major crimes reported along San Antonio trails',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  18, // Adjusted text size for better visibility
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Latest News Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Latest News',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, // Handle See More
                      child: const Text(
                        'See More >>',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
// News Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8, // Adjusted aspect ratio
                  ),
                  itemCount: newsData.length,
                  itemBuilder: (context, index) {
                    final news = newsData[index];
                    return _buildNewsCard(
                      title: news['title']!,
                      category: news['category']!,
                      date: news['date']!,
                      imagePath: news['image']!,
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: const Color(0xFF004AAD),
          unselectedItemColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category; // Update selected category
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category
              ? const Color(0xFF004AAD)
              : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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

  Widget _buildNewsCard({
    required String title,
    required String category,
    required String date,
    required String imagePath,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  '$category - $date',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
