import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/in_button.dart';
import '../../shared/widgets/in_text_field.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_badge.dart';
import '../../models/mock_data.dart';

class RegisterExpenseScreen extends StatefulWidget {
  const RegisterExpenseScreen({super.key});

  @override
  State<RegisterExpenseScreen> createState() => _RegisterExpenseScreenState();
}

class _RegisterExpenseScreenState extends State<RegisterExpenseScreen> {
  final _odometerController = TextEditingController();
  final _litersController = TextEditingController();
  final _notesController = TextEditingController();
  bool _hasTicketPhoto = false;
  double _total = 0;
  double _costPerLiter = 24.0;
  DateTime _selectedDate = DateTime.now();
  FuelType _fuelType = FuelType.diesel;
  bool _saving = false;

  String get _dateStr =>
      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';

  String get _weekStr {
    final startOfYear = DateTime(_selectedDate.year, 1, 1);
    final diff = _selectedDate.difference(startOfYear).inDays;
    final week = ((diff + startOfYear.weekday - 1) / 7).ceil() + 1;
    return 'Sem $week';
  }

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user?.role == UserRole.operator) {
      final v = user!.assignedVehicle;
      if (v != null) {
        _fuelType = v.fuelType;
        _costPerLiter = v.fuelType == FuelType.magna ? 24.50 :
                        v.fuelType == FuelType.diesel ? 22.80 : 26.00;
        _odometerController.text = v.lastOdometer.toStringAsFixed(0);
      }
    }
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _litersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final liters = double.tryParse(_litersController.text) ?? 0;
    setState(() => _total = liters * _costPerLiter);
  }

  void _quickLiters(double liters) {
    _litersController.text = liters.toStringAsFixed(1);
    _calculateTotal();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    final liters = double.tryParse(_litersController.text) ?? 0;
    if (liters <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ingresa los litros cargados'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    final user = AuthService.currentUser!;
    final vehicle = user.assignedVehicle ?? MockData.vehicles.first;
    final project = MockData.projects.first;
    final nextId = 'G-${(MockData.allExpenses.length + 1).toString().padLeft(3, '0')}';

    final expense = MockExpense(
      id: nextId,
      date: _dateStr,
      week: _weekStr,
      project: project,
      vehicle: vehicle,
      operator: user,
      odometer: double.tryParse(_odometerController.text) ?? 0,
      liters: liters,
      fuelType: _fuelType,
      costPerLiter: _costPerLiter,
      total: _total,
      folio: 'T-${DateTime.now().year}-${(MockData.allExpenses.length + 1).toString().padLeft(4, '0')}',
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      status: 'Pendiente',
      hasTicket: _hasTicketPhoto,
    );

    MockData.addExpense(expense);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Carga registrada · $nextId'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Ver',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/expense-detail', arguments: expense),
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final vehicle = user?.assignedVehicle;
    final isOperator = user?.role == UserRole.operator;
    final project = MockData.projects.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.huge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isOperator && vehicle != null) ...[
                      _buildPreFilledInfo(vehicle, project, user!),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    _buildDateSection(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildOdometerSection(vehicle),
                    const SizedBox(height: AppSpacing.lg),
                    if (!isOperator) ...[
                      _buildFuelTypeSelector(),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    _buildLitersSection(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildTotalSection(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildPhotoSection(),
                    const SizedBox(height: AppSpacing.lg),
                    InTextField(
                      label: 'Observaciones',
                      hint: 'Notas adicionales (opcional)',
                      controller: _notesController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    InButton(
                      label: 'Guardar Carga',
                      onPressed: _saving ? null : _save,
                      icon: Icons.save_rounded,
                    ),
                  ],
                ),
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
                child: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 20),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text('Registrar Carga', style: AppTextStyles.heading2)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreFilledInfo(MockVehicle v, MockProject p, MockUser u) {
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(v.category == VehicleCategory.machinery ? Icons.precision_manufacturing_rounded : Icons.local_shipping_rounded,
                  size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('${v.plate} · ${v.brand} ${v.model}', style: AppTextStyles.subtitle2),
              ),
              InBadge(label: v.fuelType.label, variant: InBadgeVariant.info),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.business_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(p.name, style: AppTextStyles.bodySmall),
              const Spacer(),
              const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(u.name, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fecha', style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _DateChip(label: 'Hoy', isSelected: _selectedDate.day == today.day && _selectedDate.month == today.month, onTap: () => setState(() => _selectedDate = today)),
            const SizedBox(width: AppSpacing.sm),
            _DateChip(label: 'Ayer', isSelected: _selectedDate.day == yesterday.day && _selectedDate.month == yesterday.month, onTap: () => setState(() => _selectedDate = yesterday)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(_dateStr, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOdometerSection(MockVehicle? v) {
    return InTextField(
      label: v?.category == VehicleCategory.machinery ? 'Horómetro actual' : 'Kilometraje actual',
      hint: '0',
      controller: _odometerController,
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.speed_rounded, color: AppColors.textSecondary, size: 20),
    );
  }

  Widget _buildFuelTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo de combustible', style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: FuelType.values.map((ft) {
            final isSelected = _fuelType == ft;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: ft == FuelType.values.last ? 0 : AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _fuelType = ft;
                    _costPerLiter = ft == FuelType.magna ? 24.50 :
                                    ft == FuelType.diesel ? 22.80 : 26.00;
                    _calculateTotal();
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(
                      ft.label,
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLitersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Litros cargados', style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.sm),
        InTextField(
          label: 'Litros',
          hint: '0.0',
          controller: _litersController,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.water_drop_outlined, color: AppColors.textSecondary, size: 20),
          onChanged: (_) => _calculateTotal(),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _QuickLitersButton(label: '¼ tanque', value: 18.75, onTap: _quickLiters),
            const SizedBox(width: AppSpacing.sm),
            _QuickLitersButton(label: '½ tanque', value: 37.5, onTap: _quickLiters),
            const SizedBox(width: AppSpacing.sm),
            _QuickLitersButton(label: '¾ tanque', value: 56.25, onTap: _quickLiters),
            const SizedBox(width: AppSpacing.sm),
            _QuickLitersButton(label: 'Lleno', value: 75.0, onTap: _quickLiters),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    final user = AuthService.currentUser;
    final v = user?.assignedVehicle;
    final vehicleLabel = v == null ? '' : ' x \$${_costPerLiter.toStringAsFixed(2)}/L';
    return InCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Costo por litro: \$${_costPerLiter.toStringAsFixed(2)}', style: AppTextStyles.bodySmall),
                const SizedBox(height: AppSpacing.xxs),
                Text('Importe total', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${_total.toStringAsFixed(2)}',
                style: AppTextStyles.amountMedium.copyWith(color: AppColors.primary),
              ),
              if (_total > 0)
                Text(
                  '${_litersController.text}L$vehicleLabel',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: () => setState(() => _hasTicketPhoto = !_hasTicketPhoto),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _hasTicketPhoto ? AppColors.successBg : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: _hasTicketPhoto ? AppColors.success.withValues(alpha: 0.3) : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _hasTicketPhoto ? Icons.image_rounded : Icons.camera_alt_outlined,
              color: _hasTicketPhoto ? AppColors.success : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              _hasTicketPhoto ? 'Foto del ticket tomada' : 'Tomar foto del ticket',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _hasTicketPhoto ? AppColors.success : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_hasTicketPhoto) ...[
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _DateChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _QuickLitersButton extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onTap;

  const _QuickLitersButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onTap(value),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        ),
        child: Column(
          children: [
            Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
            Text('${value.toStringAsFixed(0)}L', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
