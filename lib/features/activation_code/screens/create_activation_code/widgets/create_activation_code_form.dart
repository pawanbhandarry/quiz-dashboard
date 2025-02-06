import 'package:dashboard/common/widgets/containers/rounded_container.dart';
import 'package:dashboard/features/activation_code/controller/create_activation_code_controller.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/activation_code/models/activation_code_model.dart';
import 'package:dashboard/utils/constants/sizes.dart';
import 'package:dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../quizes/models/quizes_models.dart';
import '../../../../user/models/user_models.dart';

class CreateActivationCodeForm extends StatefulWidget {
  const CreateActivationCodeForm({super.key});

  @override
  State<CreateActivationCodeForm> createState() =>
      _CreateActivationCodeFormState();
}

class _CreateActivationCodeFormState extends State<CreateActivationCodeForm> {
  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateActivationCodeController());
    final quizController = Get.put(QuizController());

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
            Text('Create Activation Code',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Code Text Field
            TextFormField(
              controller: createController.codeController,
              validator: (value) =>
                  TValidator.validateEmptyText('Activation Code', value),
              decoration: const InputDecoration(
                labelText: 'Activation Code',
                prefixIcon: Icon(Iconsax.key),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Quiz Selection Dropdown
            Obx(
              () => DropdownButtonFormField<QuizModel>(
                decoration: const InputDecoration(
                  hintText: 'Select Quiz',
                  labelText: 'Quiz',
                  prefixIcon: Icon(Iconsax.category),
                ),
                value: createController.selectedQuiz.value.id.isNotEmpty
                    ? createController.selectedQuiz.value
                    : null,
                onChanged: (newValue) =>
                    createController.selectedQuiz.value = newValue!,
                items: quizController.allItems.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item.title),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Usage Limit Field
            Obx(() {
              return DropdownButtonFormField<String>(
                value: createController.usageLimit.value,
                onChanged: (newValue) {
                  if (newValue != null) {
                    createController.usageLimit.value = newValue;
                  }
                },
                items: [
                  DropdownMenuItem(value: 'Single', child: Text('Single Use')),
                  DropdownMenuItem(
                      value: 'Multiple', child: Text('Multiple Uses')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Usage Limit',
                  prefixIcon: Icon(Iconsax.repeat),
                ),
              );
            }),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Expiration Date Picker
            TextFormField(
              controller: createController.expiresAtController,
              readOnly: true,
              onTap: () => createController.selectExpirationDate(context),
              validator: (value) =>
                  TValidator.validateEmptyText('Expiration Date', value),
              decoration: const InputDecoration(
                labelText: 'Expiration Date',
                prefixIcon: Icon(Iconsax.calendar),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // 🔍 Search Field
            TextFormField(
              controller: createController.searchController,
              onChanged: createController.filterUsers, // Filter when typing
              decoration: InputDecoration(
                labelText: 'Search Users to restrict',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),

            // 📃 Users List
            SizedBox(
              height: 200,
              child: Obx(() {
                if (createController.filteredUsers.isEmpty) {
                  return Center(
                      child:
                          Text("No users found")); // Show message if no match
                }

                return ListView.builder(
                  itemCount: createController.filteredUsers.length,
                  itemBuilder: (context, index) {
                    UserModel user = createController.filteredUsers[index];
                    bool isSelected = createController.selectedUsers.any(
                        (selected) => selected.id == user.id); // Compare IDs

                    return ListTile(
                      title: Text(user.email),
                      subtitle: Text(user.name),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.green : null,
                      ),
                      onTap: () {
                        setState(() {
                          isSelected = !isSelected;
                        });
                        createController.toggleUserSelection(user);
                      },
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),
            // Submit Button
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: createController.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              createController.createActivationCode(),
                          child: const Text('Create Activation Code'),
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
