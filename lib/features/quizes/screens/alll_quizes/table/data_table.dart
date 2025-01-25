import 'package:dashboard/features/category/controller/category_controller.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/quizes/screens/alll_quizes/table/table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/data_table/paginated_data_table.dart';

class QuizTable extends StatelessWidget {
  const QuizTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizController());
    return Obx(
      () {
        // Categories & Selected Rows are Hidden => Just to update the UI => Obx => [ProductRows]
        Visibility(
            visible: false,
            child: Text(controller.filteredItems.length.toString()));
        Visibility(
            visible: false,
            child: Text(controller.selectedRows.length.toString()));

        // Table
        return TPaginatedDataTable(
          minWidth: 700,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(
                label: const Text('Quiz'),
                onSort: (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending)),
            const DataColumn2(label: Text('Category')),
            const DataColumn2(label: Text('Timer')),
            const DataColumn2(label: Text('Created Date')),
            const DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: QuizRows(),
        );
      },
    );
  }
}
