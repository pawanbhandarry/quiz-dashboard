import 'package:dashboard/common/widgets/containers/rounded_container.dart';

import 'package:dashboard/features/category/models/category_model.dart';
import 'package:dashboard/features/category/controller/category_controller.dart';
import 'package:dashboard/utils/constants/sizes.dart';
import 'package:dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controller/create_quiz_controller.dart';

class CreateQuizForm extends StatelessWidget {
  const CreateQuizForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateQuizController());
    final categoryController = Get.put(CategoryController());

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text('Create New Quiz',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Title Text Field
            TextFormField(
              controller: createController.title,
              validator: (value) =>
                  TValidator.validateEmptyText('Quiz Title', value),
              decoration: const InputDecoration(
                labelText: 'Quiz Title',
                prefixIcon: Icon(Iconsax.book),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Description Text Field
            TextFormField(
              controller: createController.description,
              validator: (value) =>
                  TValidator.validateEmptyText('Description', value),
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Iconsax.clipboard_text),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Category Dropdown
            Obx(
              () => DropdownButtonFormField<CategoryModel>(
                decoration: const InputDecoration(
                  hintText: 'Select Category',
                  labelText: 'Category',
                  prefixIcon: Icon(Iconsax.category),
                ),
                value: createController.selectedCategory.value.id.isNotEmpty
                    ? createController.selectedCategory.value
                    : null,
                onChanged: (newValue) =>
                    createController.selectedCategory.value = newValue!,
                items: categoryController.allItems.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.name),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Timer Field
            TextFormField(
              controller: createController.timer,
              validator: (value) =>
                  TValidator.validateNumeric('Timer (minutes)', value),
              decoration: const InputDecoration(
                labelText: 'Timer (minutes)',
                prefixIcon: Icon(Iconsax.timer),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Submit Button
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: createController.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => createController.createQuiz(),
                          child: const Text('Create Quiz'),
                        ),
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
