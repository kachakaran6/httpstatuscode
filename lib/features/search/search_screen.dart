import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';
import '../../data/models/status_code_model.dart';
import '../../data/repositories/status_repository.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_code_tile.dart';

/// Full-screen search with instant in-memory filtering.
class SearchScreen extends StatefulWidget {
  final StatusRepository repository;
  final LocalStorageService storageService;

  const SearchScreen({
    super.key,
    required this.repository,
    required this.storageService,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<StatusCodeModel> _results = [];
  bool _searching = false;
  bool _hasSearched = false;
  late Set<String> _bookmarked;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.storageService.getBookmarks().toSet();
    _controller.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMs),
      _runSearch,
    );
  }

  Future<void> _runSearch() async {
    final query = _controller.text;
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() => _searching = true);
    final results = await widget.repository.search(query);
    if (!mounted) return;
    setState(() {
      _results = results;
      _searching = false;
      _hasSearched = true;
    });
  }

  Future<void> _toggleBookmark(String codeId) async {
    final isNow = await widget.storageService.toggleBookmark(codeId);
    setState(() {
      if (isNow) {
        _bookmarked.add(codeId);
      } else {
        _bookmarked.remove(codeId);
      }
    });
  }

  Future<String> _colorHexForCode(StatusCodeModel code) async {
    final cat = await widget.repository.categoryForCode(code.id);
    return cat?.colorHex ?? '#2196F3';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by code, title, or description…',
            border: InputBorder.none,
            filled: false,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() {
                  _results = [];
                  _hasSearched = false;
                });
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return const EmptyStateWidget(
        icon: Icons.manage_search_rounded,
        title: 'Search HTTP Status Codes',
        subtitle: 'Search by code number, title, or description.',
      );
    }

    if (_results.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: 'No results found',
        subtitle: 'Try searching for "404", "Not Found", or "timeout".',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final code = _results[index];
        return FutureBuilder<String>(
          future: _colorHexForCode(code),
          initialData: '#2196F3',
          builder: (_, snapshot) {
            final hex = snapshot.data ?? '#2196F3';
            return StatusCodeTile(
              code: code,
              categoryColorHex: hex,
              isBookmarked: _bookmarked.contains(code.id),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.detail,
                arguments: {
                  'code': code,
                  'categoryColorHex': hex,
                  'storage': widget.storageService,
                },
              ),
              onBookmarkToggle: () => _toggleBookmark(code.id),
            );
          },
        );
      },
    );
  }
}
