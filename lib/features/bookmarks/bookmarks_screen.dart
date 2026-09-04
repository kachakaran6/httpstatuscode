import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../data/models/status_code_model.dart';
import '../../data/repositories/status_repository.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_code_tile.dart';

/// Displays all bookmarked HTTP status codes.
class BookmarksScreen extends StatefulWidget {
  final StatusRepository repository;
  final LocalStorageService storageService;

  const BookmarksScreen({
    super.key,
    required this.repository,
    required this.storageService,
  });

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<StatusCodeModel> _bookmarkedCodes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final ids = widget.storageService.getBookmarks();
    final allCodes = await widget.repository.getAllCodes();
    final idSet = ids.toSet();

    if (!mounted) return;
    // Reset loading so the UI re-renders cleanly on every data change
    setState(() {
      _bookmarkedCodes =
          allCodes.where((c) => idSet.contains(c.id)).toList();
      _loading = false;
    });
  }

  Future<void> _toggleBookmark(String codeId) async {
    await widget.storageService.toggleBookmark(codeId);
    await _loadBookmarks();
  }

  Future<String> _colorHexForCode(String codeId) async {
    final cat = await widget.repository.categoryForCode(codeId);
    return cat?.colorHex ?? '#2196F3';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          if (_bookmarkedCodes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear all bookmarks',
              onPressed: () => _showClearDialog(context),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookmarkedCodes.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.bookmark_border_rounded,
                  title: 'No bookmarks yet',
                  subtitle:
                      'Tap the bookmark icon on any status code to save it here.',
                )
              : _BookmarkList(
                  codes: _bookmarkedCodes,
                  repository: widget.repository,
                  storageService: widget.storageService,
                  onToggleBookmark: _toggleBookmark,
                  colorHexFor: _colorHexForCode,
                ),
    );
  }

  Future<void> _showClearDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all bookmarks?'),
        content: Text(
            'This will remove all ${_bookmarkedCodes.length} bookmark(s). This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear')),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.storageService.clearBookmarks();
      _loadBookmarks();
    }
  }
}

class _BookmarkList extends StatelessWidget {
  final List<StatusCodeModel> codes;
  final StatusRepository repository;
  final LocalStorageService storageService;
  final Future<void> Function(String) onToggleBookmark;
  final Future<String> Function(String) colorHexFor;

  const _BookmarkList({
    required this.codes,
    required this.repository,
    required this.storageService,
    required this.onToggleBookmark,
    required this.colorHexFor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: codes.length,
      itemBuilder: (context, index) {
        final code = codes[index];
        return FutureBuilder<String>(
          future: colorHexFor(code.id),
          initialData: '#2196F3',
          builder: (_, snapshot) {
            final hex = snapshot.data ?? '#2196F3';
            return StatusCodeTile(
              code: code,
              categoryColorHex: hex,
              isBookmarked: true,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.detail,
                arguments: {
                  'code': code,
                  'categoryColorHex': hex,
                  'storage': storageService,
                },
              ),
              onBookmarkToggle: () => onToggleBookmark(code.id),
            );
          },
        );
      },
    );
  }
}
