import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:dashboard/features/question/screens/add_questions/responsive/add_question_desktop.dart';
import 'package:dashboard/features/question/screens/add_questions/responsive/add_question_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'responsive/add_question_tablet.dart';

class AddQuestionScreen extends StatelessWidget {
  const AddQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final question = Get.arguments;
    return TSiteTemplate(
      desktop: AddQuestionDesktopScreen(),
      tablet: AddQuestionTabletScreen(),
      mobile: AddQuestionMobileScreen(),
    );
  }
}
