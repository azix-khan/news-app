import 'package:flutter/material.dart';
import 'package:news_app/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xffafdde5)),
      // color: Color(0xffafdde5),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
