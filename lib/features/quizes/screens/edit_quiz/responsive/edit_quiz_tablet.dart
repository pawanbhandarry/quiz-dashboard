import 'package:dashboard/features/quizes/models/quizes_models.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../category/models/category_model.dart';
import '../widgets/edit_quiz_form.dart';

class EditQuizTabletScreen extends StatelessWidget {
  const EditQuizTabletScreen({super.key, required this.quiz});

  final QuizModel quiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Update Quiz',
                  breadcrumbItems: [TRoutes.categories, 'Update Quiz']),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditQuizForm(quiz: quiz),
            ],
          ),
        ),
      ),
    );
  }
}
