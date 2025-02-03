import 'package:dashboard/routes/routes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/questions_controller.dart';

class QuestionRows extends DataTableSource {
  final controller = QuestionController.instance;

  @override
  DataRow? getRow(int index) {
    final quiz = controller.filteredItems[index];

    return DataRow2(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
          controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  quiz.question,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .bodyLarge!
                      .apply(color: TColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(quiz.categoryName!),
        ),
        DataCell(
          Text(quiz.quizName!),
        ),
        DataCell(Text(quiz.correctAnswer)),
        DataCell(
          TTableActionButtons(
            onEditPressed: () =>
                Get.toNamed(TRoutes.editQuestion, arguments: quiz),
            onDeletePressed: () => controller.confirmAndDeleteItem(quiz),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((selected) => selected).length;
}
