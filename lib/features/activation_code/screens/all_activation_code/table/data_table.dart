import 'package:dashboard/features/activation_code/controller/activation_code_controller.dart';
import 'package:dashboard/features/category/controller/category_controller.dart';
import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/features/quizes/screens/alll_quizes/table/table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/data_table/paginated_data_table.dart';
import 'table_scource.dart';

class ActivationCodeDataTable extends StatelessWidget {
  const ActivationCodeDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivationCodeController());
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
                label: const Text('Code'),
                onSort: (columnIndex, ascending) =>
                    controller.sortByCode(columnIndex, ascending)),
            const DataColumn2(label: Text('Quiz')),
            const DataColumn2(label: Text('Usage Limit')),
            const DataColumn2(label: Text('Expires At')),
            const DataColumn2(label: Text('Status')),
            const DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: ActivationCodeRows(),
        );
      },
    );
  }
}
