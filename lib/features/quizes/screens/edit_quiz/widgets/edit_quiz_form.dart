import 'package:dashboard/features/category/controller/category_controller.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/quizes/models/quizes_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../../category/models/category_model.dart';
import '../../../controller/edit_quiz_controller.dart';

class EditQuizForm extends StatelessWidget {
  const EditQuizForm({super.key, required this.quiz});

  final QuizModel quiz;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditQuizController());
    editController.init(quiz);

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text('Update Quiz',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Title Text Field
            TextFormField(
              controller: editController.title,
              validator: (value) =>
                  TValidator.validateWithCharacterLimit('Quiz Title', value),
              decoration: const InputDecoration(
                labelText: 'Quiz Title',
                prefixIcon: Icon(Iconsax.book),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Description Text Field
            TextFormField(
              controller: editController.description,
              validator: (value) =>
                  TValidator.validateWithCharacterLimit('Description', value),
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Iconsax.clipboard_text),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(
              () => DropdownButtonFormField<CategoryModel>(
                value: editController.selectedCategory.value.id.isNotEmpty
                    ? editController.selectedCategory.value
                    : null,
                onChanged: (newValue) =>
                    editController.selectedCategory.value = newValue!,
                items: CategoryController.instance.allItems
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  prefixIcon: Icon(Icons.category),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Timer Field
            TextFormField(
              controller: editController.timer,
              validator: (value) =>
                  TValidator.validateNumeric('Timer (minutes)', value),
              decoration: const InputDecoration(
                labelText: 'Timer (minutes)',
                prefixIcon: Icon(Iconsax.timer),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: editController.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => editController.updateQuiz(quiz),
                            child: const Text('Update')),
                      ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
