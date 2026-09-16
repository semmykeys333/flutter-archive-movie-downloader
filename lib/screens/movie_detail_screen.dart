import 'package:flutter/material.dart';
import '../services/archive_api.dart';
import '../widgets/download_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetails> movieDetailsFuture;

  @override
  void initState() {
    super.initState();
    movieDetailsFuture =
        ArchiveApiService().getMovieDetails(widget.movie.identifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        elevation: 2,
      ),
      body: FutureBuilder<MovieDetails>(
        future: movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final details = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (details.year != null)
                  Text('Year: ${details.year}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                if (details.creator != null)
                  Text('Creator: ${details.creator}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),
                if (details.description != null) ...
                  [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      details.description!,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                  ],
                Text(
                  'Available Files (${details.files.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (details.files.isEmpty)
                  const Text('No video files available')
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: details.files.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final file = details.files[index];
                      return DownloadWidget(
                        file: file,
                        movieTitle: details.title,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
