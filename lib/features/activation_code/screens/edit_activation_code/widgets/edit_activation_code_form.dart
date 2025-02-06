import 'package:dashboard/common/widgets/containers/rounded_container.dart';
import 'package:dashboard/features/activation_code/controller/edit_activation_code_controller.dart';
import 'package:dashboard/features/activation_code/models/activation_code_model.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/utils/constants/sizes.dart';
import 'package:dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../quizes/models/quizes_models.dart';
import '../../../../user/models/user_models.dart';

class EditActivationCodeForm extends StatefulWidget {
  final ActivationCodeModel activationCode;
  const EditActivationCodeForm({super.key, required this.activationCode});

  @override
  State<EditActivationCodeForm> createState() => _EditActivationCodeFormState();
}

class _EditActivationCodeFormState extends State<EditActivationCodeForm> {
  @override
  Widget build(BuildContext context) {
// In your UI
    final editController = Get.put(EditActivationCodeController());
    editController
        .init(widget.activationCode); // Pass the activation code model

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
            Text('Edit Activation Code',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Code Text Field
            TextFormField(
              controller: editController.codeController,
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
              () {
                final quizzes = QuizController.instance.allItems;
                final selectedQuiz = editController.selectedQuiz.value;

                // Find the matching quiz from the list
                final currentQuiz = quizzes.firstWhere(
                  (quiz) => quiz.id == selectedQuiz.id,
                );

                return DropdownButtonFormField<QuizModel>(
                  value: currentQuiz, // Will be null if no match found
                  onChanged: (newValue) {
                    if (newValue != null) {
                      editController.selectedQuiz.value = newValue;
                    }
                  },
                  items: quizzes.map((quiz) {
                    return DropdownMenuItem(
                      value: quiz,
                      child: Text(quiz.title),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Quiz',
                    prefixIcon: Icon(Icons.quiz),
                  ),
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Usage Limit Field
            Obx(() {
              return DropdownButtonFormField<String>(
                value: editController.usageLimit.value,
                onChanged: (newValue) {
                  if (newValue != null) {
                    editController.usageLimit.value = newValue;
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
              controller: editController.expiresAtController,
              readOnly: true,
              onTap: () => editController.selectExpirationDate(context),
              validator: (value) =>
                  TValidator.validateEmptyText('Expiration Date', value),
              decoration: const InputDecoration(
                labelText: 'Expiration Date',
                prefixIcon: Icon(Iconsax.calendar),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Search Users Field
            TextFormField(
              controller: editController.searchController,
              onChanged: editController.filterUsers,
              decoration: const InputDecoration(
                labelText: 'Search Users to restrict',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),

            // Users List
            SizedBox(
              height: 200,
              child: Obx(() {
                if (editController.filteredUsers.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                return ListView.builder(
                  itemCount: editController.filteredUsers.length,
                  itemBuilder: (context, index) {
                    UserModel user = editController.filteredUsers[index];

                    return Obx(() => ListTile(
                          title: Text(user.email),
                          subtitle: Text(user.name),
                          trailing: Icon(
                            editController.isUserSelected(user.id!)
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: editController.isUserSelected(user.id!)
                                ? Colors.green
                                : null,
                          ),
                          onTap: () {
                            editController.toggleUserSelection(user);
                          },
                        ));
                  },
                );
              }),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Update Button
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: editController.loading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => editController
                              .updateActivationCode(widget.activationCode.id),
                          child: const Text('Update Activation Code'),
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
