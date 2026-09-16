import 'package:http/http.dart' as http;
import 'dart:convert';

class ArchiveApiService {
  static const String searchUrl = 'https://archive.org/advancedsearch.php';
  static const String metadataUrl = 'https://archive.org/metadata';
  static const String downloadUrl = 'https://archive.org/download';

  /// Search for movies on archive.org
  Future<List<Movie>> searchMovies(String query, {int rows = 20, int page = 1}) async {
    try {
      final String luceneQuery = 'mediatype:movies AND (title:"$query" OR creator:"$query")';
      final Uri uri = Uri.parse(searchUrl).replace(
        queryParameters: {
          'q': luceneQuery,
          'fl[]': 'identifier,title,year,description,creator',
          'rows': rows.toString(),
          'page': page.toString(),
          'output': 'json',
        },
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['response']['docs'] as List;
        return docs
            .map((doc) => Movie.fromJson(doc))
            .toList();
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

  /// Get detailed metadata and file list for a movie
  Future<MovieDetails> getMovieDetails(String identifier) async {
    try {
      final Uri uri = Uri.parse('$metadataUrl/$identifier');
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieDetails.fromJson(data, identifier);
      } else {
        throw Exception('Failed to fetch details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Details error: $e');
    }
  }

  /// Build download URL for a file
  String getDownloadUrl(String identifier, String filename) {
    return '$downloadUrl/$identifier/$filename';
  }
}

class Movie {
  final String identifier;
  final String title;
  final String? year;
  final String? description;
  final String? creator;

  Movie({
    required this.identifier,
    required this.title,
    this.year,
    this.description,
    this.creator,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      identifier: json['identifier'] ?? 'unknown',
      title: json['title'] ?? 'Untitled',
      year: json['year']?.toString(),
      description: json['description']?.toString(),
      creator: json['creator'] is List
          ? (json['creator'] as List).join(', ')
          : json['creator']?.toString(),
    );
  }
}

class MovieDetails {
  final String identifier;
  final String title;
  final String? year;
  final String? description;
  final String? creator;
  final List<MovieFile> files;

  MovieDetails({
    required this.identifier,
    required this.title,
    this.year,
    this.description,
    this.creator,
    required this.files,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json, String identifier) {
    final metadata = json['metadata'] ?? {};
    final filesList = json['files'] as List? ?? [];
    
    final videoFiles = filesList
        .whereType<Map<String, dynamic>>()
        .where((f) {
          final format = (f['format'] ?? '').toString().toLowerCase();
          return format.contains('video') ||
              format.contains('mpeg') ||
              format.contains('h.264') ||
              f['name'].toString().endsWith('.mp4') ||
              f['name'].toString().endsWith('.mkv') ||
              f['name'].toString().endsWith('.webm');
        })
        .map((f) => MovieFile.fromJson(f, identifier))
        .toList();

    return MovieDetails(
      identifier: identifier,
      title: metadata['title'] ?? 'Untitled',
      year: metadata['year']?.toString(),
      description: metadata['description']?.toString(),
      creator: metadata['creator'] is List
          ? (metadata['creator'] as List).join(', ')
          : metadata['creator']?.toString(),
      files: videoFiles,
    );
  }
}

class MovieFile {
  final String name;
  final String format;
  final String size;
  final String downloadUrl;

  MovieFile({
    required this.name,
    required this.format,
    required this.size,
    required this.downloadUrl,
  });

  factory MovieFile.fromJson(Map<String, dynamic> json, String identifier) {
    final sizeBytes = int.tryParse(json['size']?.toString() ?? '0') ?? 0;
    final sizeStr = _formatBytes(sizeBytes);

    return MovieFile(
      name: json['name'] ?? 'unknown',
      format: json['format'] ?? 'unknown',
      size: sizeStr,
      downloadUrl: 'https://archive.org/download/$identifier/${json['name']}',
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = (bytes.toString().length - 1) ~/ 3;
    return '${(bytes / (1000 * i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}
