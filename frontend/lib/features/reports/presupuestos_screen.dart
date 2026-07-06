import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_badge.dart';
import '../../shared/widgets/in_search_bar.dart';
import '../../shared/widgets/in_button.dart';
import '../../shared/widgets/in_text_field.dart';
import '../../shared/widgets/in_dropdown.dart';
import '../../models/mock_data.dart';

class PresupuestosScreen extends StatefulWidget {
  const PresupuestosScreen({super.key});

  @override
  State<PresupuestosScreen> createState() => _PresupuestosScreenState();
}

class _PresupuestosScreenState extends State<PresupuestosScreen> {
  String _query = '';

  List<MockBudget> get _filtered => MockData.budgets.where((b) =>
    b.project.name.toLowerCase().contains(_query.toLowerCase()) ||
    b.vehicle.plate.toLowerCase().contains(_query.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: InSearchBar(
                hint: 'Buscar presupuesto...',
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textHint),
                          const SizedBox(height: AppSpacing.md),
                          Text('Sin presupuestos', style: AppTextStyles.heading2),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) => _BudgetCard(budget: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: AuthService.isAdmin || AuthService.isAdministrative
          ? FloatingActionButton(
              onPressed: () => _showCreateDialog(context),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: AppColors.background,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text('Presupuestos', style: AppTextStyles.heading2)),
            Text('${_filtered.length}', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    String? selectedProject;
    String? selectedVehicle;
    String? selectedOperator;
    String? selectedFuel;
    double approvedLiters = 0;
    double estimatedCost = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.sheetRadius)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: AppSpacing.xxl,
            right: AppSpacing.xxl,
            top: AppSpacing.xxl,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nuevo Presupuesto', style: AppTextStyles.heading1),
                const SizedBox(height: AppSpacing.xl),
                InDropdown(
                  label: 'Obra',
                  value: selectedProject,
                  hint: 'Seleccionar obra',
                  items: MockData.projects.map((p) => DropdownMenuItem(
                    value: p.id,
                    child: Text(p.name),
                  )).toList(),
                  onChanged: (v) => setDialogState(() => selectedProject = v),
                ),
                const SizedBox(height: AppSpacing.md),
                InDropdown(
                  label: 'Vehículo/Maquinaria',
                  value: selectedVehicle,
                  hint: 'Seleccionar',
                  items: MockData.vehicles.map((v) => DropdownMenuItem(
                    value: v.id,
                    child: Text('${v.plate} - ${v.brand} ${v.model}'),
                  )).toList(),
                  onChanged: (v) => setDialogState(() => selectedVehicle = v),
                ),
                const SizedBox(height: AppSpacing.md),
                InDropdown(
                  label: 'Operador',
                  value: selectedOperator,
                  hint: 'Seleccionar',
                  items: MockData.users.where((u) => u.role == UserRole.operator).map((u) => DropdownMenuItem(
                    value: u.id,
                    child: Text(u.name),
                  )).toList(),
                  onChanged: (v) => setDialogState(() => selectedOperator = v),
                ),
                const SizedBox(height: AppSpacing.md),
                InDropdown(
                  label: 'Tipo de combustible',
                  value: selectedFuel,
                  hint: 'Seleccionar',
                  items: MockData.fuelTypes.map((f) => DropdownMenuItem(
                    value: f.name,
                    child: Text(f.label),
                  )).toList(),
                  onChanged: (v) => setDialogState(() => selectedFuel = v),
                ),
                const SizedBox(height: AppSpacing.md),
                InTextField(
                  label: 'Litros aprobados',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setDialogState(() {
                      approvedLiters = double.tryParse(v) ?? 0;
                      estimatedCost = approvedLiters * 24;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: Text('Costo estimado:', style: AppTextStyles.bodyMedium)),
                    Text('\$${estimatedCost.toStringAsFixed(2)}', style: AppTextStyles.subtitle2.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                InButton(
                  label: 'Crear Presupuesto',
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Presupuesto creado correctamente'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final MockBudget budget;

  const _BudgetCard({required this.budget});

  @override
  Widget build(BuildContext context) {
    final percent = budget.approvedLiters > 0
        ? budget.spentLiters / budget.approvedLiters
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: AppColors.secondary, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(budget.project.name, style: AppTextStyles.subtitle2),
                      const SizedBox(height: AppSpacing.xxs),
                      Text('${budget.vehicle.plate} · ${budget.operator.name}',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                InBadge(
                  label: budget.status,
                  variant: budget.status == 'Activo'
                      ? InBadgeVariant.approved
                      : InBadgeVariant.info,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1, color: AppColors.borderLight),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(budget.fuelType.label, style: AppTextStyles.bodySmall),
                      const SizedBox(height: AppSpacing.xxs),
                      Text('${budget.approvedLiters.toStringAsFixed(0)}L aprobados',
                          style: AppTextStyles.subtitle2),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Gastado', style: AppTextStyles.bodySmall),
                      const SizedBox(height: AppSpacing.xxs),
                      Text('${budget.spentLiters.toStringAsFixed(0)}L / \$${budget.spentAmount.toStringAsFixed(0)}',
                          style: AppTextStyles.subtitle2.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent.clamp(0.0, 1.0),
                backgroundColor: AppColors.borderLight,
                color: percent > 0.8 ? AppColors.warning : AppColors.primary,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(percent * 100).toStringAsFixed(0)}% usado',
                    style: AppTextStyles.caption),
                Text('Restante: ${budget.remainingLiters.toStringAsFixed(0)}L',
                    style: AppTextStyles.caption.copyWith(
                      color: budget.remainingLiters > 0 ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
