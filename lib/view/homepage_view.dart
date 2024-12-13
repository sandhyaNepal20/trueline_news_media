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
      'category': 'politics',
      'date': '2024-12-13',
      'image': 'lib/assets/images/news6.png',
    },
    {
      'title':
          'Park Police say no more major crimes reported along San Antonio trails',
      'category': 'Politics',
      'date': '2024-12-12',
      'image': 'lib/assets/images/news5.png',
    },
    {
      'title':
          'Prime Minister Oli, Foreign Minister Deuba brief President Paudel on China visit',
      'category': 'Education',
      'date': '2024-12-12',
      'image': 'lib/assets/images/news1.jpg',
    },
    {
      'title': 'Goat Life: How Indian Cinema Neglects Social Issues',
      'category': 'world news',
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
                  height: 200,
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Latest News Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Latest News',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004AAD),
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, // Handle See More
                      child: const Text(
                        'See More >>',
                        style: TextStyle(
                          color: Color(0xFF004AAD),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // News List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newsData.length,
                  itemBuilder: (context, index) {
                    final news = newsData[index];
                    return _buildNewsTile(
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

        //--------------------------------------------------------------------------------------------------
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

  Widget _buildNewsTile({
    required String title,
    required String category,
    required String date,
    required String imagePath,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text('$category - $date'),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
