import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/material.dart';

import 'responsive/create_quiz_desktop.dart';
import 'responsive/create_quiz_mobile.dart';
import 'responsive/create_quiz_tablet.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CreateQuizDesktopScreen(),
      tablet: CreateQuizTabletScreen(),
      mobile: CreateQuizMobileScreen(),
    );
  }
}
