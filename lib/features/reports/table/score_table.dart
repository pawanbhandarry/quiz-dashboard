import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../common/widgets/data_table/paginated_data_table.dart';
import '../controller/quiz_score_controller.dart';
import 'table_source.dart';

class ScoreTable extends StatelessWidget {
  const ScoreTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScoreController());

    return Obx(() {
      Visibility(
        visible: false,
        child: Text(controller.filteredItems.length.toString()),
      );
      Visibility(
        visible: false,
        child: Text(controller.selectedRows.length.toString()),
      );

      return Column(
        children: [
          _buildFilterRow(controller),
          TPaginatedDataTable(
            minWidth: 800,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(
                label: const Text('User'),
                onSort: (columnIndex, ascending) =>
                    controller.sortByDate(columnIndex, ascending),
              ),
              const DataColumn2(label: Text('Quiz')),
              DataColumn2(
                label: const Text('Score'),
                onSort: (columnIndex, ascending) =>
                    controller.sortByScore(columnIndex, ascending),
              ),
              const DataColumn2(label: Text('Date')),
              const DataColumn2(label: Text('Actions'), fixedWidth: 100),
            ],
            source: ScoreRows(controller.filteredItems),
          ),
        ],
      );
    });
  }

  Widget _buildFilterRow(ScoreController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Quiz Filter Dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter by Quiz',
                border: OutlineInputBorder(),
              ),
              items: [], // Populate with available quizzes
              onChanged: (value) => controller.setQuizFilter(value!),
              value: controller.selectedQuizFilter.value.isNotEmpty
                  ? controller.selectedQuizFilter.value
                  : null,
            ),
          ),
          const SizedBox(width: 10),

          // Category Filter Dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(),
              ),
              items: [], // Populate with available categories
              onChanged: (value) => controller.setCategoryFilter(value!),
              value: controller.selectedCategoryFilter.value.isNotEmpty
                  ? controller.selectedCategoryFilter.value
                  : null,
            ),
          ),
          const SizedBox(width: 10),

          // Export Button
          ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Export'),
            onPressed: () => _exportScoresToCSV(controller.filteredItems),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // CSV Export Method
  Future<void> _exportScoresToCSV(List<dynamic> scores) async {
    // Create CSV data
    List<List<dynamic>> csvData = [
      ['User', 'Quiz', 'Score', 'Date'], // Header
      ...scores
          .map((score) => [
                score.userName ?? 'Unknown',
                score.quizTitle ?? 'Unknown',
                '${score.totalScore}/${score.maximumScore}',
                score.formattedDate,
              ])
          .toList()
    ];

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(csvData);

    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/quiz_scores_export.csv');

    // Write to file
    await file.writeAsString(csv);

    // Show success dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Export Successful'),
        content: Text('Scores exported to ${file.path}'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
