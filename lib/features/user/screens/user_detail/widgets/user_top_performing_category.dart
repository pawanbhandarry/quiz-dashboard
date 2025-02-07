import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controller/user_detail_controller.dart';
import '../../../models/user_models.dart';
import '../../../../reports/controller/quiz_score_controller.dart';

class TopPerformingCategories extends StatelessWidget {
  final UserModel user;

  const TopPerformingCategories({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final scoreController = Get.find<QuizScoreController>();
    final userDetailController = Get.find<UserDetailController>();

    return Obx(() {
      if (scoreController.isLoading.value) {
        return const TLoaderAnimation();
      }
      final scores = scoreController.filteredItems;
      final categoryStats =
          userDetailController.calculateDetailedCategoryStats(scores);
      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Performing Categories',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.md),
            ...categoryStats.entries.map((entry) {
              final category = entry.key;
              final stats = entry.value;
              final passRate = (stats.passCount / stats.totalAttempts) * 100;

              return Container(
                margin: const EdgeInsets.only(bottom: TSizes.md),
                padding: const EdgeInsets.all(TSizes.sm),
                decoration: BoxDecoration(
                  border: Border.all(color: TColors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '${stats.totalAttempts} Attempts',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.sm),

                    // Performance Bar
                    Stack(
                      children: [
                        Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: TColors.lightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Container(
                          height: 16,
                          width: (200 * (stats.averageScore / 100)).toDouble(),
                          decoration: BoxDecoration(
                            color: _getPerformanceColor(stats.averageScore),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.sm),

                    // Detailed Stats Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBox(
                            context,
                            'Avg Score',
                            '${stats.averageScore.toStringAsFixed(1)}%',
                            TColors.primary),
                        _buildStatBox(
                            context,
                            'Highest Score',
                            '${stats.highestScore.toStringAsFixed(1)}%',
                            TColors.success),
                        _buildStatBox(
                            context,
                            'Lowest Score',
                            '${stats.lowestScore.toStringAsFixed(1)}%',
                            TColors.error),
                      ],
                    ),
                    const SizedBox(height: TSizes.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBox(context, 'Pass Rate',
                            '${passRate.toStringAsFixed(1)}%', TColors.primary),
                        _buildStatBox(
                            context,
                            'Passed/Total',
                            '${stats.passCount}/${stats.totalAttempts}',
                            TColors.textSecondary),
                        _buildStatBox(
                            context,
                            'Avg Time',
                            '${stats.averageTimeTaken.toStringAsFixed(0)}s',
                            TColors.textSecondary),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildStatBox(
      BuildContext context, String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: TSizes.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Color _getPerformanceColor(double value) {
    if (value >= 90) return TColors.success;
    if (value >= 80) return TColors.success;
    if (value >= 70) return TColors.warning;
    if (value >= 60) return TColors.secondary;
    return TColors.error;
  }
}
