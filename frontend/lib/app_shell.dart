import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/routes/app_routes.dart';
import 'core/services/auth_service.dart';
import 'shared/widgets/in_bottom_nav.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/tickets/register_expense_screen.dart';
import 'features/tickets/history_screen.dart';
import 'features/reports/finanzas_screen.dart';
import 'features/profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  List<InBottomNavItem> get _navItems {
    final items = [
      const InBottomNavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded, label: 'Dashboard', route: AppRoutes.dashboard),
      const InBottomNavItem(icon: Icons.add_circle_outline_rounded, activeIcon: Icons.add_circle_rounded, label: 'Registrar', route: AppRoutes.register),
      const InBottomNavItem(icon: Icons.history_outlined, activeIcon: Icons.history_rounded, label: 'Historial', route: AppRoutes.history),
    ];
    if (AuthService.isAdmin || AuthService.isAdministrative) {
      items.add(const InBottomNavItem(icon: Icons.attach_money_outlined, activeIcon: Icons.attach_money_rounded, label: 'Finanzas', route: AppRoutes.finanzas));
    }
    items.add(const InBottomNavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Perfil', route: AppRoutes.profile));
    return items;
  }

  List<Widget> get _screens {
    final screens = <Widget>[
      const DashboardScreen(),
      const RegisterExpenseScreen(),
      const HistoryScreen(),
    ];
    if (AuthService.isAdmin || AuthService.isAdministrative) {
      screens.add(const FinanzasScreen());
    }
    screens.add(const ProfileScreen());
    return screens;
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: InBottomNav(currentIndex: _currentIndex, items: _navItems, onTap: _onTabTapped),
    );
  }
}
