import 'package:flutter/material.dart';
import '../services/archive_api.dart';
import '../widgets/movie_search_widget.dart';
import '../widgets/movie_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final archiveApi = ArchiveApiService();
  List<Movie> movies = [];
  bool isLoading = false;
  String errorMessage = '';

  void searchMovies(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final results = await archiveApi.searchMovies(query);
      setState(() {
        movies = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive.org Movie Downloader'),
        elevation: 2,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MovieSearchWidget(onSearch: searchMovies),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade400),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            ),
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (movies.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'Search for movies to get started',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: MovieListWidget(movies: movies),
            ),
        ],
      ),
    );
  }
}
