import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../reports/controller/quiz_score_controller.dart';
import '../../../../setting/models/admin_model.dart';
import '../../../controller/user_detail_controller.dart';
import '../../../models/user_models.dart';
import '../table/data_table.dart';
import '../widgets/animated_radia_gauge.dart';
import '../widgets/summary_item.dart';
import '../widgets/user_info.dart';
import '../widgets/user_performance_overview.dart';
import '../widgets/user_table_header.dart';
import '../widgets/user_top_performing_category.dart';

class UserDetailMobileScreen extends StatelessWidget {
  const UserDetailMobileScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserDetailController());
    final scoreController = Get.put(QuizScoreController());
    final userDetailController = Get.find<UserDetailController>();
    controller.user.value = user;

    return Obx(() {
      if (scoreController.isLoading.value) {
        return const TLoaderAnimation();
      }

      final scores = scoreController.filteredItems;
      final metrics = userDetailController.calculatePerformanceMetrics(scores);
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumbs
                TBreadcrumbsWithHeading(
                    returnToPreviousScreen: true,
                    heading: user.fullName,
                    breadcrumbItems: const [TRoutes.users, 'Details']),
                const SizedBox(height: TSizes.spaceBtwSections),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Right Side Customer Information
                    Expanded(
                      child: Column(
                        children: [
                          // Customer Info
                          UserInfo(
                            user: user,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                TRoundedContainer(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: TSizes.md, horizontal: TSizes.lg),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TColors.primary,
                              TColors.primary.withOpacity(0.7)
                            ],
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
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedRadiaGauge(
                                  title: 'Overall Progress',
                                  value: metrics.overallScore,
                                  color: TColors.primary),
                              AnimatedRadiaGauge(
                                  title: 'Accuracy Rate',
                                  value: metrics.accuracy,
                                  color: TColors.success),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedRadiaGauge(
                                  title: 'Incorrect Rate',
                                  value: metrics.incorrectRate,
                                  color: TColors.error),
                              AnimatedRadiaGauge(
                                  title: 'Skipped Rate',
                                  value: metrics.skippedRate,
                                  color: TColors.warning),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Progress Summary
                      ExpansionTile(
                        initiallyExpanded: true,
                        leading: Icon(Icons.assessment_outlined,
                            color: TColors.primary),
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SummaryItem(
                                          label: 'Total Questions',
                                          value:
                                              '${metrics.totalQuizzes * 100}',
                                          color: TColors.primary,
                                          icon: Icons.quiz),
                                    ),
                                    SizedBox(width: TSizes.sm),
                                    Expanded(
                                      child: SummaryItem(
                                          label: 'Correct Answers',
                                          value:
                                              '${metrics.totalQuizzes * 100 - metrics.totalIncorrectAnswers - metrics.totalSkippedQuestions}',
                                          color: TColors.success,
                                          icon: Icons.check_circle),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: TSizes.spaceBtwSections / 2),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SummaryItem(
                                          label: 'Incorrect Answers',
                                          value:
                                              '${metrics.totalIncorrectAnswers}',
                                          color: TColors.error,
                                          icon: Icons.cancel),
                                    ),
                                    SizedBox(width: TSizes.sm),
                                    Expanded(
                                      child: SummaryItem(
                                          label: 'Skipped Questions',
                                          value:
                                              '${metrics.totalSkippedQuestions}',
                                          color: TColors.warning,
                                          icon: Icons.warning),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwSections),
                CategoriesPerformance(user: user),
                const SizedBox(height: TSizes.spaceBtwSections),
                const SizedBox(height: TSizes.spaceBtwSections),
                Obx(() {
                  if (scoreController.isLoading.value) {
                    return const TLoaderAnimation();
                  }

                  return TRoundedContainer(
                    child: Column(
                      children: [
                        // Table Header
                        UserScoreTableHeader(user: user),
                        SizedBox(height: TSizes.spaceBtwItems),
                        // Table
                        UserScoreTable(),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
