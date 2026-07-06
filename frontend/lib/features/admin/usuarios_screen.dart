import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/in_card.dart';
import '../../shared/widgets/in_badge.dart';
import '../../shared/widgets/in_search_bar.dart';
import '../../shared/widgets/in_text_field.dart';
import '../../shared/widgets/in_dropdown.dart';
import '../../models/mock_data.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  String _query = '';

  List<MockUser> get _filtered => MockData.users.where((u) =>
    u.name.toLowerCase().contains(_query.toLowerCase()) ||
    u.roleLabel.toLowerCase().contains(_query.toLowerCase())
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
              child: InSearchBar(
                hint: 'Buscar usuario...',
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _UserCard(user: _filtered[i], onEdit: () => _showEditDialog(context, _filtered[i])),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
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
            Expanded(child: Text('Usuarios', style: AppTextStyles.heading2)),
            Text('${_filtered.length}', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String? selectedRole;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nuevo Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InTextField(label: 'Nombre', controller: nameCtrl),
              const SizedBox(height: AppSpacing.md),
              InTextField(label: 'Email', controller: emailCtrl),
              const SizedBox(height: AppSpacing.md),
              InTextField(label: 'Teléfono', controller: phoneCtrl),
              const SizedBox(height: AppSpacing.md),
              InDropdown(
                label: 'Rol',
                value: selectedRole,
                hint: 'Seleccionar rol',
                items: ['Operador', 'Administrativo', 'Administrador'].map((r) => DropdownMenuItem(
                  value: r,
                  child: Text(r),
                )).toList(),
                onChanged: (v) => selectedRole = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usuario ${nameCtrl.text} creado'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, MockUser user) {
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    final phoneCtrl = TextEditingController(text: user.phone);
    String? selectedRole = user.roleLabel;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Editar Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InTextField(label: 'Nombre', controller: nameCtrl),
              const SizedBox(height: AppSpacing.md),
              InTextField(label: 'Email', controller: emailCtrl),
              const SizedBox(height: AppSpacing.md),
              InTextField(label: 'Teléfono', controller: phoneCtrl),
              const SizedBox(height: AppSpacing.md),
              InDropdown(
                label: 'Rol',
                value: selectedRole,
                hint: 'Seleccionar rol',
                items: ['Operador', 'Administrativo', 'Administrador'].map((r) => DropdownMenuItem(
                  value: r,
                  child: Text(r),
                )).toList(),
                onChanged: (v) => selectedRole = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usuario ${user.name} actualizado'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final MockUser user;
  final VoidCallback onEdit;

  const _UserCard({required this.user, required this.onEdit});

  Color _roleColor() {
    switch (user.role) {
      case UserRole.admin:
        return AppColors.primary;
      case UserRole.administrative:
        return AppColors.info;
      case UserRole.operator:
        return AppColors.success;
    }
  }

  InBadgeVariant _badgeVariant() {
    switch (user.role) {
      case UserRole.admin:
        return InBadgeVariant.warning;
      case UserRole.administrative:
        return InBadgeVariant.info;
      case UserRole.operator:
        return InBadgeVariant.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _roleColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  user.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: AppTextStyles.subtitle1.copyWith(color: _roleColor()),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(user.email, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            InBadge(label: user.roleLabel, variant: _badgeVariant()),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
