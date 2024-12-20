// import 'package:trueline_news_media/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:trueline_news_media/core/app_theme/app_theme.dart';
import 'package:trueline_news_media/view/homepage_view.dart';
import 'package:trueline_news_media/view/login_view.dart';
import 'package:trueline_news_media/view/signup_view.dart';
import 'package:trueline_news_media/view/welcome_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),

      initialRoute: '/welcome', // Set the initial route to LoginPage
      routes: {
        '/welcome': (context) => const WelcomeView(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
        '/homepage': (context) => const HomeScreen(),
      },
    );
  }
}
