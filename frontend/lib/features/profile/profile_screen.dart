import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_button.dart';
import '../../shared/widgets/in_badge.dart';
import '../../models/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    if (user == null) return const SizedBox.shrink();

    if (user.role == UserRole.operator) {
      return _OperatorProfileScreen(user: user);
    }
    return _AdminProfileScreen(user: user);
  }
}

class _OperatorProfileScreen extends StatelessWidget {
  final MockUser user;
  const _OperatorProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final vehicle = user.assignedVehicle;
    final myExpenses = MockData.allExpenses.where((e) => e.operator.id == user.id).toList();
    final totalLiters = myExpenses.fold<double>(0, (s, e) => s + e.liters);
    final totalAmount = myExpenses.fold<double>(0, (s, e) => s + e.total);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildProfileHeader(context, user),
                    const SizedBox(height: AppSpacing.lg),
                    if (vehicle != null) ...[
                      _buildVehicleSection(context, vehicle),
                      const SizedBox(height: AppSpacing.lg),
                      _buildMaintenanceSection(vehicle),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    _buildStatsSection(totalLiters, totalAmount, myExpenses.length),
                    const SizedBox(height: AppSpacing.lg),
                    _buildMenuSection(context),
                    const SizedBox(height: AppSpacing.xxl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: InButton(
                        label: 'Cerrar sesión',
                        icon: Icons.logout_rounded,
                        variant: InButtonVariant.danger,
                        onPressed: () {
                          AuthService.logout();
                          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final hasBack = ModalRoute.of(context)?.settings.name != '/dashboard';
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: AppColors.background,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        child: Row(
          children: [
            if (hasBack) ...[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Text('Mi Perfil', style: AppTextStyles.heading2),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, MockUser user) {
    final vehicle = user.assignedVehicle;
    return InCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 68, height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppTextStyles.heading1),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(user.roleLabel, style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(user.employeeId, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xxl, color: AppColors.borderLight),
          _InfoRow(icon: Icons.badge_outlined, label: 'Empleado', value: user.employeeId),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(icon: Icons.phone_outlined, label: 'Teléfono', value: user.phone),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(icon: Icons.email_outlined, label: 'Correo', value: user.email),
          if (user.supervisor.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(icon: Icons.supervisor_account_outlined, label: 'Supervisor', value: user.supervisor),
          ],
          if (vehicle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.business_rounded,
              label: 'Obra asignada',
              value: MockData.projects.firstWhere((p) => p.id == 'P-001').name,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVehicleSection(BuildContext context, MockVehicle v) {
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  v.category == VehicleCategory.machinery
                      ? Icons.precision_manufacturing_rounded
                      : Icons.local_shipping_rounded,
                  color: AppColors.primary, size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${v.brand} ${v.model} ${v.year}', style: AppTextStyles.subtitle1),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Text(v.plate, style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
                        const SizedBox(width: AppSpacing.sm),
                        Container(width: 3, height: 3, decoration: const BoxDecoration(color: AppColors.textSecondary, shape: BoxShape.circle)),
                        const SizedBox(width: AppSpacing.sm),
                        Text(v.type, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              InBadge(label: v.status, variant: v.status == 'Activo' ? InBadgeVariant.success : InBadgeVariant.warning),
            ],
          ),
          const Divider(height: AppSpacing.xxl, color: AppColors.borderLight),
          _InfoRow(icon: Icons.palette_outlined, label: 'Color', value: v.color),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(icon: Icons.local_gas_station_rounded, label: 'Combustible', value: v.fuelType.label),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.speed_rounded,
            label: 'Kilometraje actual',
            value: '${v.lastOdometer.toStringAsFixed(0)} ${v.category == VehicleCategory.machinery ? "horas" : "km"}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(icon: Icons.water_drop_outlined, label: 'Capacidad del tanque', value: '${v.tankCapacity}L'),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(icon: Icons.trending_up_rounded, label: 'Rendimiento esperado', value: '${v.expectedPerformance} km/L'),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSection(MockVehicle v) {
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build_outlined, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text('Mantenimiento y documentos', style: AppTextStyles.subtitle2),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Último servicio',
            value: v.lastMaintenanceDate,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.calendar_month_outlined,
            label: 'Próximo servicio',
            value: v.nextMaintenanceDate,
            valueColor: AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icons.shield_outlined,
            label: 'Seguro vigente hasta',
            value: v.insuranceExpiry,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.description_outlined, size: 18),
                  label: const Text('Documentos', style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history_outlined, size: 18),
                  label: const Text('Historial', style: TextStyle(fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(double totalLiters, double totalAmount, int totalRecords) {
    return Row(
      children: [
        Expanded(
          child: InCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Icon(Icons.local_gas_station_rounded, size: 24, color: AppColors.primary),
                const SizedBox(height: AppSpacing.sm),
                Text('${totalLiters.toStringAsFixed(1)}L', style: AppTextStyles.subtitle1),
                Text('Consumidos', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: InCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Icon(Icons.attach_money_rounded, size: 24, color: AppColors.warning),
                const SizedBox(height: AppSpacing.sm),
                Text('\$${totalAmount.toStringAsFixed(0)}', style: AppTextStyles.subtitle1),
                Text('Gastados', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: InCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Icon(Icons.receipt_outlined, size: 24, color: AppColors.info),
                const SizedBox(height: AppSpacing.sm),
                Text('$totalRecords', style: AppTextStyles.subtitle1),
                Text('Registros', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return InCard(
      child: Column(
        children: [
          _MenuItem(icon: Icons.history_rounded, label: 'Mi historial', onTap: () => Navigator.pushNamed(context, '/history')),
          const Divider(height: 1, color: AppColors.borderLight),
          _MenuItem(icon: Icons.local_gas_station_rounded, label: 'Registrar carga', onTap: () => Navigator.pushNamed(context, '/register')),
          const Divider(height: 1, color: AppColors.borderLight),
          _MenuItem(icon: Icons.settings_outlined, label: 'Configuración', onTap: () => Navigator.pushNamed(context, '/settings')),
          const Divider(height: 1, color: AppColors.borderLight),
          _MenuItem(icon: Icons.help_outline_rounded, label: 'Ayuda', onTap: () {}),
        ],
      ),
    );
  }
}

class _AdminProfileScreen extends StatelessWidget {
  final MockUser user;
  const _AdminProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAdminHeader(context),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildAdminProfileCard(context, user),
                    const SizedBox(height: AppSpacing.lg),
                    _buildAdminMenuSection(context),
                    const SizedBox(height: AppSpacing.xxl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: InButton(
                        label: 'Cerrar sesión',
                        icon: Icons.logout_rounded,
                        variant: InButtonVariant.danger,
                        onPressed: () {
                          AuthService.logout();
                          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context) {
    final hasBack = ModalRoute.of(context)?.settings.name != '/dashboard';
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: AppColors.background,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        child: Row(
          children: [
            if (hasBack) ...[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Text('Mi Perfil', style: AppTextStyles.heading2),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminProfileCard(BuildContext context, MockUser user) {
    return InCard(
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(user.initials, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.xxs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: _roleColor(user.role).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(user.roleLabel, style: AppTextStyles.caption.copyWith(color: _roleColor(user.role), fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(user.email, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminMenuSection(BuildContext context) {
    return InCard(
      child: Column(
        children: [
          if (AuthService.isAdmin || AuthService.isAdministrative) ...[
            _MenuItem(icon: Icons.attach_money_rounded, label: 'Finanzas', onTap: () => Navigator.pushNamed(context, '/finanzas')),
            const Divider(height: 1, color: AppColors.borderLight),
            _MenuItem(icon: Icons.receipt_long_rounded, label: 'Presupuestos', onTap: () => Navigator.pushNamed(context, '/presupuestos')),
            const Divider(height: 1, color: AppColors.borderLight),
          ],
          if (AuthService.isAdmin) ...[
            _MenuItem(icon: Icons.people_outline_rounded, label: 'Usuarios', onTap: () => Navigator.pushNamed(context, '/usuarios')),
            const Divider(height: 1, color: AppColors.borderLight),
          ],
          _MenuItem(icon: Icons.settings_outlined, label: 'Configuración', onTap: () => Navigator.pushNamed(context, '/settings')),
          const Divider(height: 1, color: AppColors.borderLight),
          _MenuItem(icon: Icons.help_outline_rounded, label: 'Ayuda', onTap: () {}),
          const Divider(height: 1, color: AppColors.borderLight),
          _MenuItem(icon: Icons.info_outline_rounded, label: 'Acerca de', onTap: () {}),
        ],
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.admin: return AppColors.primary;
      case UserRole.administrative: return AppColors.info;
      case UserRole.operator: return AppColors.success;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Text('$label: ', style: AppTextStyles.bodySmall),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
