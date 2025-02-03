import 'package:dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../utils/constants/colors.dart';
import '../../controller/dashboard_controller.dart';

class PerformanceChartWidget extends StatelessWidget {
  const PerformanceChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(() {
      if (controller.weeklyQuizAttempts.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
          ),
        );
      }

      final List<String> days = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];
      final List<BarChartGroupData> barGroups = [];

      double maxValue = 0;
      for (String day in days) {
        final value = (controller.weeklyQuizAttempts[day] ?? 0).toDouble();
        if (value > maxValue) maxValue = value;
      }

      for (int i = 0; i < days.length; i++) {
        final value = (controller.weeklyQuizAttempts[days[i]] ?? 0).toDouble();
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value,
                color: _getBarColor(value, maxValue),
                width: 16,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxValue,
                  color: TColors.lightGrey,
                ),
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        );
      }

      final totalAttempts = controller.weeklyQuizAttempts.values
          .fold<int>(0, (sum, value) => sum + value);
      final averageAttempts = (totalAttempts / days.length).toStringAsFixed(1);

      return Container(
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: TColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.bar_chart, color: TColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Quiz Performance",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  _buildStatsChip(totalAttempts.toString(), "Total Attempts"),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Daily Average: $averageAttempts attempts",
                style: TextStyle(
                  color: TColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              SizedBox(
                height: 280,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: TColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[value.toInt()],
                                style: TextStyle(
                                  color: TColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      horizontalInterval: maxValue / 5,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: TColors.borderPrimary.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 300),
                  swapAnimationCurve: Curves.easeInOut,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatsChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: TColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: TColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBarColor(double value, double maxValue) {
    final percentage = value / maxValue;
    if (percentage >= 0.8) return TColors.primary;
    if (percentage >= 0.5) return TColors.accent;
    return TColors.accent.withOpacity(0.6);
  }
}
