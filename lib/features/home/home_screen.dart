import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/models/status_code_model.dart';
import '../../data/repositories/status_repository.dart';
import '../../services/local_storage_service.dart';

/// Home screen displaying all HTTP status code categories as cards.
class HomeScreen extends StatefulWidget {
  final StatusRepository repository;
  final LocalStorageService storageService;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const HomeScreen({
    super.key,
    required this.repository,
    required this.storageService,
    required this.themeModeNotifier,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await widget.repository.getCategories();
    if (!mounted) return;
    setState(() {
      _categories = categories;
      _loading = false;
    });
  }

  /// Toggles directly between light and dark — 1 tap, always visible change.
  void _toggleTheme() {
    final isDark = widget.themeModeNotifier.value == ThemeMode.dark;
    widget.themeModeNotifier.value =
        isDark ? ThemeMode.light : ThemeMode.dark;
    widget.storageService
        .setThemeMode(widget.themeModeNotifier.value.index);
  }

  /// Shows moon when currently light (tap → go dark),
  /// shows sun when currently dark (tap → go light).
  IconData _themeIcon() =>
      widget.themeModeNotifier.value == ThemeMode.dark
          ? Icons.light_mode_rounded
          : Icons.dark_mode_outlined;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Status Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.search,
                    arguments: widget.repository),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: widget.themeModeNotifier,
            builder: (_, mode, ___) => IconButton(
              icon: Icon(_themeIcon()),
              tooltip: mode == ThemeMode.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
              onPressed: _toggleTheme,
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  sliver: SliverToBoxAdapter(
                    child: _HeaderSection(
                        totalCodes: _categories
                            .fold(0, (s, c) => s + c.codes.length)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.pageHPadding,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cat = _categories[index];
                        return _CategoryCard(
                          category: cat,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.category,
                            arguments: {
                              'category': cat,
                              'repository': widget.repository,
                              'storage': widget.storageService,
                            },
                          ),
                        );
                      },
                      childCount: _categories.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final int totalCodes;

  const _HeaderSection({required this.totalCodes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Developer Reference',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalCodes status codes across 5 categories. '
                  'Fully offline.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              '$totalCodes Codes',
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
            backgroundColor:
                theme.colorScheme.primary.withValues(alpha: 0.12),
            side: BorderSide.none,
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppTheme.colorFromHex(category.colorHex);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color swatch
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: color.withValues(alpha: 0.3), width: 1),
                ),
                child: Center(
                  child: Text(
                    category.title.split(' ')[0],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      category.description,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${category.codes.length} codes',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
