import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../common/widgets/page_not_found/page_not_found.dart';
import 'responsive_screens/user_detail_desktop.dart';
import 'responsive_screens/user_detail_mobile.dart';
import 'responsive_screens/user_detail_tablet.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments;

    return user != null
        ? TSiteTemplate(
            desktop: UserDetailDesktopScreen(user: user),
            tablet: UserDetailTabletScreen(user: user),
            mobile: UserDetailMobileScreen(user: user),
          )
        : const TPageNotFound(
            isFullPage: false,
          );
  }
}
