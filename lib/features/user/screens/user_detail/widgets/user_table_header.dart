import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/reports/controller/quiz_score_controller.dart';
import 'package:dashboard/features/reports/controller/reportController.dart';
import 'package:dashboard/features/user/models/user_models.dart';
import 'package:dashboard/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/popups/loaders.dart';

class UserScoreTableHeader extends StatelessWidget {
  final UserModel user;
  const UserScoreTableHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizScoreController());
    controller.filterByUser(user.id!);
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(),
              ),
              items: controller.categories
                  .map((categories) => DropdownMenuItem(
                        value: categories.id,
                        child: Text(categories.name),
                      ))
                  .toList(),
              onChanged: (value) => controller.filterByCategory(value!),
              value: controller.selectedCategory.value.isNotEmpty
                  ? controller.selectedCategory.value
                  : null,
            ),
          ),
        ),
        // const SizedBox(width: 10),
        // Expanded(
        //   flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
        //   child: TextFormField(
        //     controller: controller.searchTextController,
        //     onChanged: (query) => controller.searchQuery(query),
        //     decoration: const InputDecoration(
        //         hintText: 'Search Quizes',
        //         prefixIcon: Icon(Iconsax.search_normal)),
        //   ),
        // ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(
            () => DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter by Quiz',
                border: OutlineInputBorder(),
              ),
              items: controller.quizzes
                  .map((quiz) => DropdownMenuItem(
                        value: quiz.id,
                        child: Text(quiz.title),
                      ))
                  .toList(),
              onChanged: (value) => controller.filterByQuiz(value!),
              value: controller.selectedQuiz.value.isNotEmpty
                  ? controller.selectedQuiz.value
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: const Text('Export PDF'),
          ),
          onPressed: () async {
            try {
              if (controller.filteredItems.isEmpty) {
                TLoaders.errorSnackBar(
                    title: 'Data Unvailable', message: 'No data to export');
              } else {
                await ReportController().generateStudentPerformanceReport(
                  student: user,
                  quizScores: controller.filteredItems,
                );
              }
            } catch (e) {
              TLoaders.errorSnackBar(
                  title: 'Error', message: 'Failed to generate report');
            }
          },
        ),
      ],
    );
  }
}
