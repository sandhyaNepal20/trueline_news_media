// onboard_model.dart
class OnboardingPage {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

// Define the pages list
final List<OnboardingPage> pages = [
  OnboardingPage(
    imagePath: 'assets/images/logo.png',
    title: 'Welcome to TrueLine News',
    description: 'Stay updated with the latest news from around the world.',
  ),
  OnboardingPage(
    imagePath: 'assets/images/logo.png',
    title: 'Breaking News',
    description: 'Get real-time notifications for breaking news.',
  ),
  OnboardingPage(
    imagePath: 'assets/images/logo.png',
    title: 'Categories',
    description: 'Browse news by categories like Sports, Technology, and more.',
  ),
];
