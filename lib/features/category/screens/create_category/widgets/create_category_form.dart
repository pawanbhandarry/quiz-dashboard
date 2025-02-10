import 'package:dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:dashboard/features/category/models/category_model.dart';
import 'package:dashboard/utils/constants/sizes.dart';
import 'package:dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../controller/category_controller.dart';
import '../../../controller/create_category_controller.dart';

class CreateCategoryForm extends StatelessWidget {
  const CreateCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCategoryController());
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
            Text('Create New Category',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: createController.name,
              validator: (value) =>
                  TValidator.validateWithCharacterLimit('Name', value),
              decoration: const InputDecoration(
                  labelText: 'Category Name',
                  prefixIcon: Icon(Iconsax.category)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            // Description Text Field
            TextFormField(
              controller: createController.description,
              validator: (value) =>
                  TValidator.validateWithCharacterLimit('Description', value),
              decoration: const InputDecoration(
                  labelText: 'Description', prefixIcon: Icon(Iconsax.message)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: createController.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () => createController.createCategory(),
                            child: const Text('Create')),
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
