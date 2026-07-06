import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';

class InAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;
  final bool showLogo;
  final bool autoBack;

  const InAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.showBack = true,
    this.showLogo = false,
    this.autoBack = false,
  });

  bool _hasBack(BuildContext context) {
    if (autoBack) {
      final route = ModalRoute.of(context);
      return route?.settings.name != '/dashboard';
    }
    return showBack;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final hasBack = _hasBack(context);
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: AppColors.background,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              if (hasBack)
                GestureDetector(
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
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
              if (hasBack) const SizedBox(width: AppSpacing.md),
              if (showLogo)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Image.asset('assets/logo_indi_azul.png', height: 28),
                ),
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(child: Text(title, style: AppTextStyles.heading2)),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
