import 'package:dashboard/features/question/controllers/questions_controller.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/routes/routes.dart';
import 'package:dashboard/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/device/device_utility.dart';

class QuestionsTableHeader extends StatelessWidget {
  const QuestionsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionController());
    return Row(
      children: [
        Expanded(
          flex: !TDeviceUtils.isDesktopScreen(context) ? 1 : 3,
          child: Row(
            children: [
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () => Get.toNamed(TRoutes.addQuestion),
                      child: const Text('Add Question'))),
              const SizedBox(width: 20), // Added 20px spacing
              SizedBox(
                width: 200,
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
                        const SizedBox(width: 10),
                        const Text('Upload Question',
                            style: TextStyle(color: TColors.textPrimary)),
                      ],
                    )),
              ),
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
  }
}
