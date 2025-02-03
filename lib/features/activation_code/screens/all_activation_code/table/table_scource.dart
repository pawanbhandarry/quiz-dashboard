import 'package:dashboard/features/activation_code/controller/activation_code_controller.dart';

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

class ActivationCodeRows extends DataTableSource {
  final controller = ActivationCodeController.instance;

  @override
  DataRow? getRow(int index) {
    final activationCode = controller.filteredItems[index];

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
                  activationCode.code,
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
          Text(activationCode.quizName!),
        ),
        DataCell(Text(activationCode.usageLimit.toString())),
        DataCell(Text(activationCode.expiresAt!.toIso8601String())),
        DataCell(Text(activationCode.status.toUpperCase())),
        DataCell(
          TTableActionButtons(
            delete: false,
            view: true,
            onViewPressed: () => {},
            onEditPressed: () => Get.toNamed(TRoutes.editActivationCode,
                arguments: activationCode),
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
