import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/material.dart';

import 'responsive/questions_desktop.dart';
import 'responsive/questions_mobile.dart';
import 'responsive/questions_tablet.dart';

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: const QuestionsDesktopScreen(),
      mobile: const QuestionsMobileScreen(),
      tablet: const QuestionsTabletScreen(),
    );
  }
}
