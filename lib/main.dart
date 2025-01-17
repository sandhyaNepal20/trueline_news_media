import 'package:flutter/material.dart';
import 'package:trueline_news_media/app.dart';
import 'package:trueline_news_media/app/di/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // Ensure dependencies are initialized
  runApp(const App());
}
