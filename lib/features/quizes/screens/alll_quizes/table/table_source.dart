import 'package:dashboard/features/quizes/controller/quiz_controller.dart';
import 'package:dashboard/routes/routes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';

class QuizRows extends DataTableSource {
  final controller = QuizController.instance;

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
                  quiz.title,
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
          Text(quiz.categoryName == null ? '' : quiz.categoryName!),
        ),
        DataCell(Text("${quiz.timer.toString()} min")),
        DataCell(Text(quiz.createdAt == null ? '' : quiz.formattedDate)),
        DataCell(
          TTableActionButtons(
            onEditPressed: () => Get.toNamed(TRoutes.editQuiz, arguments: quiz),
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
