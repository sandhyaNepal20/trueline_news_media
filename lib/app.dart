// import 'package:trueline_news_media/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:trueline_news_media/view/dashboard_view.dart';
import 'package:trueline_news_media/view/login_view.dart';
import 'package:trueline_news_media/view/signup_view.dart';
import 'package:trueline_news_media/view/welcome_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set the initial route to LoginPage
      routes: {
        '/welcome': (context) => const WelcomeView(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
        '/dashboard': (context) => const HomeScreen(),
      },
    );
  }
}
