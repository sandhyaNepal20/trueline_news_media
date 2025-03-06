import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trueline_news_media/features/news_details/presentation/view/news_details_view.dart';

void main() {
  final Map<String, String?> newsData = {
    'image': 'https://example.com/image.jpg',
    'category': 'World',
    'date': '2025-03-06',
    'title': 'Breaking News',
    'content': 'This is a test news content.',
  };

  group('NewsDetailsView Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should display news details correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NewsDetailsView(newsData: newsData),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Details'), findsOneWidget);

      expect(find.text('World'), findsOneWidget);

      expect(find.text('Published on: 2025-03-06'), findsOneWidget);

      expect(find.text('Breaking News'), findsOneWidget);

      expect(find.text('This is a test news content.'), findsOneWidget);
    });

    testWidgets('should toggle bookmark icon when pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NewsDetailsView(newsData: newsData),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsNothing);

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsNothing);

      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsNothing);
    });

    testWidgets('should show fallback icon if image fails to load',
        (WidgetTester tester) async {
      final Map<String, String?> faultyNewsData = Map.from(newsData);
      faultyNewsData['image'] = 'https://invalid-url';

      await tester.pumpWidget(
        MaterialApp(
          home: NewsDetailsView(newsData: faultyNewsData),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });
  });
}
