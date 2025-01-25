import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../utils/constants/sizes.dart';

import '../table/data_table.dart';
import '../widgets/table_header.dart';

class QuizesMobileScreen extends StatelessWidget {
  const QuizesMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBreadcrumbsWithHeading(
                  heading: 'Quizes', breadcrumbItems: ['Quizes']),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Table Body
              Obx(() {
                if (controller.isLoading.value) return const TLoaderAnimation();
                return const TRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      QuizTableHeader(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      // Table
                      QuizTable(),
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
