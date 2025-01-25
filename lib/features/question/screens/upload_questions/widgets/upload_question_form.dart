import 'package:dashboard/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../quizes/controller/quiz_controller.dart';
import '../../../../quizes/models/quizes_models.dart';
import '../../../controllers/upload_question_controller.dart';

class UploadQuestionForm extends StatelessWidget {
  const UploadQuestionForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploadQuestionController());
    final quizController = Get.put(QuizController());

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          const SizedBox(height: TSizes.sm),
          Text('Bulk Question Upload',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Quiz Selection Dropdown
          Obx(
            () => DropdownButtonFormField<QuizModel>(
              decoration: const InputDecoration(
                hintText: 'Select Quiz',
                labelText: 'Quiz',
                prefixIcon: Icon(Iconsax.document),
              ),
              value: controller.selectedQuiz.value.id.isNotEmpty
                  ? controller.selectedQuiz.value
                  : null,
              onChanged: (newValue) =>
                  controller.selectedQuiz.value = newValue!,
              items: quizController.allItems.map((item) {
                // Changed from items to allItems
                return DropdownMenuItem(
                  value: item,
                  child: Text(item.title),
                );
              }).toList(),
              validator: (value) =>
                  value == null ? 'Please select a quiz' : null,
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Template Download and File Read Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.document_download,
                      color: TColors.textWhite),
                  label: const Text('Download Template'),
                  onPressed: () => controller.downloadCSVTemplate(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.success,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Iconsax.document_upload,
                    color: TColors.textWhite,
                  ),
                  label: const Text('Upload CSV'),
                  onPressed: () => controller.readCSVFile(),
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Colors.blue.shade100,
                  // ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Prepared Questions Preview
          Obx(
            () => controller.preparedQuestions.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prepared Questions Preview',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          itemCount: controller.preparedQuestions.length,
                          itemBuilder: (context, index) {
                            final question =
                                controller.preparedQuestions[index];
                            return ListTile(
                              title: Text(question.question),
                              subtitle: Text(
                                  'Correct Answer: ${question.correctAnswer}'),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      // Upload to Database Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon:
                              const Icon(Iconsax.add, color: TColors.textWhite),
                          label: const Text('Add Questions'),
                          onPressed: () => controller.uploadPreparedQuestions(),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
