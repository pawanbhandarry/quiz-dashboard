import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controller/user_detail_controller.dart';
import '../../../models/user_models.dart';
import '../../../../reports/controller/quiz_score_controller.dart';

class DetailedCategoryStats extends StatelessWidget {
  final UserModel user;

  const DetailedCategoryStats({super.key, required this.user});

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

      return Card(
        elevation: 0,
        color: TColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: TSizes.md, horizontal: TSizes.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TColors.primary, TColors.primary.withOpacity(0.7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 30),
                    const SizedBox(width: TSizes.sm),
                    Text(
                      'Top Performing Categories',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.lg),

              // Category Cards
              ...categoryStats.entries.map((entry) {
                final category = entry.key;
                final stats = entry.value;
                final passRate = (stats.passCount / stats.totalAttempts) * 100;

                return Container(
                  margin: const EdgeInsets.only(bottom: TSizes.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(TSizes.sm),
                          decoration: BoxDecoration(
                            color: TColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.category, color: TColors.primary),
                        ),
                        const SizedBox(width: TSizes.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${stats.totalAttempts} Attempts',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: TColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: TSizes.sm, vertical: TSizes.xs),
                          decoration: BoxDecoration(
                            color: _getPerformanceColor(stats.averageScore)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${stats.averageScore.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: _getPerformanceColor(stats.averageScore),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(TSizes.md),
                        child: Column(
                          children: [
                            // Performance Bar with Animation
                            TweenAnimationBuilder(
                              duration: Duration(milliseconds: 1000),
                              tween: Tween<double>(
                                  begin: 0, end: stats.averageScore / 100),
                              builder: (context, double value, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Performance',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge),
                                        Text(
                                            '${(value * 100).toStringAsFixed(1)}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge),
                                      ],
                                    ),
                                    const SizedBox(height: TSizes.xs),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: TColors.lightGrey,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        Container(
                                          height: 12,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7 *
                                              value,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                _getPerformanceColor(
                                                    stats.averageScore),
                                                _getPerformanceColor(
                                                        stats.averageScore)
                                                    .withOpacity(0.7),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: TSizes.md),

                            // Stats Grid
                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              childAspectRatio: 3.2, // Made more compact
                              mainAxisSpacing: TSizes.md, // Reduced spacing
                              crossAxisSpacing: TSizes.md,
                              children: [
                                _buildStatCard(
                                  context,
                                  'Highest Score',
                                  '${stats.highestScore.toStringAsFixed(1)}%',
                                  TColors.success,
                                  Icons.emoji_events,
                                  isRatio: false,
                                ),
                                _buildStatCard(
                                  context,
                                  'Lowest Score',
                                  '${stats.lowestScore.toStringAsFixed(1)}%',
                                  TColors.error,
                                  Icons.trending_down,
                                  isRatio: false,
                                ),
                                _buildStatCard(
                                  context,
                                  'Avg Score',
                                  '${stats.averageScore.toStringAsFixed(1)}%',
                                  TColors.primary,
                                  Icons.analytics,
                                  isRatio: false,
                                ),
                                _buildStatCard(
                                  context,
                                  'Pass Rate',
                                  '${passRate.toStringAsFixed(1)}%',
                                  TColors.success,
                                  Icons.check_circle,
                                  isRatio: false,
                                ),
                                _buildStatCard(
                                  context,
                                  'Passed/Total',
                                  '${stats.passCount}/${stats.totalAttempts}',
                                  TColors.textSecondary,
                                  Icons.bar_chart,
                                  isRatio: true,
                                ),
                                _buildStatCard(
                                  context,
                                  'Avg Time',
                                  '${stats.averageTimeTaken.toStringAsFixed(0)}s',
                                  TColors.warning,
                                  Icons.timer,
                                  isRatio: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatCard(BuildContext context, String label, String value,
      Color color, IconData icon,
      {bool isRatio = false}) {
    return Container(
      padding: const EdgeInsets.all(TSizes.xs),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon (Watermark)
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              icon,
              size: 60,
              color: color.withOpacity(0.1),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(TSizes.xs),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: TSizes.sm),

              // Value with Animation
              Flexible(
                child: isRatio
                    ? Text(
                        value, // Direct display for ratio
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1500),
                        tween: Tween<double>(
                          begin: 0,
                          end: double.tryParse(
                                  value.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                              0,
                        ),
                        builder: (context, animatedValue, child) {
                          return Text(
                            animatedValue.toStringAsFixed(1) +
                                (label.toLowerCase().contains('time')
                                    ? 'mins'
                                    : '%'),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
              ),

              const SizedBox(height: TSizes.xs),

              // Label
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
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
