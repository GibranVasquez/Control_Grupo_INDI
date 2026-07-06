import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/in_stat_card.dart';
import '../../shared/widgets/in_section_title.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_badge.dart';
import '../../models/mock_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user?.role == UserRole.operator) {
      return _OperatorDashboard(user: user!);
    }
    return _AdminDashboard();
  }
}

class _OperatorDashboard extends StatelessWidget {
  final MockUser user;
  const _OperatorDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    final vehicle = user.assignedVehicle;
    final myExpenses = MockData.allExpenses.where((e) => e.operator.id == user.id).toList();
    final todayExpenses = myExpenses.where((e) => e.date == '06/07/2026').toList();
    final totalLitersToday = todayExpenses.fold<double>(0, (s, e) => s + e.liters);
    final totalLitersWeek = myExpenses.fold<double>(0, (s, e) => s + e.liters);
    final totalAmountWeek = myExpenses.fold<double>(0, (s, e) => s + e.total);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/logo_indi_azul.png', height: 28),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Operador', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              user.initials,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.xxl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.local_gas_station_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Registrar Carga', style: AppTextStyles.heading1.copyWith(color: Colors.white)),
                          const SizedBox(height: AppSpacing.xxs),
                          Text('Toca para capturar consumo', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
              if (vehicle != null) ...[
                const SizedBox(height: AppSpacing.lg),
                InCard(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: vehicle.category == VehicleCategory.machinery
                              ? AppColors.warning.withValues(alpha: 0.1)
                              : AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          vehicle.category == VehicleCategory.machinery
                              ? Icons.precision_manufacturing_rounded
                              : Icons.local_shipping_rounded,
                          color: vehicle.category == VehicleCategory.machinery ? AppColors.warning : AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${vehicle.brand} ${vehicle.model}', style: AppTextStyles.subtitle1),
                            Text(vehicle.plate, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${vehicle.lastOdometer.toStringAsFixed(0)} ${vehicle.category == VehicleCategory.machinery ? "h" : "km"}',
                              style: AppTextStyles.subtitle2),
                          Text('${vehicle.tankCapacity}L', style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: InCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            const Icon(Icons.local_gas_station_rounded, color: AppColors.primary, size: 22),
                            const SizedBox(height: AppSpacing.xs),
                            Text('Hoy', style: AppTextStyles.caption),
                            Text('${totalLitersToday.toStringAsFixed(1)}L', style: AppTextStyles.subtitle1.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: InCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            const Icon(Icons.calendar_view_week_rounded, color: AppColors.info, size: 22),
                            const SizedBox(height: AppSpacing.xs),
                            Text('Semana', style: AppTextStyles.caption),
                            Text('${totalLitersWeek.toStringAsFixed(1)}L', style: AppTextStyles.subtitle1.copyWith(color: AppColors.info)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: InCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            const Icon(Icons.attach_money_rounded, color: AppColors.warning, size: 22),
                            const SizedBox(height: AppSpacing.xs),
                            Text('Gastado', style: AppTextStyles.caption),
                            Text('\$${totalAmountWeek.toStringAsFixed(0)}', style: AppTextStyles.subtitle1.copyWith(color: AppColors.warning)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              _WeeklyChart(expenses: myExpenses),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Últimos registros', style: AppTextStyles.subtitle1),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/history'),
                    child: Text('Ver todo', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ...myExpenses.take(3).map((e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InCard(
                  onTap: () => Navigator.pushNamed(context, '/expense-detail', arguments: e),
                  child: Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.local_gas_station_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${e.liters}L ${e.fuelType.label}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                            Text(e.date, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Text('\$${e.total.toStringAsFixed(0)}', style: AppTextStyles.subtitle2),
                      const SizedBox(width: AppSpacing.md),
                      InBadge(
                        label: e.status,
                        variant: e.status == 'Aprobado'
                            ? InBadgeVariant.approved
                            : e.status == 'Pendiente'
                                ? InBadgeVariant.pending
                                : InBadgeVariant.rejected,
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard();

  @override
  Widget build(BuildContext context) {
    final today = MockData.todayExpenses;
    final totalLiters = today.fold<double>(0, (s, e) => s + e.liters);
    final totalAmount = today.fold<double>(0, (s, e) => s + e.total);
    final pendingTickets = MockData.allExpenses.where((e) => e.status == 'Pendiente').length;
    final activeVehicles = MockData.vehicles.where((v) => v.status == 'Activo').length;
    final activeProjects = MockData.projects.where((p) => p.status == 'Activa').length;
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/logo_indi_azul.png', height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(color: _roleColor(user?.role).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(user?.roleLabel ?? '', style: AppTextStyles.caption.copyWith(color: _roleColor(user?.role), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Bienvenido,', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              Text(user?.name ?? 'Usuario', style: AppTextStyles.heading1),
              const SizedBox(height: AppSpacing.xxl),
              Text('Resumen del día', style: AppTextStyles.subtitle1.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: InStatCard(title: 'Combustible', value: '${totalLiters.toStringAsFixed(1)} L', icon: Icons.local_gas_station_rounded, subtitle: '\$${totalAmount.toStringAsFixed(0)} MXN')),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: InStatCard(title: 'Pendientes', value: '$pendingTickets', icon: Icons.pending_actions_rounded, color: AppColors.warning, subtitle: 'tickets por revisar')),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: InStatCard(title: 'Vehículos activos', value: '$activeVehicles', icon: Icons.local_shipping_rounded, color: AppColors.info)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: InStatCard(title: 'Obras activas', value: '$activeProjects', icon: Icons.business_rounded, color: AppColors.success)),
                ],
              ),
              if (pendingTickets > 0) ...[
                const SizedBox(height: AppSpacing.xxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pendientes para revisión', style: AppTextStyles.subtitle1.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                      child: Text('$pendingTickets', style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...MockData.allExpenses.where((e) => e.status == 'Pendiente').take(3).map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InCard(
                    onTap: () => Navigator.pushNamed(context, '/expense-detail', arguments: e),
                    child: Row(
                      children: [
                        Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.pending_actions_rounded, color: AppColors.warning, size: 22)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${e.vehicle.plate} - ${e.operator.name}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: AppSpacing.xxs),
                            Text('${e.date} • ${e.liters}L • \$${e.total.toStringAsFixed(0)}', style: AppTextStyles.bodySmall),
                          ],
                        )),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/history'),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('Ver todos los pendientes'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warning,
                      side: BorderSide(color: AppColors.warning.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              const InSectionTitle(title: 'Últimos movimientos'),
              const SizedBox(height: AppSpacing.md),
              ...MockData.allExpenses.take(3).map((e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InCard(
                  onTap: () => Navigator.pushNamed(context, '/expense-detail', arguments: e),
                  child: Row(
                    children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.local_gas_station_rounded, color: AppColors.primary, size: 22)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${e.vehicle.plate} - ${e.project.name}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: AppSpacing.xxs),
                          Text('${e.date} • ${e.liters}L • \$${e.total.toStringAsFixed(0)}', style: AppTextStyles.bodySmall),
                        ],
                      )),
                      InBadge(label: e.status, variant: e.status == 'Aprobado' ? InBadgeVariant.approved : e.status == 'Pendiente' ? InBadgeVariant.pending : InBadgeVariant.rejected),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: AppSpacing.xxl),
              const InSectionTitle(title: 'Accesos rápidos'),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _QACard(icon: Icons.add_circle_outline_rounded, label: 'Registrar Gasto', color: AppColors.primary, onTap: () => Navigator.pushNamed(context, '/register'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _QACard(icon: Icons.history_rounded, label: 'Historial', color: AppColors.secondary, onTap: () => Navigator.pushNamed(context, '/history'))),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _QACard(icon: Icons.business_rounded, label: 'Obras', color: AppColors.info, onTap: () => Navigator.pushNamed(context, '/projects'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _QACard(icon: Icons.local_shipping_rounded, label: 'Vehículos', color: AppColors.success, onTap: () => Navigator.pushNamed(context, '/vehicles'))),
                ],
              ),
              if (AuthService.isAdmin || AuthService.isAdministrative) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: _QACard(icon: Icons.fact_check_outlined, label: 'Validar', color: AppColors.warning, onTap: () => Navigator.pushNamed(context, '/history'))),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: _QACard(icon: Icons.attach_money_rounded, label: 'Finanzas', color: const Color(0xFF7C3AED), onTap: () => Navigator.pushNamed(context, '/finanzas'))),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: _QACard(icon: Icons.receipt_long_rounded, label: 'Presupuestos', color: const Color(0xFF0891B2), onTap: () => Navigator.pushNamed(context, '/presupuestos'))),
                    const SizedBox(width: AppSpacing.md),
                    if (AuthService.isAdmin)
                      Expanded(child: _QACard(icon: Icons.people_outline_rounded, label: 'Usuarios', color: AppColors.warning, onTap: () => Navigator.pushNamed(context, '/usuarios')))
                    else
                      const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Color _roleColor(UserRole? role) {
    switch (role) {
      case UserRole.admin: return AppColors.primary;
      case UserRole.administrative: return AppColors.info;
      case UserRole.operator: return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<MockExpense> expenses;
  const _WeeklyChart({required this.expenses});

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final dayData = <String, double>{};
    final now = DateTime(2026, 7, 6);
    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final key = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
      dayData[key] = 0;
    }
    for (final e in expenses) {
      if (dayData.containsKey(e.date)) {
        dayData[e.date] = (dayData[e.date] ?? 0) + e.liters;
      }
    }
    final maxVal = dayData.values.reduce((a, b) => a > b ? a : b);
    final values = dayData.values.toList();

    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text('Consumo semanal (L)', style: AppTextStyles.subtitle2),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final val = values[i];
                final barH = maxVal > 0 ? (val / maxVal) * 80 : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (val > 0)
                          Text(val.toStringAsFixed(0), style: AppTextStyles.caption.copyWith(fontSize: 9)),
                        const SizedBox(height: 2),
                        Container(
                          height: barH.clamp(4, 80),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.6),
                                AppColors.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(weekDays[i], style: AppTextStyles.caption.copyWith(fontSize: 9)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _QACard extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _QACard({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InCard(onTap: onTap, padding: const EdgeInsets.all(AppSpacing.lg), child: Column(
      children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 24)),
        const SizedBox(height: AppSpacing.sm),
        Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
      ],
    ));
  }
}
