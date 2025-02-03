import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/cupertino.dart';

import 'responsive/activation_code_desktop.dart';
import 'responsive/activation_code_mobile.dart';
import 'responsive/activation_code_tablet.dart';

class ActivationCodeScreen extends StatelessWidget {
  const ActivationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: ActivationCodeDesktopScreen(),
      mobile: ActivationCodeMobileScreen(),
      tablet: ActivationCodeTabletScreen(),
    );
  }
}
