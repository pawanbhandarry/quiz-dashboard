import 'package:flutter/material.dart';
import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

import '../../../models/user_models.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: TColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.md,
                horizontal: TSizes.lg,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TColors.primary, TColors.primary.withOpacity(0.7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.white, size: 30),
                  const SizedBox(width: TSizes.sm),
                  Text(
                    'User Information',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Basic Info Card - Always Visible
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
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections / 2),
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
                const SizedBox(width: 120, child: Text('Joined Date')),
                const Text(':'),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Expanded(
                    child: Text(user.formattedDate,
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

            // Divider
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            // // Additional Details Cont.
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Grade',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(user.grade),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('School',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(user.schoolName),
                    ],
                  ),
                ),
              ],
            ),

            // Expandable Detailed Info
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: TColors.primary.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(':'),
          const SizedBox(width: TSizes.spaceBtwItems / 2),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      margin: const EdgeInsets.symmetric(horizontal: TSizes.xs),
      decoration: BoxDecoration(
        color: TColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: TColors.primary.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
