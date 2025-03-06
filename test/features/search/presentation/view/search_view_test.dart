import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/features/category/domain/entity/category_entity.dart';
import 'package:trueline_news_media/features/dashboard/domain/entity/news_entity.dart';
import 'package:trueline_news_media/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:trueline_news_media/features/search/presentation/view/search_view.dart';

/// --------------------
/// Fake and Mock Classes
/// --------------------

// Create a fake DashboardEvent by overriding props.

// Create a mock DashboardBloc.
class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

// Create a fake CategoryEntity. Adjust this based on your actual CategoryEntity.
class FakeCategoryEntity extends Fake implements CategoryEntity {
  @override
  final String categoryName;

  FakeCategoryEntity({required this.categoryName});
}

// Create a fake NewsEntity. Adjust this based on your actual NewsEntity.
class FakeNewsEntity extends Fake implements NewsEntity {
  @override
  final String title;
  @override
  final String content;
  @override
  final String created_at;
  @override
  final String image;
  @override
  final CategoryEntity? categoryId;

  FakeNewsEntity({
    required this.title,
    required this.content,
    required this.created_at,
    required this.image,
    this.categoryId,
  });
}

void main() {
  late MockDashboardBloc dashboardBloc;

  setUpAll(() {
    registerFallbackValue(FakeDashboardEvent());
  });

  setUp(() {
    dashboardBloc = MockDashboardBloc();
  });

  Widget loadSearchView() {
    return MaterialApp(
      home: BlocProvider<DashboardBloc>.value(
        value: dashboardBloc,
        child: const SearchView(),
      ),
    );
  }

  group('SearchView Widget Tests', () {
    testWidgets('displays placeholder text when search query is empty',
        (WidgetTester tester) async {
      when(() => dashboardBloc.state).thenReturn(
        const DashboardState(
          news: [],
          categories: [],
          isLoading: false,
          error: null,
        ),
      );

      await tester.pumpWidget(loadSearchView());
      await tester.pumpAndSettle();
      expect(find.text('Search for news...'), findsOneWidget);
    });

    testWidgets('displays filtered news list when query matches',
        (WidgetTester tester) async {
      final fakeCategory = FakeCategoryEntity(categoryName: 'Test Category');
      final fakeNews = FakeNewsEntity(
        title: 'Test News Title',
        content: 'Test news content.',
        created_at: '2025-03-06',
        image: 'test_image.jpg',
        categoryId: fakeCategory,
      );

      when(() => dashboardBloc.state).thenReturn(
        DashboardState(
          news: [fakeNews],
          categories: [fakeCategory],
          isLoading: false,
          error: null,
        ),
      );

      await tester.pumpWidget(loadSearchView());
      await tester.pumpAndSettle();

      expect(find.text('Search for news...'), findsOneWidget);

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
      await tester.enterText(textFieldFinder, 'Test News');
      await tester.pumpAndSettle();

      expect(find.text('Test News Title'), findsOneWidget);
      expect(find.textContaining('Test Category'), findsOneWidget);
    });
  });
}

class FakeDashboardEvent {}
