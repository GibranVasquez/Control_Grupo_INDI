import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/services/theme_service.dart';
import 'core/routes/app_routes.dart';
import 'shared/widgets/responsive_layout.dart';
import 'app_shell.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/tickets/register_expense_screen.dart';
import 'features/tickets/history_screen.dart';
import 'features/tickets/expense_detail_screen.dart';
import 'features/reports/finanzas_screen.dart';
import 'features/reports/presupuestos_screen.dart';
import 'features/admin/usuarios_screen.dart';
import 'features/projects/projects_screen.dart';
import 'features/vehicles/vehicles_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/settings/settings_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    ThemeService.modeNotifier.addListener(_onThemeChange);
  }

  @override
  void dispose() {
    ThemeService.modeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  void _onThemeChange() => setState(() {});

  ThemeData _lightTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  ThemeData _darkTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: const Color(0xFF4A8DB5),
      secondary: const Color(0xFF1A3D5A),
      surface: const Color(0xFF1E1E1E),
      error: const Color(0xFFEF5350),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF1E1E1E),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grupo INDI',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeService.mode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case AppRoutes.splash:
            page = const SplashScreen();
          case AppRoutes.login:
            page = const LoginScreen();
          case AppRoutes.dashboard:
            page = const AppShell();
          case AppRoutes.register:
            page = const RegisterExpenseScreen();
          case AppRoutes.history:
            page = const HistoryScreen();
          case AppRoutes.expenseDetail:
            page = const ExpenseDetailScreen();
          case AppRoutes.finanzas:
            page = const FinanzasScreen();
          case AppRoutes.presupuestos:
            page = const PresupuestosScreen();
          case AppRoutes.presupuestoForm:
            page = const PresupuestosScreen();
          case AppRoutes.projects:
            page = const ProjectsScreen();
          case AppRoutes.vehicles:
            page = const VehiclesScreen();
          case AppRoutes.usuarios:
            page = const UsuariosScreen();
          case AppRoutes.profile:
            page = const ProfileScreen();
          case AppRoutes.settings:
            page = const SettingsScreen();
          default:
            page = const AppShell();
        }

        return _buildRoute(page, settings);
      },
    );
  }

  PageRoute<void> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => ResponsiveLayout(child: page),
      transitionsBuilder: (context, anim, secondaryAnimation, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
