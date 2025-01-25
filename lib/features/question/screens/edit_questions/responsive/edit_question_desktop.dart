import 'package:dashboard/features/category/screens/edit_category/widgets/edit_category_form.dart';
import 'package:dashboard/features/question/models/question_models.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widget/edit_question_form.dart';

class EditQuestionDesktopScreen extends StatelessWidget {
  final QuestionModel question;
  const EditQuestionDesktopScreen({super.key, required this.question});

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
                  heading: 'Edit Question',
                  breadcrumbItems: [TRoutes.questions, 'Edit Question']),
              SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditQuestionForm(question: question),
            ],
          ),
        ),
      ),
    );
  }
}
