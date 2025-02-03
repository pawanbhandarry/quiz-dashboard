import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:dashboard/common/widgets/page_not_found/page_not_found.dart';
import 'package:dashboard/features/activation_code/screens/edit_activation_code/responsive/edit_activation_code_mobile.dart';
import 'package:dashboard/features/activation_code/screens/edit_activation_code/responsive/edit_activation_code_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'responsive/edit_activation_code_desktop.dart';

class EditActivationCodeScreen extends StatelessWidget {
  const EditActivationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activationCode = Get.arguments;
    return activationCode != null
        ? TSiteTemplate(
            desktop: EditActivationCodeDesktopScreen(
              activationCode: activationCode,
            ),
            mobile:
                EditActivationCodeMobileScreen(activationCode: activationCode),
            tablet:
                EditActivationCodeTabletScreen(activationCode: activationCode),
          )
        : TPageNotFound();
  }
}
