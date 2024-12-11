// import 'package:trueline_news_media/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:trueline_news_media/view/login_view.dart';
import 'package:trueline_news_media/view/signup_view.dart';
import 'package:trueline_news_media/view/welcome_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpView(),
    );
  }
}
