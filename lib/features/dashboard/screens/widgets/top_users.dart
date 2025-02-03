import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../user/models/user_models.dart';
import '../../controller/dashboard_controller.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(() {
      if (controller.topUsers.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(TSizes.lg),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium, size: 32),
                  const SizedBox(width: TSizes.spaceBtwSections),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Top Students',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${controller.topUsers.length} active competitors',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            // Top 3 Section
            if (controller.topUsers.length >= 2)
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: TSizes.lg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildPodiumItem(
                            controller.topUsers[1],
                            160.0,
                            Colors.grey[300]!,
                            '2',
                          ),
                          _buildPodiumItem(
                            controller.topUsers[0],
                            180.0,
                            Colors.amber,
                            '1',
                          ),
                          // _buildPodiumItem(
                          //   controller.topUsers[2],
                          //   120.0,
                          //   Colors.brown[300]!,
                          //   '3',
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Other Players List
            ...controller.topUsers
                .skip(3)
                .toList()
                .asMap()
                .entries
                .map((entry) {
              final user = entry.value;
              final rank = entry.key + 4;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    user.firstName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${user.score} points',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 16,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${(user.score * 0.1).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  Widget _buildPodiumItem(
      UserModel user, double height, Color color, String rank) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: rank == '1' ? 32 : 28,
          backgroundColor: color.withOpacity(0.3),
          child: CircleAvatar(
            radius: rank == '1' ? 28 : 24,
            backgroundColor: Colors.white,
            child: Text(
              user.firstName[0].toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: rank == '1' ? 24 : 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.firstName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: rank == '1' ? 16 : 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${user.score} pts',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: rank == '1' ? 14 : 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height * 0.4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
