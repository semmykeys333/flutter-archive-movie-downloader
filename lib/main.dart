import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ArchiveMovieApp());
}

class ArchiveMovieApp extends StatelessWidget {
  const ArchiveMovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archive Movie Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
