import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive/edit_question_desktop.dart';
import 'responsive/edit_question_mobile.dart';
import 'responsive/edit_question_tablet.dart';

class EditQuestionScreen extends StatelessWidget {
  const EditQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final question = Get.arguments;
    return question != null
        ? TSiteTemplate(
            desktop: EditQuestionDesktopScreen(question: question),
            tablet: EditQuestionTabletScreen(question: question),
            mobile: EditQuestionMobileScreen(question: question),
          )
        : const TPageNotFound();
  }
}
