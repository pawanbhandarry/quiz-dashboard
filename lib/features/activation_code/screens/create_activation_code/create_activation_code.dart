import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:flutter/cupertino.dart';

import 'responsive/create_activation_code_desktop.dart';
import 'responsive/create_activation_code_mobile.dart';
import 'responsive/create_activation_code_tablet.dart';

class CreateActivationCodeScreen extends StatelessWidget {
  const CreateActivationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CreateActivationCodeDesktopScreen(),
      mobile: CreateActivationCodeMobileScreen(),
      tablet: CreateActivationCodeTabletScreen(),
    );
  }
}
