import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../styles/spacing_styles.dart';

/// Template for the login page layout
class TLoginTemplate extends StatelessWidget {
  const TLoginTemplate({super.key, required this.child});

  /// The widget to be displayed inside the login template
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Container(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              color: THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}