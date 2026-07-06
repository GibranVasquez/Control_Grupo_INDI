import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_badge.dart';
import '../../shared/widgets/in_search_bar.dart';
import '../../shared/widgets/in_empty_state.dart';
import '../../shared/widgets/in_button.dart';
import '../../models/mock_data.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  String? _filterProject;
  String? _filterVehicle;
  String? _filterStatus;
  String? _filterWeek;

  bool get _hasActiveFilters =>
      _filterProject != null || _filterVehicle != null || _filterStatus != null || _filterWeek != null;

  List<MockExpense> get _visibleExpenses {
    final user = AuthService.currentUser;
    final all = MockData.allExpenses;
    if (user?.role == UserRole.operator) {
      return all.where((e) => e.operator.id == user!.id).toList();
    }
    return all;
  }

  List<MockExpense> get _filteredExpenses {
    return _visibleExpenses.where((e) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!e.vehicle.plate.toLowerCase().contains(q) &&
            !e.operator.name.toLowerCase().contains(q) &&
            !e.folio.toLowerCase().contains(q) &&
            !e.project.name.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_filterProject != null && e.project.id != _filterProject) return false;
      if (_filterVehicle != null && e.vehicle.id != _filterVehicle) return false;
      if (_filterStatus != null && e.status != _filterStatus) return false;
      if (_filterWeek != null && e.week != _filterWeek) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<String> get _availableWeeks {
    final weeks = _visibleExpenses.map((e) => e.week).toSet().toList();
    weeks.sort((a, b) => b.compareTo(a));
    return weeks;
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.sheetRadius)),
      ),
      builder: (ctx) => _FilterSheet(
        selectedProject: _filterProject,
        selectedVehicle: _filterVehicle,
        selectedStatus: _filterStatus,
        selectedWeek: _filterWeek,
        weeks: _availableWeeks,
        onApply: (p, v, s, w) {
          setState(() { _filterProject = p; _filterVehicle = v; _filterStatus = s; _filterWeek = w; });
          Navigator.pop(ctx);
        },
        onClear: () {
          setState(() { _filterProject = null; _filterVehicle = null; _filterStatus = null; _filterWeek = null; });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final isAdmin = user?.role != UserRole.operator;
    final filtered = _filteredExpenses;
    final totalLiters = filtered.fold<double>(0, (s, e) => s + e.liters);
    final totalAmount = filtered.fold<double>(0, (s, e) => s + e.total);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  InSearchBar(hint: 'Buscar por placa, operador, folio...', onChanged: (v) => setState(() => _searchQuery = v)),
                  const SizedBox(height: AppSpacing.md),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(label: 'Filtros', icon: Icons.tune_rounded, isActive: _hasActiveFilters, onTap: _showFilters),
                        if (_filterWeek != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _FilterChip(label: _filterWeek!, isActive: true, removable: true, onTap: () => setState(() => _filterWeek = null)),
                        ],
                        if (_filterStatus != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _FilterChip(label: _filterStatus!, isActive: true, removable: true, onTap: () => setState(() => _filterStatus = null)),
                        ],
                        if (_filterProject != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _FilterChip(label: MockData.projects.firstWhere((p) => p.id == _filterProject).name, isActive: true, removable: true, onTap: () => setState(() => _filterProject = null)),
                        ],
                        if (_filterVehicle != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _FilterChip(label: MockData.vehicles.firstWhere((v) => v.id == _filterVehicle).plate, isActive: true, removable: true, onTap: () => setState(() => _filterVehicle = null)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isAdmin && !_hasActiveFilters) ...[
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    _MiniStat(label: 'Registros', value: '${filtered.length}'),
                    const SizedBox(width: AppSpacing.md),
                    _MiniStat(label: 'Litros', value: '${totalLiters.toStringAsFixed(0)}L'),
                    const SizedBox(width: AppSpacing.md),
                    _MiniStat(label: 'Total', value: '\$${totalAmount.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('${filtered.length} registro(s)', style: AppTextStyles.bodySmall),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: filtered.isEmpty
                  ? const InEmptyState(icon: Icons.search_off_rounded, title: 'Sin resultados', subtitle: 'Intenta con otros filtros')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _ExpenseCard(expense: filtered[i]),
                      ),
                    ),
            ),
          ],
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
            Expanded(child: Text('Historial', style: AppTextStyles.heading2)),
            if (AuthService.isAdmin || AuthService.isAdministrative)
              GestureDetector(
                onTap: () => setState(() { _filterStatus = 'Pendiente'; }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pending_actions_rounded, size: 16, color: AppColors.warning),
                      const SizedBox(width: AppSpacing.xs),
                      Text('Pendientes', style: AppTextStyles.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  const _MiniStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w700)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final MockExpense expense;
  const _ExpenseCard({required this.expense});

  String _initials(String name) => name.split(' ').take(2).map((e) => e[0]).join();

  @override
  Widget build(BuildContext context) {
    return InCard(
      onTap: () => Navigator.pushNamed(context, '/expense-detail', arguments: expense),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(_initials(expense.operator.name), style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700, fontSize: 14))),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${expense.vehicle.plate} • ${expense.operator.name}', style: AppTextStyles.subtitle2),
                    const SizedBox(height: AppSpacing.xxs),
                    Text('${expense.date} • ${expense.fuelType.label}', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${expense.total.toStringAsFixed(2)}', style: AppTextStyles.subtitle2),
                  const SizedBox(height: AppSpacing.xxs),
                  InBadge(label: expense.status, variant: expense.status == 'Aprobado' ? InBadgeVariant.approved : expense.status == 'Pendiente' ? InBadgeVariant.pending : InBadgeVariant.rejected),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _InfoChip(icon: Icons.business_rounded, text: expense.project.name),
              const SizedBox(width: AppSpacing.sm),
              _InfoChip(icon: Icons.local_gas_station_rounded, text: '${expense.liters}L'),
              if (expense.hasTicket) ...[
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.image_rounded, size: 14, color: AppColors.textSecondary),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon; final String text;
  const _InfoChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(text, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label; final IconData? icon; final bool isActive; final bool removable; final VoidCallback onTap;
  const _FilterChip({required this.label, this.icon, this.isActive = false, this.removable = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon!, size: 16, color: isActive ? AppColors.primary : AppColors.textSecondary), const SizedBox(width: AppSpacing.xs)],
            Text(label, style: AppTextStyles.caption.copyWith(color: isActive ? AppColors.primary : AppColors.textSecondary, fontWeight: FontWeight.w600)),
            if (removable) ...[const SizedBox(width: AppSpacing.xs), const Icon(Icons.close_rounded, size: 14, color: AppColors.primary)],
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final String? selectedProject; final String? selectedVehicle; final String? selectedStatus; final String? selectedWeek;
  final List<String> weeks;
  final void Function(String?, String?, String?, String?) onApply;
  final VoidCallback onClear;
  const _FilterSheet({this.selectedProject, this.selectedVehicle, this.selectedStatus, this.selectedWeek, required this.weeks, required this.onApply, required this.onClear});
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? _project; String? _vehicle; String? _status; String? _week;

  @override
  void initState() { super.initState(); _project = widget.selectedProject; _vehicle = widget.selectedVehicle; _status = widget.selectedStatus; _week = widget.selectedWeek; }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtros', style: AppTextStyles.heading1),
                GestureDetector(onTap: widget.onClear, child: Text('Limpiar', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary))),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Semana', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.xs),
            _buildChips(widget.weeks.map((w) => _ChipData(id: w, label: w)).toList(), _week, (id) => setState(() => _week = id)),
            const SizedBox(height: AppSpacing.lg),
            Text('Estado', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.xs),
            _buildChips([_ChipData(id: 'Aprobado', label: 'Aprobado'), _ChipData(id: 'Pendiente', label: 'Pendiente'), _ChipData(id: 'Rechazado', label: 'Rechazado')], _status, (id) => setState(() => _status = id)),
            const SizedBox(height: AppSpacing.lg),
            Text('Obra', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.xs),
            _buildChips(MockData.projects.map((p) => _ChipData(id: p.id, label: p.name)).toList(), _project, (id) => setState(() => _project = id)),
            const SizedBox(height: AppSpacing.lg),
            Text('Vehículo', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.xs),
            _buildChips(MockData.vehicles.map((v) => _ChipData(id: v.id, label: v.plate)).toList(), _vehicle, (id) => setState(() => _vehicle = id)),
            const SizedBox(height: AppSpacing.xxl),
            InButton(label: 'Aplicar filtros', onPressed: () => widget.onApply(_project, _vehicle, _status, _week)),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildChips(List<_ChipData> chips, String? selected, ValueChanged<String> onSelect) {
    return Wrap(
      spacing: AppSpacing.sm, runSpacing: AppSpacing.sm,
      children: chips.map((c) {
        final isSel = selected == c.id;
        return GestureDetector(
          onTap: () => onSelect(c.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSel ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
            ),
            child: Text(c.label, style: AppTextStyles.bodySmall.copyWith(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ),
        );
      }).toList(),
    );
  }
}

class _ChipData {
  final String id; final String label;
  const _ChipData({required this.id, required this.label});
}
