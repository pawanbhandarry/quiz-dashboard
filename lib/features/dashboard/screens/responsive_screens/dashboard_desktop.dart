import 'package:dashboard/common/widgets/texts/page_heading.dart';
import 'package:dashboard/features/dashboard/screens/table/data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/dashboard_controller.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/performance_chart.dart';
import '../widgets/recent_quiz_attempts.dart';
import '../widgets/top_performing_quiz.dart';
import '../widgets/top_users.dart';
import '../widgets/user_engagement.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TPageHeading(heading: 'Dashboard'),
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.user,
                        headingIconColor: Colors.blue,
                        headingIconBgColor: Colors.blue.withOpacity(0.1),
                        stats: 25,
                        context: context,
                        title: 'Active Users',
                        subTitle: '${controller.totalActiveUsers.value}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.book,
                        headingIconColor: Colors.green,
                        headingIconBgColor: Colors.green.withOpacity(0.1),
                        stats: 15,
                        context: context,
                        title: 'Total Quizes',
                        subTitle: (controller.totalQuizzes.value).toString(),
                        icon: Iconsax.arrow_down,
                        color: TColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.category,
                        headingIconColor: Colors.deepPurple,
                        headingIconBgColor: Colors.deepPurple.withOpacity(0.1),
                        stats: 44,
                        context: context,
                        title: 'Categories',
                        subTitle: controller.totalCategories.value.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.activity,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withOpacity(0.1),
                        context: context,
                        title: 'Total Attempts',
                        subTitle:
                            controller.recentQuizAttempts.length.toString(),
                        stats: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Graphs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Weekly Sales Graph
                        const PerformanceChartWidget(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Orders
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TCircularIcon(
                                    icon: Iconsax.box,
                                    backgroundColor:
                                        Colors.deepPurple.withOpacity(0.1),
                                    color: Colors.deepPurple,
                                    size: TSizes.md,
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  Text('Recent Attempts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                ],
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              const DashboardQuizAttempt(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),
                  Expanded(
                    child: TRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TopPerformingQuizzes(),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          const LeaderboardWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
