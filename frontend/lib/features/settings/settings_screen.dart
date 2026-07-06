import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/services/theme_service.dart';
import '../../shared/widgets/in_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    ThemeService.modeNotifier.addListener(_onThemeChange);
  }

  @override
  void dispose() {
    ThemeService.modeNotifier.removeListener(_onThemeChange);
    super.dispose();
  }

  void _onThemeChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.mode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildSection('Apariencia', [
                      _SettingTile(
                        icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        label: 'Tema oscuro',
                        subtitle: isDark ? 'Activo' : 'Inactivo',
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) => ThemeService.toggle(),
                          activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                          activeThumbColor: AppColors.primary,
                        ),
                      ),
                    ]),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSection('Notificaciones', [
                      _SettingTile(
                        icon: Icons.notifications_outlined,
                        label: 'Notificaciones push',
                        trailing: Switch(value: true, onChanged: (_) {}, activeThumbColor: AppColors.primary, activeTrackColor: AppColors.primary.withValues(alpha: 0.5)),
                      ),
                      const Divider(height: 1, color: AppColors.borderLight),
                      _SettingTile(
                        icon: Icons.email_outlined,
                        label: 'Notificaciones por correo',
                        trailing: Switch(value: false, onChanged: (_) {}, activeThumbColor: AppColors.primary, activeTrackColor: AppColors.primary.withValues(alpha: 0.5)),
                      ),
                    ]),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSection('Información', [
                      _SettingTile(icon: Icons.info_outline_rounded, label: 'Versión', subtitle: '1.0.0'),
                      const Divider(height: 1, color: AppColors.borderLight),
                      _SettingTile(icon: Icons.storage_rounded, label: 'Sistema', subtitle: 'v1.0.0+build.1'),
                      const Divider(height: 1, color: AppColors.borderLight),
                      _SettingTile(icon: Icons.palette_outlined, label: 'Modo', subtitle: isDark ? 'Oscuro' : 'Claro'),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final canPop = ModalRoute.of(context)?.settings.name != '/dashboard';
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: AppColors.background,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        child: Row(
          children: [
            if (canPop) ...[
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
            Expanded(child: Text('Configuración', style: AppTextStyles.heading2)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(title, style: AppTextStyles.subtitle2),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;

  const _SettingTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodyMedium),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
