import 'package:dashboard/features/activation_code/screens/create_activation_code/widgets/create_activation_code_form.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';

class CreateActivationCodeDesktopScreen extends StatelessWidget {
  const CreateActivationCodeDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              TBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Create Activation Code',
                  breadcrumbItems: [
                    TRoutes.activationCodes,
                    'Create Activation Code'
                  ]),
              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              CreateActivationCodeForm(),
            ],
          ),
        ),
      ),
    );
  }
}
