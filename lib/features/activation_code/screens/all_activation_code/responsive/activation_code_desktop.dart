import 'package:dashboard/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:dashboard/features/activation_code/controller/activation_code_controller.dart';
import 'package:dashboard/features/activation_code/screens/all_activation_code/table/data_table.dart';
import 'package:dashboard/features/activation_code/screens/all_activation_code/widget/table_header.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/quizes/screens/alll_quizes/table/data_table.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import 'package:dashboard/common/widgets/loaders/loader_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';

class ActivationCodeDesktopScreen extends StatelessWidget {
  const ActivationCodeDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivationCodeController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                  heading: 'Activation Codes',
                  breadcrumbItems: ['Activation Codes']),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table Body
              Obx(() {
                // Show Loader
                if (controller.isLoading.value) return const TLoaderAnimation();

                return const TRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      ActivationCodeTableHeader(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      // Table
                      ActivationCodeDataTable(),
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
