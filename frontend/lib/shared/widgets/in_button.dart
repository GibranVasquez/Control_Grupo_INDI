import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';

enum InButtonVariant { primary, secondary, outline, danger, ghost }

class InButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final InButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final Widget? trailing;

  const InButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = InButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 52,
    this.icon,
    this.trailing,
  });

  bool get _disabled => isDisabled || isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: TextButton(
        onPressed: _disabled ? null : onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            side: colors.borderSide != null
                ? BorderSide(color: colors.borderSide!)
                : BorderSide.none,
          ),
          disabledBackgroundColor: colors.backgroundColor?.withValues(alpha: 0.5),
          disabledForegroundColor: colors.textColor?.withValues(alpha: 0.5),
          elevation: 0,
        ),
        child: _buildContent(colors),
      ),
    );
  }

  Widget _buildContent(_ButtonColors colors) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(colors.textColor ?? AppColors.textOnPrimary),
        ),
      );
    }

    final children = <Widget>[];
    if (icon != null) {
      children.add(Icon(icon, size: 20));
      children.add(const SizedBox(width: AppSpacing.sm));
    }
    children.add(Flexible(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: (variant == InButtonVariant.outline || variant == InButtonVariant.ghost)
            ? AppTextStyles.buttonSmall.copyWith(color: colors.textColor)
            : AppTextStyles.button.copyWith(color: colors.textColor),
        overflow: TextOverflow.ellipsis,
      ),
    ));
    if (trailing != null) {
      children.add(const SizedBox(width: AppSpacing.sm));
      children.add(trailing!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  _ButtonColors _getColors() {
    switch (variant) {
      case InButtonVariant.primary:
        return _ButtonColors(
          backgroundColor: AppColors.primary,
          textColor: AppColors.textOnPrimary,
        );
      case InButtonVariant.secondary:
        return _ButtonColors(
          backgroundColor: AppColors.secondary,
          textColor: AppColors.textOnDark,
        );
      case InButtonVariant.outline:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          textColor: AppColors.primary,
          borderSide: AppColors.primary,
        );
      case InButtonVariant.danger:
        return _ButtonColors(
          backgroundColor: AppColors.error,
          textColor: AppColors.textOnPrimary,
        );
      case InButtonVariant.ghost:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          textColor: AppColors.textSecondary,
        );
    }
  }
}

class _ButtonColors {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderSide;

  _ButtonColors({
    this.backgroundColor,
    this.textColor,
    this.borderSide,
  });
}
