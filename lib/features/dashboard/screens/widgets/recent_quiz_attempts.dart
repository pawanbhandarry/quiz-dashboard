import 'package:dashboard/features/dashboard/screens/table/data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../reports/controller/quiz_score_controller.dart';
import '../../controller/dashboard_controller.dart';

class RecentQuizAttempts extends StatelessWidget {
  const RecentQuizAttempts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    Get.put(QuizScoreController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TCircularIcon(
              icon: Iconsax.graph,
              backgroundColor: Colors.brown.withOpacity(0.1),
              color: Colors.brown,
              size: TSizes.md,
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text('Recent Quiz Attempts',
                style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        // RecentScoreTable(),
      ],
    );
  }
}
