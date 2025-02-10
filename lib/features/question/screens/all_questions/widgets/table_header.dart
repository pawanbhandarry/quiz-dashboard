import 'package:dashboard/features/question/controllers/questions_controller.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/routes/routes.dart';
import 'package:dashboard/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../models/question_models.dart';

class QuestionsTableHeader extends StatelessWidget {
  const QuestionsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = QuestionController.instance;
    return Obx(() {
      final selectedCount =
          controller.selectedRows.where((selected) => selected).length;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          Expanded(
            flex: !TDeviceUtils.isDesktopScreen(context) ? 1 : 3,
            child: Row(
              children: [
                SizedBox(
                    width: 180,
                    child: ElevatedButton(
                        onPressed: () => Get.toNamed(TRoutes.addQuestion),
                        child: const Text('Add Question'))),
                const SizedBox(width: 20),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primaryBackground,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Get.toNamed(TRoutes.uploadQuestions),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.document,
                              color: TColors.textPrimary),
                          const SizedBox(width: 5),
                          const Text('Upload Question',
                              style: TextStyle(color: TColors.textPrimary)),
                        ],
                      )),
                ),
                if (selectedCount > 0) ...[
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      final selectedQuestions = List.generate(
                          controller.filteredItems.length,
                          (index) => controller.selectedRows[index]
                              ? controller.filteredItems[index]
                              : null).whereType<QuestionModel>().toList();

                      controller.bulkDeleteItems(selectedQuestions);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(Iconsax.trash, color: Colors.white),
                          const SizedBox(width: 10),
                          Text('Delete $selectedCount item(s)',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            flex: TDeviceUtils.isDesktopScreen(context) ? 2 : 1,
            child: TextFormField(
              controller: controller.searchTextController,
              onChanged: (query) => controller.searchQuery(query),
              decoration: const InputDecoration(
                  hintText: 'Search Question',
                  prefixIcon: Icon(Iconsax.search_normal)),
            ),
          ),
        ],
      );
    });
  }
}
