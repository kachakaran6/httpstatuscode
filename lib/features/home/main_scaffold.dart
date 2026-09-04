import 'package:flutter/material.dart';
import '../../data/repositories/status_repository.dart';
import '../../services/local_storage_service.dart';
import '../bookmarks/bookmarks_screen.dart';
import '../home/home_screen.dart';

/// Root scaffold with persistent bottom navigation between Home and Bookmarks.
///
/// Uses [IndexedStack] so both tabs remain alive, but passes a [refreshKey]
/// to [BookmarksScreen] so it reloads its list every time the tab is tapped.
class MainScaffold extends StatefulWidget {
  final StatusRepository repository;
  final LocalStorageService storageService;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const MainScaffold({
    super.key,
    required this.repository,
    required this.storageService,
    required this.themeModeNotifier,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  // Incremented each time we switch to the Bookmarks tab so that
  // BookmarksScreen rebuilds and reloads its list.
  int _bookmarkRefreshKey = 0;

  void _onDestinationSelected(int index) {
    if (index == 1 && _selectedIndex != 1) {
      // Force BookmarksScreen to rebuild & reload bookmarks
      _bookmarkRefreshKey++;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            repository: widget.repository,
            storageService: widget.storageService,
            themeModeNotifier: widget.themeModeNotifier,
          ),
          // key forces a full rebuild of BookmarksScreen when tab is re-tapped,
          // ensuring bookmarks toggled on other screens are reflected here.
          BookmarksScreen(
            key: ValueKey(_bookmarkRefreshKey),
            repository: widget.repository,
            storageService: widget.storageService,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
