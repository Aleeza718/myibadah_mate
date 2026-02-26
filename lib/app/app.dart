import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import '../providers/theme_provider.dart';

// Splash
import '../screens/splash/splash_screen.dart';

// Auth
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

// Home
import '../screens/home/home_screen.dart';
import '../screens/tasbih/tasbih_screen.dart' as tasbih;
import '../screens/namaz/namaz_screen.dart';
import '../screens/qibla/qibla_screen.dart';

// Quran
import '../screens/quran/quran_home_screen.dart';
import '../screens/quran/surah_detail_screen.dart';
import '../services/quran_service.dart';
import '../models/quran_model.dart';

// Settings
import '../screens/settings/settings_screen.dart';

// Theme
import '../theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingApp();
          }

          // Authenticated user
          if (snapshot.hasData) {
            return Consumer(
              builder: (context, ref, child) {
                final themeMode = ref.watch(themeModeProvider);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'IbadahMate',
                  theme: _buildLightTheme(),
                  darkTheme: _buildDarkTheme(),
                  themeMode: themeMode,
                  home: const HomeScreen(),
                  onGenerateRoute: _generateAuthenticatedRoutes,
                );
              },
            );
          }

          // Unauthenticated user
          return Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeModeProvider);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'IbadahMate',
                theme: _buildLightTheme(),
                darkTheme: _buildDarkTheme(),
                themeMode: themeMode,
                home: const SplashScreen(),
                onGenerateRoute: _generateAuthRoutes,
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Amiri',
      cardTheme: const CardThemeData(
        elevation: 2.0,
        margin: EdgeInsets.symmetric(vertical: 4),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2.0,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Amiri',
      cardTheme: const CardThemeData(
        elevation: 2.0,
        margin: EdgeInsets.symmetric(vertical: 4),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2.0,
      ),
    );
  }

  // ---------------- AUTHENTICATED ROUTES ----------------

  Route<dynamic> _generateAuthenticatedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/namaz':
        return MaterialPageRoute(builder: (_) => const NamazScreen());

      case '/qibla':
        return MaterialPageRoute(builder: (_) => const QiblaScreen());

      case '/tasbih':
        return MaterialPageRoute(builder: (_) => const tasbih.ZikrScreen());

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case '/quran':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<List<QuranSurah>>(
            future: QuranService.loadSurahs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return Scaffold(
                  body: Center(
                    child: Text('Failed to load Quran'),
                  ),
                );
              }

              return QuranScreen(surahs: snapshot.data!);
            },
          ),
        );

      case '/surah':
        final args = settings.arguments;

        if (args == null || args is! Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid surah arguments')),
            ),
          );
        }

        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, __) {
            return FadeTransition(
              opacity: animation,
              child: SurahDetailScreen(
                surahs: args['surahs'],
                startSurahIndex: args['index'],
              ),
            );
          },
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }

  // ---------------- AUTH ROUTES ----------------

  Route<dynamic> _generateAuthRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/splash':
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }

  // ---------------- LOADING APP ----------------

  Widget _buildLoadingApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
