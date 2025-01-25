import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/add_question_form.dart';

class AddQuestionMobileScreen extends StatelessWidget {
  const AddQuestionMobileScreen({super.key});

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
                  heading: 'Add Question',
                  breadcrumbItems: [TRoutes.questions, 'Add Question']),
              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              AddQuestionForm(),
            ],
          ),
        ),
      ),
    );
  }
}
