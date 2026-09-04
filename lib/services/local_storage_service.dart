import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';

/// Thin wrapper around Hive for persisting user preferences.
///
/// Stores only lightweight data (IDs, strings) — never full model objects.
class LocalStorageService {
  late final Box<dynamic> _box;
  bool _initialized = false;

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(AppConstants.hiveBoxName);
    _initialized = true;
  }

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  /// Returns the list of bookmarked code IDs.
  List<String> getBookmarks() {
    final stored = _box.get(AppConstants.bookmarksKey);
    if (stored == null) return [];
    return List<String>.from(stored as List);
  }

  /// Returns true if [codeId] is bookmarked.
  bool isBookmarked(String codeId) => getBookmarks().contains(codeId);

  /// Toggles bookmark state for [codeId].
  /// Returns the new bookmarked state.
  Future<bool> toggleBookmark(String codeId) async {
    final bookmarks = getBookmarks();
    final alreadyBookmarked = bookmarks.contains(codeId);

    if (alreadyBookmarked) {
      bookmarks.remove(codeId);
    } else {
      bookmarks.add(codeId);
    }

    await _box.put(AppConstants.bookmarksKey, bookmarks);
    return !alreadyBookmarked;
  }

  /// Removes all bookmarks.
  Future<void> clearBookmarks() async {
    await _box.delete(AppConstants.bookmarksKey);
  }

  // ── Theme preference ──────────────────────────────────────────────────────

  /// Returns stored theme mode index (0=system, 1=light, 2=dark).
  int getThemeMode() {
    return _box.get(AppConstants.themeModeKey, defaultValue: 0) as int;
  }

  /// Saves theme mode index.
  Future<void> setThemeMode(int modeIndex) async {
    await _box.put(AppConstants.themeModeKey, modeIndex);
  }
}
