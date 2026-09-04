import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/status_code_model.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/code_block_widget.dart';
import '../../widgets/status_code_badge.dart';

/// Full detail view for a single HTTP status code.
class DetailScreen extends StatefulWidget {
  final StatusCodeModel code;
  final String categoryColorHex;
  final LocalStorageService storageService;

  const DetailScreen({
    super.key,
    required this.code,
    required this.categoryColorHex,
    required this.storageService,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.storageService.isBookmarked(widget.code.id);
  }

  Future<void> _toggleBookmark() async {
    final newState =
        await widget.storageService.toggleBookmark(widget.code.id);
    setState(() => _isBookmarked = newState);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            newState ? 'Bookmark added' : 'Bookmark removed'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _share() {
    final code = widget.code;
    Share.share(AppConstants.shareMessage(
      code: code.code,
      title: code.title,
      description: code.description,
      bestPractice: code.bestPractice,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = widget.code;
    final color = AppTheme.colorFromHex(widget.categoryColorHex);

    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP ${code.code}'),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: _isBookmarked ? color : null,
            ),
            tooltip: _isBookmarked ? 'Remove bookmark' : 'Bookmark',
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share',
            onPressed: _share,
          ),
        ],
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
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.pageHPadding,
          vertical: AppConstants.pageVPadding,
        ),
        children: [
          // ── Header ────────────────────────────────────────────────
          _DetailHeader(code: code, colorHex: widget.categoryColorHex),
          const SizedBox(height: 20),

          // ── Description ───────────────────────────────────────────
          _SectionCard(
            title: 'Description',
            icon: Icons.info_outline_rounded,
            color: color,
            child: Text(code.description, style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 12),

          // ── When to use ───────────────────────────────────────────
          _SectionCard(
            title: 'When to Use',
            icon: Icons.check_circle_outline_rounded,
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: code.whenToUse
                  .map((item) => _BulletItem(text: item, color: color))
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),

          // ── Example response ──────────────────────────────────────
          _SectionCard(
            title: 'Example Response',
            icon: Icons.code_rounded,
            color: color,
            child: CodeBlockWidget(
              code: code.formattedExampleResponse,
            ),
          ),
          const SizedBox(height: 12),

          // ── Best practice ─────────────────────────────────────────
          _BestPracticeCard(
            bestPractice: code.bestPractice,
            color: color,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final StatusCodeModel code;
  final String colorHex;

  const _DetailHeader({required this.code, required this.colorHex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppTheme.colorFromHex(colorHex);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusCodeBadge(
            code: code.code,
            colorHex: colorHex,
            fontSize: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code.title,
                    style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(code.shortDescription,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;

  const _BulletItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _BestPracticeCard extends StatelessWidget {
  final String bestPractice;
  final Color color;

  const _BestPracticeCard(
      {required this.bestPractice, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Best Practice',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: color)),
                const SizedBox(height: 6),
                Text(bestPractice,
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
