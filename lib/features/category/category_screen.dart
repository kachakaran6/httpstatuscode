import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/models/status_code_model.dart';
import '../../data/repositories/status_repository.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/status_code_tile.dart';

/// Displays the list of HTTP codes within a specific category.
class CategoryScreen extends StatefulWidget {
  final CategoryModel category;
  final StatusRepository repository;
  final LocalStorageService storageService;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.repository,
    required this.storageService,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Set<String> _bookmarked;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.storageService.getBookmarks().toSet();
  }

  Future<void> _toggleBookmark(String codeId) async {
    final isNowBookmarked =
        await widget.storageService.toggleBookmark(codeId);
    setState(() {
      if (isNowBookmarked) {
        _bookmarked.add(codeId);
      } else {
        _bookmarked.remove(codeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final color = AppTheme.colorFromHex(category.colorHex);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.0)],
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: category.codes.length,
        itemBuilder: (context, index) {
          final code = category.codes[index];
          return StatusCodeTile(
            code: code,
            categoryColorHex: category.colorHex,
            isBookmarked: _bookmarked.contains(code.id),
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.detail,
              arguments: {
                'code': code,
                'categoryColorHex': category.colorHex,
                'storage': widget.storageService,
              },
            ),
            onBookmarkToggle: () => _toggleBookmark(code.id),
          );
        },
      ),
    );
  }
}
