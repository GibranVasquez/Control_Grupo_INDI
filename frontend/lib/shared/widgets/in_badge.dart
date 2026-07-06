import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';

enum InBadgeVariant { pending, approved, rejected, draft, info, warning, success }

class InBadge extends StatelessWidget {
  final String label;
  final InBadgeVariant variant;

  const InBadge({
    super.key,
    required this.label,
    this.variant = InBadgeVariant.info,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.badgeRadius),
        border: Border.all(color: colors.borderColor, width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: colors.textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _BadgeColors _getColors() {
    switch (variant) {
      case InBadgeVariant.pending:
        return _BadgeColors(
          backgroundColor: AppColors.warningBg,
          textColor: AppColors.warning,
          borderColor: AppColors.warning.withValues(alpha: 0.3),
        );
      case InBadgeVariant.approved:
        return _BadgeColors(
          backgroundColor: AppColors.successBg,
          textColor: AppColors.success,
          borderColor: AppColors.success.withValues(alpha: 0.3),
        );
      case InBadgeVariant.rejected:
        return _BadgeColors(
          backgroundColor: AppColors.errorBg,
          textColor: AppColors.error,
          borderColor: AppColors.error.withValues(alpha: 0.3),
        );
      case InBadgeVariant.draft:
        return _BadgeColors(
          backgroundColor: AppColors.infoBg,
          textColor: AppColors.info,
          borderColor: AppColors.info.withValues(alpha: 0.3),
        );
      case InBadgeVariant.info:
        return _BadgeColors(
          backgroundColor: AppColors.infoBg,
          textColor: AppColors.info,
          borderColor: AppColors.info.withValues(alpha: 0.3),
        );
      case InBadgeVariant.warning:
        return _BadgeColors(
          backgroundColor: AppColors.warningBg,
          textColor: AppColors.warning,
          borderColor: AppColors.warning.withValues(alpha: 0.3),
        );
      case InBadgeVariant.success:
        return _BadgeColors(
          backgroundColor: AppColors.successBg,
          textColor: AppColors.success,
          borderColor: AppColors.success.withValues(alpha: 0.3),
        );
    }
  }
}

class _BadgeColors {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  _BadgeColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}
