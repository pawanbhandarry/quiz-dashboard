import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../../quizes/controller/quiz_controller.dart';
import '../../../../quizes/models/quizes_models.dart';
import '../../../controllers/create_question_controller.dart';

class AddQuestionForm extends StatelessWidget {
  const AddQuestionForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateQuestionController());
    final quizController = Get.put(QuizController());

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text('Add New Question',
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
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Question Text Field
            TextFormField(
              controller: controller.questionController,
              validator: (value) =>
                  TValidator.validateEmptyText('Question', value),
              decoration: const InputDecoration(
                labelText: 'Question',
                prefixIcon: Icon(Iconsax.book),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Option A
            _buildOptionTextField(
              controller: controller.optionAController,
              label: 'Option A',
              icon: Iconsax.link,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Option B
            _buildOptionTextField(
              controller: controller.optionBController,
              label: 'Option B',
              icon: Iconsax.link,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Option C
            _buildOptionTextField(
              controller: controller.optionCController,
              label: 'Option C',
              icon: Iconsax.link,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Option D
            _buildOptionTextField(
              controller: controller.optionDController,
              label: 'Option D',
              icon: Iconsax.link,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Correct Answer Selection
            Obx(
              () => DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select Correct Answer',
                  labelText: 'Correct Answer',
                  prefixIcon: Icon(Iconsax.tick_circle),
                ),
                value: controller.correctAnswerKey.value.isNotEmpty
                    ? controller.correctAnswerKey.value
                    : null, // The dropdown's selected value should match one of the keys
                onChanged: (newValue) {
                  controller.correctAnswerKey.value = newValue!;
                  // Map the selected key to the actual controller value
                  switch (newValue) {
                    case 'A':
                      controller.correctAnswer.value =
                          controller.optionAController.text;
                      break;
                    case 'B':
                      controller.correctAnswer.value =
                          controller.optionBController.text;
                      break;
                    case 'C':
                      controller.correctAnswer.value =
                          controller.optionCController.text;
                      break;
                    case 'D':
                      controller.correctAnswer.value =
                          controller.optionDController.text;
                      break;
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: 'A',
                    child:
                        Text('Option A (${controller.optionAController.text})'),
                  ),
                  DropdownMenuItem(
                    value: 'B',
                    child:
                        Text('Option B (${controller.optionBController.text})'),
                  ),
                  DropdownMenuItem(
                    value: 'C',
                    child:
                        Text('Option C (${controller.optionCController.text})'),
                  ),
                  DropdownMenuItem(
                    value: 'D',
                    child:
                        Text('Option D (${controller.optionDController.text})'),
                  ),
                ],
                validator: (value) =>
                    value == null ? 'Please select the correct answer' : null,
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Explanation Text Field
            TextFormField(
              controller: controller.explanationController,
              decoration: const InputDecoration(
                labelText: 'Explanation',
                prefixIcon: Icon(Iconsax.info_circle),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Image Upload (Optional)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL (Optional)',
                      prefixIcon: Icon(Iconsax.image),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwInputFields),
                IconButton(
                  icon: const Icon(Iconsax.gallery_add),
                  onPressed: () => controller.pickImage(),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Submit Button
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.createQuestion(),
                          child: const Text('Add Question'),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build option text fields
  Widget _buildOptionTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) => TValidator.validateEmptyText(label, value),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
