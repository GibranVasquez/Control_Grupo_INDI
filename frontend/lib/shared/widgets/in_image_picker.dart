import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';

class InImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  const InImagePicker({
    super.key,
    this.imagePath,
    required this.onPick,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Foto del ticket', style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: imagePath != null ? AppColors.primary : AppColors.border,
                width: imagePath != null ? 1.5 : 1,
              ),
            ),
            child: imagePath != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.cardRadius - 1),
                        child: Image.network(
                          imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildPlaceholder(),
                        ),
                      ),
                      if (onRemove != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : _buildPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 36,
          color: AppColors.textHint,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Toca para tomar foto',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}
