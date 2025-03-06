import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trueline_news_media/app/di/di.dart';
import 'package:trueline_news_media/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:trueline_news_media/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:trueline_news_media/features/myprofile/presentation/bloc/myprofile_bloc.dart';
import 'package:trueline_news_media/features/myprofile/presentation/view/myprofile_view.dart';
import 'package:trueline_news_media/features/saved/presentation/bloc/saved_bloc.dart';
import 'package:trueline_news_media/features/saved/presentation/view/saved_view.dart';
import 'package:trueline_news_media/features/search/presentation/bloc/search_bloc.dart';
import 'package:trueline_news_media/features/search/presentation/view/search_view.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  // Initial state
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        Center(
          child: BlocProvider(
            create: (context) => getIt<DashboardBloc>(),
            child: const DashboardView(),
          ),
        ),
        BlocProvider(
          create: (context) => getIt<SearchBloc>(),
          child: const SearchView(),
        ),
        BlocProvider(
          create: (context) => getIt<SavedBloc>(),
          child: const SaveView(),
        ),
        Center(
          child: BlocProvider(
            create: (context) => getIt<MyprofileBloc>(),
            child: const MyProfileView(),
          ),
        ),
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
