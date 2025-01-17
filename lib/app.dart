import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trueline_news_media/app/di/di.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:trueline_news_media/features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'package:trueline_news_media/features/splash/presentation/view/splash_view.dart';
import 'package:trueline_news_media/features/splash/presentation/view_model/splash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide SplashCubit
        BlocProvider<SplashCubit>(
          create: (_) => getIt<SplashCubit>(),
        ),
        // Provide OnboardingCubit
        BlocProvider<OnboardingCubit>(
          create: (_) => getIt<OnboardingCubit>(),
        ),
        // Provide LoginBloc
        BlocProvider<LoginBloc>(
          create: (_) => getIt<LoginBloc>(),
        ),
        // Provide SignupBloc
        BlocProvider<SignupBloc>(
          create: (_) => getIt<SignupBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News Media',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashView(),
      ),
    );
  }
}
