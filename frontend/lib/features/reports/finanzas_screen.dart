import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_section_title.dart';
import '../../shared/widgets/in_stat_card.dart';
import '../../shared/widgets/in_badge.dart';
import '../../models/mock_data.dart';

class FinanzasScreen extends StatelessWidget {
  const FinanzasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: _buildAppBar(context, canPop),
        ),
        body: const _FinanzasTabContent(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool canPop) {
    return Container(
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
            child: Row(
              children: [
                if (canPop)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                if (canPop) const SizedBox(width: AppSpacing.md),
                Expanded(child: Text('Finanzas', style: AppTextStyles.heading2)),
              ],
            ),
          ),
          Container(
            color: AppColors.background,
            child: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              labelStyle: AppTextStyles.subtitle2,
              tabs: const [
                Tab(text: 'Diario'),
                Tab(text: 'Semanal'),
                Tab(text: 'Mensual'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanzasTabContent extends StatelessWidget {
  const _FinanzasTabContent();

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        _DailyView(),
        _WeeklyView(),
        _MonthlyView(),
      ],
    );
  }
}

class _DailyView extends StatelessWidget {
  const _DailyView();

  @override
  Widget build(BuildContext context) {
    final today = MockData.todayExpenses;
    final totalLiters = today.fold<double>(0, (s, e) => s + e.liters);
    final totalAmount = today.fold<double>(0, (s, e) => s + e.total);
    final diesel = today.where((e) => e.fuelType == FuelType.diesel);
    final magna = today.where((e) => e.fuelType == FuelType.magna);
    final premium = today.where((e) => e.fuelType == FuelType.premium);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('\$${totalAmount.toStringAsFixed(0)}',
                          style: AppTextStyles.amountLarge.copyWith(color: AppColors.primary)),
                      const SizedBox(height: AppSpacing.xxs),
                      Text('Total gastado hoy', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.borderLight),
                Expanded(
                  child: Column(
                    children: [
                      Text('${totalLiters.toStringAsFixed(1)}L',
                          style: AppTextStyles.amountLarge),
                      const SizedBox(height: AppSpacing.xxs),
                      Text('Total litros', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Desglose por tipo', style: AppTextStyles.subtitle2),
          const SizedBox(height: AppSpacing.md),
          _FuelRow(label: 'Diésel', liters: diesel.fold<double>(0, (s, e) => s + e.liters), amount: diesel.fold<double>(0, (s, e) => s + e.total), color: const Color(0xFF1E40AF)),
          const SizedBox(height: AppSpacing.sm),
          _FuelRow(label: 'Gasolina Magna', liters: magna.fold<double>(0, (s, e) => s + e.liters), amount: magna.fold<double>(0, (s, e) => s + e.total), color: AppColors.success),
          const SizedBox(height: AppSpacing.sm),
          _FuelRow(label: 'Gasolina Premium', liters: premium.fold<double>(0, (s, e) => s + e.liters), amount: premium.fold<double>(0, (s, e) => s + e.total), color: AppColors.warning),
          const SizedBox(height: AppSpacing.lg),
          const InSectionTitle(title: 'Vehículos vs Maquinaria'),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: InStatCard(
                title: 'Vehículos',
                value: '${today.where((e) => e.vehicle.category == VehicleCategory.vehicle).fold<double>(0, (s, e) => s + e.liters).toStringAsFixed(1)}L',
                icon: Icons.local_shipping_rounded, color: AppColors.info,
                subtitle: '\$${today.where((e) => e.vehicle.category == VehicleCategory.vehicle).fold<double>(0, (s, e) => s + e.total).toStringAsFixed(0)}',
              )),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: InStatCard(
                title: 'Maquinaria',
                value: '${today.where((e) => e.vehicle.category == VehicleCategory.machinery).fold<double>(0, (s, e) => s + e.liters).toStringAsFixed(1)}L',
                icon: Icons.precision_manufacturing_rounded, color: AppColors.warning,
                subtitle: '\$${today.where((e) => e.vehicle.category == VehicleCategory.machinery).fold<double>(0, (s, e) => s + e.total).toStringAsFixed(0)}',
              )),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const InSectionTitle(title: 'Gastos del día'),
          const SizedBox(height: AppSpacing.md),
          ...today.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InCard(
              child: Row(
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${e.vehicle.plate} · ${e.operator.name}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      Text('${e.liters}L · \$${e.total.toStringAsFixed(2)} · ${e.fuelType.label}', style: AppTextStyles.bodySmall),
                    ],
                  )),
                  InBadge(label: e.status, variant: e.status == 'Aprobado' ? InBadgeVariant.approved : e.status == 'Pendiente' ? InBadgeVariant.pending : InBadgeVariant.rejected),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _WeeklyView extends StatelessWidget {
  const _WeeklyView();

  Widget _buildBarChart(List<MockExpense> week) {
    final map = <String, double>{};
    for (final e in week) {
      map.update(e.date, (v) => v + e.total, ifAbsent: () => e.total);
    }
    final maxVal = map.values.fold<double>(0, (a, b) => a > b ? a : b);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: map.entries.map((entry) {
        final h = maxVal > 0 ? (entry.value / maxVal) * 100 : 0.0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: h.clamp(4, 100),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(entry.key.substring(0, 2), style: AppTextStyles.caption),
            Text('\$${entry.value.toStringAsFixed(0)}', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final week = MockData.allExpenses;
    final totalAmount = week.fold<double>(0, (s, e) => s + e.total);
    final totalLiters = week.fold<double>(0, (s, e) => s + e.liters);

    final days = <String, List<MockExpense>>{};
    for (final e in week) {
      days.putIfAbsent(e.date, () => []).add(e);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Column(children: [
                      Text('\$${totalAmount.toStringAsFixed(0)}', style: AppTextStyles.amountLarge.copyWith(color: AppColors.primary)),
                      const SizedBox(height: AppSpacing.xxs),
                      Text('Gasto semanal', style: AppTextStyles.bodySmall),
                    ])),
                    Container(width: 1, height: 40, color: AppColors.borderLight),
                    Expanded(child: Column(children: [
                      Text('${totalLiters.toStringAsFixed(1)}L', style: AppTextStyles.amountLarge),
                      const SizedBox(height: AppSpacing.xxs),
                      Text('Litros totales', style: AppTextStyles.bodySmall),
                    ])),
                  ],
                ),
                const Divider(height: AppSpacing.xxl, color: AppColors.borderLight),
                _buildBarChart(week),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const InSectionTitle(title: 'Resumen por tipo'),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(label: 'Diésel', liters: week.where((e) => e.fuelType == FuelType.diesel).fold<double>(0, (s, e) => s + e.liters), amount: week.where((e) => e.fuelType == FuelType.diesel).fold<double>(0, (s, e) => s + e.total)),
          _SummaryRow(label: 'Gasolina Magna', liters: week.where((e) => e.fuelType == FuelType.magna).fold<double>(0, (s, e) => s + e.liters), amount: week.where((e) => e.fuelType == FuelType.magna).fold<double>(0, (s, e) => s + e.total)),
          _SummaryRow(label: 'Gasolina Premium', liters: week.where((e) => e.fuelType == FuelType.premium).fold<double>(0, (s, e) => s + e.liters), amount: week.where((e) => e.fuelType == FuelType.premium).fold<double>(0, (s, e) => s + e.total)),
        ],
      ),
    );
  }
}

class _MonthlyView extends StatelessWidget {
  const _MonthlyView();

  @override
  Widget build(BuildContext context) {
    final all = MockData.allExpenses;
    final totalLiters = all.fold<double>(0, (s, e) => s + e.liters);
    final totalAmount = all.fold<double>(0, (s, e) => s + e.total);
    final diesel = all.where((e) => e.fuelType == FuelType.diesel);
    final magna = all.where((e) => e.fuelType == FuelType.magna);
    final premium = all.where((e) => e.fuelType == FuelType.premium);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InCard(
            child: Row(
              children: [
                Expanded(child: Column(children: [
                  Text('\$${totalAmount.toStringAsFixed(0)}', style: AppTextStyles.amountLarge.copyWith(color: AppColors.primary)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text('Gasto mensual estimado', style: AppTextStyles.bodySmall),
                ])),
                Container(width: 1, height: 40, color: AppColors.borderLight),
                Expanded(child: Column(children: [
                  Text('${totalLiters.toStringAsFixed(1)}L', style: AppTextStyles.amountLarge),
                  const SizedBox(height: AppSpacing.xxs),
                  Text('Litros totales', style: AppTextStyles.bodySmall),
                ])),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const InSectionTitle(title: 'Comparativa por tipo'),
          const SizedBox(height: AppSpacing.md),
          InCard(
            child: Column(
              children: [
                _MonthFuelRow(label: 'Diésel', liters: diesel.fold<double>(0, (s, e) => s + e.liters), amount: diesel.fold<double>(0, (s, e) => s + e.total), percent: 0.65),
                const Divider(height: AppSpacing.lg, color: AppColors.borderLight),
                _MonthFuelRow(label: 'Gasolina Magna', liters: magna.fold<double>(0, (s, e) => s + e.liters), amount: magna.fold<double>(0, (s, e) => s + e.total), percent: 0.25),
                const Divider(height: AppSpacing.lg, color: AppColors.borderLight),
                _MonthFuelRow(label: 'Gasolina Premium', liters: premium.fold<double>(0, (s, e) => s + e.liters), amount: premium.fold<double>(0, (s, e) => s + e.total), percent: 0.10),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const InSectionTitle(title: 'Proyección mensual'),
          const SizedBox(height: AppSpacing.md),
          InCard(
            child: Column(
              children: [
                _ProjectionRow(label: 'Gasto actual (Sem 27)', amount: totalAmount),
                const SizedBox(height: AppSpacing.sm),
                _ProjectionRow(label: 'Proyección mensual', amount: totalAmount * 4),
                const SizedBox(height: AppSpacing.sm),
                _ProjectionRow(label: 'Presupuesto mensual', amount: totalAmount * 4.2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FuelRow extends StatelessWidget {
  final String label; final double liters; final double amount; final Color color;
  const _FuelRow({required this.label, required this.liters, required this.amount, required this.color});
  @override
  Widget build(BuildContext context) {
    return InCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(width: 4, height: 32, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
          Text('${liters.toStringAsFixed(1)}L', style: AppTextStyles.bodySmall),
          const SizedBox(width: AppSpacing.lg),
          Text('\$${amount.toStringAsFixed(0)}', style: AppTextStyles.subtitle2),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label; final double liters; final double amount;
  const _SummaryRow({required this.label, required this.liters, required this.amount});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: AppTextStyles.bodyMedium)),
          Expanded(child: Text('${liters.toStringAsFixed(1)} L', style: AppTextStyles.bodyMedium, textAlign: TextAlign.right)),
          Expanded(child: Text('\$${amount.toStringAsFixed(0)}', style: AppTextStyles.subtitle2, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _MonthFuelRow extends StatelessWidget {
  final String label; final double liters; final double amount; final double percent;
  const _MonthFuelRow({required this.label, required this.liters, required this.amount, required this.percent});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            Text('\$${amount.toStringAsFixed(0)}', style: AppTextStyles.subtitle2),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent, backgroundColor: AppColors.borderLight, color: AppColors.primary, minHeight: 8,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${liters.toStringAsFixed(1)} L', style: AppTextStyles.caption),
            Text('${(percent * 100).toStringAsFixed(0)}%', style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }
}

class _ProjectionRow extends StatelessWidget {
  final String label; final double amount;
  const _ProjectionRow({required this.label, required this.amount});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text('\$${amount.toStringAsFixed(0)}', style: AppTextStyles.subtitle2),
      ],
    );
  }
}
