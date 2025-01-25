import 'package:dashboard/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/admin_controller.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = AdminController.instance;
    return Column(
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.lg, horizontal: TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile Details',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: TSizes.spaceBtwSections),

              // First and Last Name
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // First Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            decoration: const InputDecoration(
                              hintText: 'First Name',
                              label: Text('First Name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                                'First Name', value),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        // Last Name
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              label: Text('Last Name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                                'Last Name', value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    // // Email and Phone
                    // Row(
                    //   children: [
                    //     // First Name
                    //     Expanded(
                    //       child: TextFormField(
                    //         decoration: const InputDecoration(
                    //           hintText: 'Email',
                    //           label: Text('Email'),
                    //           prefixIcon: Icon(Iconsax.forward),
                    //           enabled: false,
                    //         ),
                    //         initialValue:
                    //             AdminController.instance.user.value.email,
                    //       ),
                    //     ),
                    //     const SizedBox(width: TSizes.spaceBtwItems),
                    //     // Last Name
                    //     Expanded(
                    //       child: TextFormField(
                    //         controller: controller.phoneController,
                    //         decoration: const InputDecoration(
                    //           hintText: 'Phone Number',
                    //           label: Text('Phone Number'),
                    //           prefixIcon: Icon(Iconsax.mobile),
                    //         ),
                    //         validator: (value) => TValidator.validateEmptyText(
                    //             'Phone Number', value),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () => controller.loading.value
                        ? () {}
                        : controller.updateUserInformation(),
                    child: controller.loading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                        : const Text('Update Profile'),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
