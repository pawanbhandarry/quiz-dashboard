import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../common/widgets/data_table/paginated_data_table.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../reports/controller/quiz_score_controller.dart';

import 'table_source.dart';

class DashboardQuizAttempt extends StatelessWidget {
  const DashboardQuizAttempt({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizScoreController());
    return Obx(
      () {
        Visibility(
            visible: true,
            child: Text(controller.filteredItems.length.toString()));
        Visibility(
            visible: true,
            child: Text(controller.selectedRows.length.toString()));
        // Check if the filteredItems are updated

        return TPaginatedDataTable(
          minWidth: 700,
          tableHeight: 500,
          dataRowHeight: TSizes.xl * 1.2,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(
              label: const Text('User'),
              onSort: (columnIndex, ascending) {
                controller.sortByuserName(columnIndex, ascending);
              },
            ),
            const DataColumn2(label: Text('Category')),
            const DataColumn2(label: Text('Quiz')),
            DataColumn2(
              label: const Text('Score'),
              onSort: (columnIndex, ascending) {
                controller.sortByScore(columnIndex, ascending);
              },
            ),
            DataColumn2(
              label: Text('Date'),
              onSort: (columnIndex, ascending) {
                controller.sortByDate(columnIndex, ascending);
              },
            ),
          ],
          source: ScoreRows(),
        );
      },
    );
  }
}
