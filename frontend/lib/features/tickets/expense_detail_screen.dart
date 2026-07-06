import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_badge.dart';
import '../../shared/widgets/in_button.dart';
import '../../models/mock_data.dart';

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expense = ModalRoute.of(context)!.settings.arguments as MockExpense;
    final canEdit = AuthService.isAdmin || AuthService.isAdministrative;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, expense),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCard(expense),
                    const SizedBox(height: AppSpacing.lg),
                    _buildInfoSection(expense),
                    const SizedBox(height: AppSpacing.lg),
                    _buildTicketSection(expense),
                    const SizedBox(height: AppSpacing.lg),
                    _buildNotesSection(expense),
                    const SizedBox(height: AppSpacing.xxl),
                    if (canEdit) _buildActions(context, expense),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MockExpense expense) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: AppColors.background,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('Detalle del Gasto', style: AppTextStyles.heading2),
            const Spacer(),
            IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(MockExpense expense) {
    return InCard(
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.folio, style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.xxs),
                Text('${expense.date} • ${expense.fuelType.label}', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          InBadge(label: expense.status, variant: expense.status == 'Aprobado' ? InBadgeVariant.approved : expense.status == 'Pendiente' ? InBadgeVariant.pending : InBadgeVariant.rejected),
        ],
      ),
    );
  }

  Widget _buildInfoSection(MockExpense expense) {
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Información del gasto', style: AppTextStyles.subtitle2),
          const SizedBox(height: AppSpacing.lg),
          _DetailRow(label: 'Obra', value: expense.project.name, icon: Icons.business_rounded),
          _DetailRow(label: 'Vehículo', value: '${expense.vehicle.plate} - ${expense.vehicle.brand} ${expense.vehicle.model} (${expense.vehicle.category.label})', icon: Icons.local_shipping_rounded),
          _DetailRow(label: 'Operador', value: expense.operator.name, icon: Icons.person_outline_rounded),
          _DetailRow(label: 'Kilometraje', value: '${expense.odometer.toStringAsFixed(0)} km', icon: Icons.speed_rounded),
          _DetailRow(label: 'Litros', value: '${expense.liters.toStringAsFixed(1)} L', icon: Icons.water_drop_outlined),
          _DetailRow(label: 'Tipo', value: expense.fuelType.label, icon: Icons.local_gas_station_rounded),
          _DetailRow(label: 'Costo por litro', value: '\$${expense.costPerLiter.toStringAsFixed(2)}', icon: Icons.attach_money_rounded),
          if (expense.authorizedBy.isNotEmpty)
            _DetailRow(label: 'Autorizado por', value: expense.authorizedBy, icon: Icons.verified_outlined),
          const Divider(height: AppSpacing.xxl, color: AppColors.borderLight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Importe total', style: AppTextStyles.subtitle1),
              Text('\$${expense.total.toStringAsFixed(2)}', style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketSection(MockExpense expense) {
    if (!expense.hasTicket) return const SizedBox.shrink();
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ticket', style: AppTextStyles.subtitle2),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity, height: 200,
            decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(AppSpacing.cardRadius), border: Border.all(color: AppColors.border)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_rounded, size: 48, color: AppColors.textHint),
                const SizedBox(height: AppSpacing.sm),
                Text('Vista previa del ticket', style: AppTextStyles.bodySmall),
                Text(expense.folio, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(MockExpense expense) {
    if (expense.notes == null) return const SizedBox.shrink();
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Observaciones', style: AppTextStyles.subtitle2),
          const SizedBox(height: AppSpacing.md),
          Text(expense.notes!, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, MockExpense expense) {
    final canValidate = AuthService.isAdmin || AuthService.isAdministrative;

    if (canValidate && expense.status == 'Pendiente') {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InButton(
                  label: 'Aprobar',
                  icon: Icons.check_circle_outline_rounded,
                  variant: InButtonVariant.primary,
                  onPressed: () => _handleApproval(context, expense, 'Aprobado'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: InButton(
                  label: 'Rechazar',
                  icon: Icons.cancel_outlined,
                  variant: InButtonVariant.danger,
                  onPressed: () => _handleApproval(context, expense, 'Rechazado'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: InButton(label: 'Editar', icon: Icons.edit_outlined, variant: InButtonVariant.outline, onPressed: () {})),
              const SizedBox(width: AppSpacing.md),
                Expanded(child: InButton(label: 'Eliminar', icon: Icons.delete_outline_rounded, variant: InButtonVariant.danger, onPressed: () => _confirmDelete(context, expense))),
              ],
            ),
          ],
        );
      }

    return Row(
      children: [
        Expanded(child: InButton(label: 'Editar', icon: Icons.edit_outlined, variant: InButtonVariant.outline, onPressed: () {})),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: InButton(label: 'Eliminar', icon: Icons.delete_outline_rounded, variant: InButtonVariant.danger, onPressed: () => _confirmDelete(context, expense))),
      ],
    );
  }

  void _confirmDelete(BuildContext context, MockExpense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar gasto'),
        content: Text('¿Eliminar ${expense.folio} por \$${expense.total.toStringAsFixed(2)}? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              MockData.deleteExpense(expense.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gasto eliminado correctamente'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _handleApproval(BuildContext context, MockExpense expense, String newStatus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(newStatus == 'Aprobado' ? 'Aprobar gasto' : 'Rechazar gasto'),
        content: Text(newStatus == 'Aprobado'
            ? '¿Confirmas la aprobación de ${expense.folio} por \$${expense.total.toStringAsFixed(2)}?'
            : '¿Estás seguro de rechazar ${expense.folio}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              MockData.updateExpenseStatus(
                expense.id,
                newStatus,
                AuthService.currentUser?.name ?? 'Admin',
              );
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gasto ${newStatus == "Aprobado" ? "aprobado" : "rechazado"} correctamente'),
                  backgroundColor: newStatus == 'Aprobado' ? AppColors.success : AppColors.error,
                ),
              );
            },
            child: Text(newStatus == 'Aprobado' ? 'Aprobar' : 'Rechazar',
                style: TextStyle(color: newStatus == 'Aprobado' ? AppColors.success : AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label; final String value; final IconData icon;
  const _DetailRow({required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Text('$label: ', style: AppTextStyles.bodySmall),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
