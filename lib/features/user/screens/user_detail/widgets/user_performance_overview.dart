import 'package:dashboard/features/user/models/user_performance_matrics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/theme/widget_themes/text_theme.dart';
import '../../../../reports/controller/quiz_score_controller.dart';
import '../../../controller/user_detail_controller.dart';
import '../../../models/user_models.dart';

class UserPerformanceOverview extends StatelessWidget {
  final UserModel user;

  const UserPerformanceOverview({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final scoreController = Get.find<QuizScoreController>();
    final userDetailController = Get.find<UserDetailController>();

    return Obx(() {
      if (scoreController.isLoading.value) {
        return const TLoaderAnimation();
      }

      final scores = scoreController.filteredItems;
      final metrics = userDetailController.calculatePerformanceMetrics(scores);

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Performance Overview',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRadialGauge(
                    'Overall Progress', metrics.overallScore, TColors.primary),
                _buildRadialGauge(
                    'Accuracy Rate', metrics.accuracy, TColors.success),
                _buildRadialGauge(
                    'Incorrect Rate', metrics.incorrectRate, TColors.error),
                _buildRadialGauge(
                    'Skipped Rate', metrics.skippedRate, TColors.warning),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwSections),
            _buildProgressSummary(metrics),
            SizedBox(height: TSizes.spaceBtwSections / 2),
          ],
        ),
      );
    });
  }

  Widget _buildRadialGauge(String title, double value, Color color) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TColors.lightGrey,
            ),
          ),
          Transform.rotate(
            angle: -1.5708,
            child: SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: value / 100,
                backgroundColor: TColors.lightGrey,
                color: color,
                strokeWidth: 12,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              SizedBox(height: 2),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: TColors.darkGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSummary(PerformanceMetrics metrics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Progress Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
          SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Questions',
                  '${metrics.totalQuizzes * 100}', TColors.primary),
              _buildSummaryItem(
                  'Correct Answers',
                  '${(metrics.totalQuizzes * 100 - metrics.totalIncorrectAnswers - metrics.totalSkippedQuestions)}',
                  TColors.success),
              _buildSummaryItem('Incorrect Answers',
                  '${metrics.totalIncorrectAnswers}', TColors.error),
              _buildSummaryItem('Skipped Questions',
                  '${metrics.totalSkippedQuestions}', TColors.warning),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TTextTheme.lightTextTheme.bodyLarge,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
