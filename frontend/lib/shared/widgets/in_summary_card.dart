import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import 'in_card.dart';

class SummaryItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });
}

class InSummaryCard extends StatelessWidget {
  final String title;
  final List<SummaryItem> items;

  const InSummaryCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return InCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subtitle2),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(items.length, (i) {
            final item = items[i];
            final isLast = i == items.length - 1;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (item.color ?? AppColors.primary).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, size: 18, color: item.color ?? AppColors.primary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(item.label, style: AppTextStyles.bodyMedium),
                    ),
                    Text(
                      item.value,
                      style: AppTextStyles.subtitle2.copyWith(
                        color: item.color ?? AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (!isLast) const SizedBox(height: AppSpacing.md),
              ],
            );
          }),
        ],
      ),
    );
  }
}
