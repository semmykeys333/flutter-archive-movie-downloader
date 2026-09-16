import 'package:flutter/material.dart';
import '../services/archive_api.dart';
import '../services/download_service.dart';

class DownloadWidget extends StatefulWidget {
  final MovieFile file;
  final String movieTitle;

  const DownloadWidget(
      {Key? key, required this.file, required this.movieTitle})
      : super(key: key);

  @override
  State<DownloadWidget> createState() => _DownloadWidgetState();
}

class _DownloadWidgetState extends State<DownloadWidget> {
  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? errorMessage;

  void _startDownload() async {
    setState(() {
      isDownloading = true;
      errorMessage = null;
      downloadProgress = 0.0;
    });

    DownloadService().downloadFile(
      widget.file.downloadUrl,
      widget.file.name,
      (received, total) {
        setState(() {
          downloadProgress = total > 0 ? received / total : 0.0;
        });
      },
      (path) {
        setState(() {
          isDownloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to: $path')),
        );
      },
      (error) {
        setState(() {
          isDownloading = false;
          errorMessage = error;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${widget.file.format} • ${widget.file.size}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (!isDownloading)
                ElevatedButton.icon(
                  onPressed: _startDownload,
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                )
              else
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: downloadProgress,
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
          if (isDownloading) ...
            [
              const SizedBox(height: 8),
              LinearProgressIndicator(value: downloadProgress),
              const SizedBox(height: 4),
              Text(
                '${(downloadProgress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          if (errorMessage != null) ...
            [
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
        ],
      ),
    );
  }
}
