import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trueline_news_media/features/onboarding/presentation/view/on_board_model.dart';
import 'package:trueline_news_media/view/login_view.dart';

// onboarding_cubit.dart
class OnboardingCubit extends Cubit<int> {
  final PageController pageController = PageController();

  OnboardingCubit() : super(0);

  void goToNextPage() {
    if (state < pages.length - 1) {
      emit(state + 1);
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLastPage() {
    emit(pages.length - 1);
    pageController.jumpToPage(pages.length - 1);
  }

  void navigateToAuthScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
