import 'package:dashboard/features/setting/controllers/settings_controller.dart';
import 'package:dashboard/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';
import 'menu/menu_item.dart';

/// Sidebar widget for navigation menu
class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(width: 1, color: TColors.grey)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.spaceBtwSections),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                    child: Icon(
                      Iconsax.book_square5,
                      size: 60,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Quiz Master',
                      style: Theme.of(context).textTheme.headlineLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('MENU',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),
                    // Menu Items
                    const TMenuItem(
                        route: TRoutes.dashboard,
                        icon: Iconsax.home,
                        itemName: 'Dashboard'),
                    const TMenuItem(
                        route: TRoutes.users,
                        icon: Iconsax.profile_2user,
                        itemName: 'Users'),
                    const TMenuItem(
                        route: TRoutes.categories,
                        icon: Iconsax.category_2,
                        itemName: 'Categories'),
                    const TMenuItem(
                        route: TRoutes.quizes,
                        icon: Iconsax.book,
                        itemName: 'Quizes'),
                    const TMenuItem(
                        route: TRoutes.questions,
                        icon: Iconsax.add_square,
                        itemName: 'Questions'),
                    const TMenuItem(
                        route: TRoutes.activationCodes,
                        icon: Iconsax.key,
                        itemName: 'Activation Codes'),
                    const TMenuItem(
                        route: TRoutes.reports,
                        icon: Iconsax.chart,
                        itemName: 'Reports'),

                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text('OTHER',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(letterSpacingDelta: 1.2)),
                    // Other menu items
                    const TMenuItem(
                        route: TRoutes.profile,
                        icon: Iconsax.user,
                        itemName: 'Profile'),
                    // const TMenuItem(
                    //     route: TRoutes.settings,
                    //     icon: Iconsax.setting_2,
                    //     itemName: 'Settings'),
                    const TMenuItem(
                        route: 'logout',
                        icon: Iconsax.logout,
                        itemName: 'Logout'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
