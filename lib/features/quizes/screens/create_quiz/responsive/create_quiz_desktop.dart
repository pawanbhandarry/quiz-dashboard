import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/create_quiz_form.dart';

class CreateQuizDesktopScreen extends StatelessWidget {
  const CreateQuizDesktopScreen({super.key});

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
                  heading: 'Create Quiz',
                  breadcrumbItems: [TRoutes.quizes, 'Create Quiz']),
              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              CreateQuizForm(),
            ],
          ),
        ),
      ),
    );
  }
}
