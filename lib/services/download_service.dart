import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();

  factory DownloadService() {
    return _instance;
  }

  DownloadService._internal();

  Future<void> downloadFile(
    String url,
    String filename,
    Function(int, int) onProgress,
    Function(String) onComplete,
    Function(String) onError,
  ) async {
    try {
      final request = http.Request('GET', Uri.parse(url));
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode != 200) {
        throw Exception('Failed to download: ${streamedResponse.statusCode}');
      }

      final contentLength = streamedResponse.contentLength ?? 0;
      int receivedBytes = 0;

      final List<int> bytes = [];
      streamedResponse.stream.listen(
        (List<int> chunk) {
          bytes.addAll(chunk);
          receivedBytes += chunk.length;
          onProgress(receivedBytes, contentLength);
        },
        onDone: () async {
          try {
            final directory = Directory('/storage/emulated/0/Downloads');
            if (!directory.existsSync()) {
              directory.createSync(recursive: true);
            }

            final file = File('${directory.path}/$filename');
            await file.writeAsBytes(bytes);
            onComplete(file.path);
          } catch (e) {
            onError('Error saving file: $e');
          }
        },
        onError: (e) {
          onError('Download error: $e');
        },
        cancelOnError: true,
      );
    } catch (e) {
      onError('Error: $e');
    }
  }
}
