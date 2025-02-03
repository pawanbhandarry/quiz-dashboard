import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';
import 'responsive_screens/customers_desktop.dart';
import 'responsive_screens/customers_mobile.dart';
import 'responsive_screens/customers_tablet.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
        desktop: UsersDesktopScreen(),
        tablet: UsersTabletScreen(),
        mobile: UsersMobileScreen());
  }
}
