import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../controller/dashboard_controller.dart';

class TopPerformingQuizzes extends StatelessWidget {
  const TopPerformingQuizzes({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: TColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        color: TColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Top Performing Quizzes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: TColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Quiz List
              ...controller.topPerformingQuizzes.asMap().entries.map(
                    (entry) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: entry.key !=
                                controller.topPerformingQuizzes.length - 1
                            ? Border(
                                bottom: BorderSide(
                                  color: TColors.borderPrimary.withOpacity(0.2),
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Rank Container
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getRankColor(entry.key).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "#${entry.key + 1}",
                                style: TextStyle(
                                  color: _getRankColor(entry.key),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Quiz Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.value["title"] ?? "Unknown",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: TColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 16,
                                      color: TColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${entry.value["count"]} attempts",
                                      style: TextStyle(
                                        color: TColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.trending_up,
                                      size: 16,
                                      color: TColors.success,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${(entry.value["completion_rate"] ?? 85)}%",
                                      style: TextStyle(
                                        color: TColors.success,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Arrow Icon
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: TColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

              // Bottom Padding
              const SizedBox(height: 12),
            ],
          ),
        ));
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return TColors.primary;
      case 1:
        return TColors.info;
      case 2:
        return TColors.success;
      default:
        return TColors.textSecondary;
    }
  }
}
