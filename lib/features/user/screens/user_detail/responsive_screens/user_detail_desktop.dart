import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/setting/models/admin_model.dart';
import 'package:dashboard/features/user/controller/user_detail_controller.dart';
import 'package:dashboard/features/user/screens/all_users/widgets/table_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../reports/controller/quiz_score_controller.dart';
import '../../../models/user_models.dart';
import '../table/data_table.dart';
import '../widgets/user_info.dart';
import '../widgets/user_performance_overview.dart';
import '../widgets/user_table_header.dart';
import '../widgets/user_top_performing_category.dart';

class UserDetailDesktopScreen extends StatelessWidget {
  const UserDetailDesktopScreen({super.key, required this.user});

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
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        UserInfo(
                          user: user,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    flex: 2,
                    child: UserPerformanceOverview(user: user),
                  ),
                ],
              ),

              TopPerformingCategories(user: user),
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
