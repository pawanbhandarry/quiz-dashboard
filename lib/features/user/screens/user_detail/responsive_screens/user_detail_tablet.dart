import 'package:dashboard/features/user/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../reports/controller/quiz_score_controller.dart';
import '../../../../setting/models/admin_model.dart';
import '../../../controller/user_detail_controller.dart';
import '../table/data_table.dart';
import '../widgets/user_info.dart';
import '../widgets/user_table_header.dart';

class UserDetailTabletScreen extends StatelessWidget {
  const UserDetailTabletScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserDetailController());
    final scoreController = Get.put(QuizScoreController());
    controller.user.value = user;
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
                        const SizedBox(height: TSizes.spaceBtwSections),

                        // Shipping Address
                        // const ShippingAddress(),
                      ],
                    ),
                  ),
                ],
              ),
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
  }
}
