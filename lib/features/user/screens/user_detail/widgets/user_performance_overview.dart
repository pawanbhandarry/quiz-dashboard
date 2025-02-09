import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../reports/controller/quiz_score_controller.dart';
import '../../../controller/user_detail_controller.dart';
import '../../../models/user_models.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

      return Card(
        elevation: 0,
        color: TColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    Icon(Icons.analytics_outlined,
                        color: Colors.white, size: 30),
                    const SizedBox(width: TSizes.sm),
                    Text(
                      'Performance Overview',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TSiteTemplate(
                useLayout: false,
                mobile: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAnimatedRadialGauge('Overall Progress',
                            metrics.overallScore, TColors.primary),
                        _buildAnimatedRadialGauge(
                            'Accuracy Rate', metrics.accuracy, TColors.success),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAnimatedRadialGauge('Incorrect Rate',
                            metrics.incorrectRate, TColors.error),
                        _buildAnimatedRadialGauge('Skipped Rate',
                            metrics.skippedRate, TColors.warning),
                      ],
                    ),
                  ],
                ),
                desktop: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAnimatedRadialGauge('Overall Progress',
                        metrics.overallScore, TColors.primary),
                    _buildAnimatedRadialGauge(
                        'Accuracy Rate', metrics.accuracy, TColors.success),
                    _buildAnimatedRadialGauge(
                        'Incorrect Rate', metrics.incorrectRate, TColors.error),
                    _buildAnimatedRadialGauge(
                        'Skipped Rate', metrics.skippedRate, TColors.warning),
                  ],
                ),
                tablet: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAnimatedRadialGauge('Overall Progress',
                            metrics.overallScore, TColors.primary),
                        _buildAnimatedRadialGauge(
                            'Accuracy Rate', metrics.accuracy, TColors.success),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAnimatedRadialGauge('Incorrect Rate',
                            metrics.incorrectRate, TColors.error),
                        _buildAnimatedRadialGauge('Skipped Rate',
                            metrics.skippedRate, TColors.warning),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Progress Summary
              ExpansionTile(
                initiallyExpanded: true,
                leading:
                    Icon(Icons.assessment_outlined, color: TColors.primary),
                title: Text(
                  'Detailed Progress Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: TColors.primary,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(TSizes.md),
                    // child: _buildAnimatedSummaryGrid(metrics),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAnimatedRadialGauge(String title, double value, Color color) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: TSizes.sm),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1500),
        tween: Tween<double>(begin: 0, end: value),
        builder: (context, animatedValue, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.1),
                    ),
                  ),
                  Transform.rotate(
                    angle: -1.5708,
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: animatedValue / 100,
                        backgroundColor: Colors.white,
                        color: color,
                        strokeWidth: 12,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${animatedValue.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: TSizes.md),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedSummaryGrid(metrics) {
    return TSiteTemplate(
      mobile: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAnimatedSummaryItem('Total Questions',
                  '${metrics.totalQuizzes * 100}', TColors.primary, Icons.quiz),
              _buildAnimatedSummaryItem(
                  'Correct Answers',
                  '${metrics.totalQuizzes * 100 - metrics.totalIncorrectAnswers - metrics.totalSkippedQuestions}',
                  TColors.success,
                  Icons.check_circle),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAnimatedSummaryItem(
                  'Incorrect Answers',
                  '${metrics.totalIncorrectAnswers}',
                  TColors.error,
                  Icons.cancel),
              _buildAnimatedSummaryItem(
                  'Skipped Questions',
                  '${metrics.totalSkippedQuestions}',
                  TColors.warning,
                  Icons.skip_next),
            ],
          ),
        ],
      ),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildAnimatedSummaryItem('Total Questions',
                '${metrics.totalQuizzes * 100}', TColors.primary, Icons.quiz),
          ),
          SizedBox(width: TSizes.sm),
          Expanded(
            child: _buildAnimatedSummaryItem(
                'Correct Answers',
                '${metrics.totalQuizzes * 100 - metrics.totalIncorrectAnswers - metrics.totalSkippedQuestions}',
                TColors.success,
                Icons.check_circle),
          ),
          SizedBox(width: TSizes.sm),
          Expanded(
            child: _buildAnimatedSummaryItem(
                'Incorrect Answers',
                '${metrics.totalIncorrectAnswers}',
                TColors.error,
                Icons.cancel),
          ),
          SizedBox(width: TSizes.sm),
          Expanded(
            child: _buildAnimatedSummaryItem(
                'Skipped Questions',
                '${metrics.totalSkippedQuestions}',
                TColors.warning,
                Icons.skip_next),
          ),
        ],
      ),
      tablet: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildAnimatedSummaryItem(
                    'Total Questions',
                    '${metrics.totalQuizzes * 100}',
                    TColors.primary,
                    Icons.quiz),
              ),
              Expanded(
                child: _buildAnimatedSummaryItem(
                    'Correct Answers',
                    '${metrics.totalQuizzes * 100 - metrics.totalIncorrectAnswers - metrics.totalSkippedQuestions}',
                    TColors.success,
                    Icons.check_circle),
              ),
            ],
          ),
          const SizedBox(height: TSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildAnimatedSummaryItem(
                    'Incorrect Answers',
                    '${metrics.totalIncorrectAnswers}',
                    TColors.error,
                    Icons.cancel),
              ),
              Expanded(
                child: _buildAnimatedSummaryItem(
                    'Skipped Questions',
                    '${metrics.totalSkippedQuestions}',
                    TColors.warning,
                    Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSummaryItem(
      String label, String value, Color color, IconData icon) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1500),
        tween: Tween<double>(
          begin: 0,
          end: double.tryParse(value) ?? 0,
        ),
        builder: (context, animatedValue, child) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: TSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      animatedValue.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
