import 'package:dashboard/features/question/screens/upload_questions/upload_question.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/upload_question_form.dart';

class UploadQuestionMobileScreen extends StatelessWidget {
  const UploadQuestionMobileScreen({super.key});

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
                  heading: 'Upload Questions',
                  breadcrumbItems: [TRoutes.questions, 'Upload Questions']),
              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              UploadQuestionForm(),
            ],
          ),
        ),
      ),
    );
  }
}
