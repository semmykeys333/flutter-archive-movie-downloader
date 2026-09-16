import 'package:flutter/material.dart';

class MovieSearchWidget extends StatefulWidget {
  final Function(String) onSearch;

  const MovieSearchWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<MovieSearchWidget> createState() => _MovieSearchWidgetState();
}

class _MovieSearchWidgetState extends State<MovieSearchWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSearch() {
    widget.onSearch(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search movies...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onSubmitted: (_) => _handleSearch(),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          onPressed: _handleSearch,
          mini: true,
          child: const Icon(Icons.search),
        ),
      ],
    );
  }
}
