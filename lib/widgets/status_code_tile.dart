import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/models/status_code_model.dart';
import '../widgets/status_code_badge.dart';

/// List tile for a single HTTP status code.
class StatusCodeTile extends StatelessWidget {
  final StatusCodeModel code;
  final String categoryColorHex;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  const StatusCodeTile({
    super.key,
    required this.code,
    required this.categoryColorHex,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              StatusCodeBadge(
                code: code.code,
                colorHex: categoryColorHex,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      code.shortDescription,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  size: 22,
                  color: isBookmarked
                      ? AppTheme.colorFromHex(categoryColorHex)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                onPressed: onBookmarkToggle,
                tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
