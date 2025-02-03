import 'package:dashboard/features/activation_code/screens/edit_activation_code/widgets/edit_activation_code_form.dart';
import 'package:flutter/material.dart';

import 'package:dashboard/features/activation_code/models/activation_code_model.dart';
import 'package:dashboard/features/activation_code/screens/create_activation_code/widgets/create_activation_code_form.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';

class EditActivationCodeMobileScreen extends StatelessWidget {
  final ActivationCodeModel activationCode;
  const EditActivationCodeMobileScreen({
    super.key,
    required this.activationCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Edit Activation Code',
                  breadcrumbItems: [
                    TRoutes.activationCodes,
                    'Edit Activation Code'
                  ]),
              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditActivationCodeForm(
                activationCode: activationCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
