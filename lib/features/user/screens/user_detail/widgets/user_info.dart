import 'package:dashboard/features/user/models/user_models.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../setting/models/admin_model.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Information',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Personal Info Card
          Row(
            children: [
              TRoundedImage(
                padding: 0,
                backgroundColor: TColors.primaryBackground,
                image: user.profilePicture.isNotEmpty
                    ? user.profilePicture
                    : TImages.user,
                imageType: user.profilePicture.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                    Text(user.email,
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Meta Data
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Full Name')),
              const Text(':'),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(user.fullName,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Total Score')),
              const Text(':'),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(user.score.toString(),
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Status')),
              const Text(':'),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Expanded(
                  child: Text(user.status.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Divider
          const Divider(),
          const SizedBox(height: TSizes.spaceBtwItems),

          // // Additional Details
          // Row(
          //   children: [
          //     Expanded(
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Last Order',
          //               style: Theme.of(context).textTheme.titleLarge),
          //           const Text('7 Days Ago, #[36d54]'),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Average Order Value',
          //               style: Theme.of(context).textTheme.titleLarge),
          //           const Text('\$352'),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: TSizes.spaceBtwItems),

          // // Additional Details Cont.
          // Row(
          //   children: [
          //     Expanded(
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Registered',
          //               style: Theme.of(context).textTheme.titleLarge),
          //           Text(user.formattedDate),
          //         ],
          //       ),
          //     ),
          //     Expanded(
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text('Email Marketing',
          //               style: Theme.of(context).textTheme.titleLarge),
          //           const Text('Subscribed'),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
