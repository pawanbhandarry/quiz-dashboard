import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive/edit_quiz_desktop.dart';
import 'responsive/edit_quiz_mobile.dart';
import 'responsive/edit_quiz_tablet.dart';

class EditQuizScreen extends StatelessWidget {
  const EditQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = Get.arguments;
    return quiz != null
        ? TSiteTemplate(
            desktop: EditQuizDesktopScreen(quiz: quiz),
            tablet: EditQuizTabletScreen(
              quiz: quiz,
            ),
            mobile: EditQuizMobileScreen(
              quiz: quiz,
            ),
          )
        : const TPageNotFound();
  }
}
