import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../reports/controller/quiz_score_controller.dart';
import 'table_source.dart';

class UserScoreTable extends StatelessWidget {
  const UserScoreTable({super.key});

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

        return Column(
          children: [
            TPaginatedDataTable(
              minWidth: 800,
              sortAscending: controller.sortAscending.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              columns: [
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
                const DataColumn2(label: Text('Actions'), fixedWidth: 100),
              ],
              source: UserScoreRows(),
            ),
          ],
        );
      },
    );
  }
}
