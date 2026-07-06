import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_search_bar.dart';
import '../../shared/widgets/in_badge.dart';
import '../../shared/widgets/in_empty_state.dart';
import '../../models/mock_data.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  String _query = '';

  List<MockVehicle> get _filtered => MockData.vehicles.where((v) =>
    v.plate.toLowerCase().contains(_query.toLowerCase()) ||
    v.brand.toLowerCase().contains(_query.toLowerCase()) ||
    v.category.label.toLowerCase().contains(_query.toLowerCase())
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
              child: InSearchBar(hint: 'Buscar vehículo o maquinaria...', onChanged: (v) => setState(() => _query = v)),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? const InEmptyState(icon: Icons.local_shipping_rounded, title: 'Sin resultados', subtitle: 'No hay vehículos registrados')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) => _VehicleCard(vehicle: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            Expanded(child: Text('Vehículos y Maquinaria', style: AppTextStyles.heading2)),
            Text('${_filtered.length}', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final MockVehicle vehicle;
  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InCard(
        child: Row(
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: vehicle.category == VehicleCategory.machinery
                    ? AppColors.warning.withValues(alpha: 0.1)
                    : AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    vehicle.category == VehicleCategory.machinery
                        ? Icons.precision_manufacturing_rounded
                        : Icons.local_shipping_rounded,
                    color: vehicle.category == VehicleCategory.machinery ? AppColors.warning : AppColors.secondary,
                    size: 26,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(vehicle.plate, style: AppTextStyles.caption.copyWith(
                    color: vehicle.category == VehicleCategory.machinery ? AppColors.warning : AppColors.secondary,
                    fontWeight: FontWeight.w700, letterSpacing: 0.5,
                  )),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${vehicle.brand} ${vehicle.model} ${vehicle.year}', style: AppTextStyles.subtitle2),
                  const SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: [
                      Text('${vehicle.type} · ${vehicle.category.label}', style: AppTextStyles.bodySmall),
                      Container(width: 3, height: 3, margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                        decoration: const BoxDecoration(color: AppColors.textSecondary, shape: BoxShape.circle)),
                      Text(vehicle.fuelType.label, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: [
                      Icon(Icons.speed_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.xxs),
                      Text('${vehicle.lastOdometer.toStringAsFixed(0)} ${vehicle.category == VehicleCategory.machinery ? "horas" : "km"}', style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
            InBadge(label: vehicle.status, variant: vehicle.status == 'Activo' ? InBadgeVariant.success : InBadgeVariant.warning),
          ],
        ),
      ),
    );
  }
}
