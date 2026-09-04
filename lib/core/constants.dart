/// Application-wide constants. No hardcoded values in UI screens.
class AppConstants {
  AppConstants._();

  // ── Asset paths ───────────────────────────────────────────────────────────
  static const String statusCodesAsset = 'assets/data/status_codes.json';

  // ── Hive storage ──────────────────────────────────────────────────────────
  static const String hiveBoxName      = 'app_prefs';
  static const String bookmarksKey     = 'bookmarks';
  static const String themeModeKey     = 'theme_mode';

  // ── UI dimensions ─────────────────────────────────────────────────────────
  static const double cardRadius       = 12.0;
  static const double pageHPadding     = 16.0;
  static const double pageVPadding     = 12.0;
  static const double iconSize         = 22.0;

  // ── Search ────────────────────────────────────────────────────────────────
  static const int    searchDebounceMs = 250;

  // ── Share template ────────────────────────────────────────────────────────
  static String shareMessage({
    required int code,
    required String title,
    required String description,
    required String bestPractice,
  }) =>
      '''HTTP $code - $title

📖 Description:
$description

✅ Best Practice:
$bestPractice

— Shared via HTTP Status Guide''';
}
