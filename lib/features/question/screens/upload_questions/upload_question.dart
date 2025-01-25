import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/material.dart';

import 'responsive/upload_question_desktop.dart';
import 'responsive/upload_question_mobile.dart';
import 'responsive/upload_question_tablet.dart';

class UploadQuestionScreen extends StatelessWidget {
  const UploadQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: const UploadQuestionDesktopScreen(),
      tablet: const UploadQuestionTabletScreen(),
      mobile: const UploadQuestionMobileScreen(),
    );
  }
}
