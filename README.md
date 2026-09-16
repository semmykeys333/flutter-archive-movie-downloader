# Archive.org Movie Downloader (Flutter)

A Flutter app that lets you search for movies on **archive.org** and download them directly to your device. Built with Flutter for cross-platform support (Android, iOS, Web).

## Features

✅ **Search Movies** - Search the archive.org database for movies by title or creator  
✅ **View Details** - See metadata, description, year, and creator info  
✅ **Download Files** - Direct download with progress tracking  
✅ **Multiple Formats** - Supports MP4, MKV, WebM, and other video formats  
✅ **No Lag** - Optimized API calls with proper error handling  
✅ **Free** - No API key required, uses public archive.org API  
✅ **Cross-Platform** - Runs on Android, iOS, and Web  

## Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK

### Setup

```bash
# Clone the repository
git clone https://github.com/semmykeys333/flutter-archive-movie-downloader.git
cd flutter-archive-movie-downloader

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### For Web

```bash
flutter run -d chrome
```

### For Android

```bash
flutter run -d android
```

## Architecture

### Services
- **ArchiveApiService** - Handles all archive.org API calls
  - `searchMovies()` - Query the advanced search API
  - `getMovieDetails()` - Fetch metadata and file list
  - `getDownloadUrl()` - Generate download URLs

- **DownloadService** - Manages file downloads with progress tracking

### Screens
- **HomeScreen** - Search interface and results list
- **MovieDetailScreen** - Full movie details with file options

### Widgets
- **MovieSearchWidget** - Search input and button
- **MovieListWidget** - Scrollable list of search results
- **DownloadWidget** - File download UI with progress bar

## API Integration

The app uses two archive.org endpoints:

### 1. Advanced Search API
```
GET https://archive.org/advancedsearch.php
Params: q, fl[], rows, page, output
```

Searches for media matching Lucene query syntax. Example:
```
q=mediatype:movies AND title:"Star Wars"
fl[]=identifier&fl[]=title&fl[]=year&fl[]=creator
```

### 2. Item Metadata API
```
GET https://archive.org/metadata/{identifier}
```

Returns detailed metadata including file list for a specific item.

## Dependencies

- **http** - HTTP requests to archive.org API
- **path_provider** - Access to device directories
- **permission_handler** - Request file system permissions
- **url_launcher** - Open URLs (future feature)
- **cupertino_icons** - iOS-style icons

## Usage

1. **Search** - Enter a movie title or creator name and tap Search
2. **Browse Results** - Tap a movie to view details and available files
3. **Download** - Choose a video file and tap Download
4. **Track Progress** - Watch the download progress bar in real-time
5. **Access Files** - Downloaded files are saved to `/storage/emulated/0/Downloads`

## Performance Notes

- API calls are timeout-protected (15 seconds)
- Search results are limited to top 20 by default
- Video files are filtered automatically (MP4, MKV, WebM, etc.)
- Downloads use streaming to prevent memory issues

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart      # Main search screen
│   └── movie_detail_screen.dart
├── services/
│   ├── archive_api.dart      # Archive.org API integration
│   └── download_service.dart # File download handling
└── widgets/
    ├── movie_search_widget.dart
    ├── movie_list_widget.dart
    └── download_widget.dart
```

## Future Enhancements

- [ ] Download queue management
- [ ] Pause/resume downloads
- [ ] Search filters (year, format, duration)
- [ ] Local library/favorites
- [ ] Video player integration
- [ ] Background downloads

## License

MIT License - Free to use and modify

## Credits

Built with Flutter and powered by [Internet Archive](https://archive.org)

## Support

For issues or suggestions, create a GitHub issue in this repository.
