import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../controller/dashboard_controller.dart';

class UserEngagementChart extends StatelessWidget {
  const UserEngagementChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(() => Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("User Engagement",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: controller.totalActiveUsers.value.toDouble(),
                        title: 'Active Users',
                      ),
                      PieChartSectionData(
                        value: (controller.totalUsers.value -
                                controller.totalActiveUsers.value)
                            .toDouble(),
                        title: 'Inactive Users',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
