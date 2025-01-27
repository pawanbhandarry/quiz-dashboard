import 'package:dashboard/features/reports/table/score_table.dart';
import 'package:dashboard/features/reports/widgets/table_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../common/widgets/containers/rounded_container.dart';
import '../../../common/widgets/loaders/loader_animation.dart';
import '../../../utils/constants/sizes.dart';
import '../controller/quiz_score_controller.dart';

class ReportsDesktopScreen extends StatelessWidget {
  const ReportsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScoreController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                  heading: 'Quizes', breadcrumbItems: ['Quizes']),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table Body
              Obx(() {
                // Show Loader
                if (controller.isLoading.value) return const TLoaderAnimation();

                return const TRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      ReportsTableHeader(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      // Table
                      ScoreTable(),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
