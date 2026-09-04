import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'data/repositories/status_repository.dart';
import 'features/category/category_screen.dart';
import 'features/detail/detail_screen.dart';
import 'features/home/main_scaffold.dart';
import 'features/search/search_screen.dart';
import 'features/splash/splash_screen.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for consistent UX.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialise storage before app starts.
  final storage = LocalStorageService();
  await storage.init();

  // Restore saved theme preference.
  // Index 0 = system (legacy) → normalise to 1 (light) so the 1-tap
  // light/dark toggle always starts in a concrete known state.
  final savedThemeIndex = storage.getThemeMode();
  final resolvedIndex = savedThemeIndex == 0 ? 1 : savedThemeIndex;
  final themeNotifier = ValueNotifier<ThemeMode>(
    ThemeMode.values[resolvedIndex.clamp(1, 2)],
  );

  final repository = StatusRepository();

  runApp(HttpStatusApp(
    repository: repository,
    storageService: storage,
    themeModeNotifier: themeNotifier,
  ));
}

class HttpStatusApp extends StatelessWidget {
  final StatusRepository repository;
  final LocalStorageService storageService;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const HttpStatusApp({
    super.key,
    required this.repository,
    required this.storageService,
    required this.themeModeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (_, themeMode, __) {
        return MaterialApp(
          title: 'HTTP Status Guide',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(repository: repository),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            repository: repository,
            storageService: storageService,
            themeModeNotifier: themeModeNotifier,
          ),
        );

      case AppRoutes.category:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CategoryScreen(
            category: args['category'],
            repository: args['repository'],
            storageService: args['storage'],
          ),
        );

      case AppRoutes.detail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(
            code: args['code'],
            categoryColorHex: args['categoryColorHex'],
            storageService: args['storage'],
          ),
        );

      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => SearchScreen(
            repository: repository,
            storageService: storageService,
          ),
        );

      default:
        return null;
    }
  }
}
