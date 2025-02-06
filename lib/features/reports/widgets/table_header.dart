import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/reports/controller/quiz_score_controller.dart';
import 'package:dashboard/features/reports/controller/reportController.dart';
import 'package:dashboard/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/device/device_utility.dart';

class ReportsTableHeader extends StatelessWidget {
  const ReportsTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizScoreController());
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select User',
                border: OutlineInputBorder(),
              ),
              items: controller.users
                  .map((user) => DropdownMenuItem(
                        value: user.id,
                        child: Text(user.fullName),
                      ))
                  .toList(),
              onChanged: (value) => controller.filterByUser(value!),
              value: controller.selectedUser.value.isNotEmpty
                  ? controller.selectedUser.value
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(
            () => DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(),
              ),
              items: controller.categories
                  .map((quiz) => DropdownMenuItem(
                        value: quiz.id,
                        child: Text(quiz.name),
                      ))
                  .toList(),
              onChanged: (value) => controller.filterByCategory(value!),
              value: controller.selectedCategory.value.isNotEmpty
                  ? controller.selectedCategory.value
                  : null,
            ),
          ),
        ),
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
            // final reportController = ReportController();
            // final reportFile =
            //     await reportController.generateStudentPerformanceReport(
            //   student: user,
            //   quizScores: controller.filteredItems,
            // );
          },
        ),
      ],
    );
  }
}
