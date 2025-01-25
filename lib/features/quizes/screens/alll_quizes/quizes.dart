import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/material.dart';

import 'responsive/quizes_desktop.dart';
import 'responsive/quizes_mobile.dart';
import 'responsive/quizes_tablet.dart';

class QuizesScreen extends StatelessWidget {
  const QuizesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
        desktop: QuizesDesktopScreen(),
        tablet: QuizesTabletScreen(),
        mobile: QuizesMobileScreen());
  }
}
