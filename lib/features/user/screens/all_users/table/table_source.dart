import 'package:dashboard/routes/routes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/icons/table_action_icon_buttons.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controller/user_controller.dart';

class UserRows extends DataTableSource {
  final controller = UserController.instance;

  @override
  DataRow? getRow(int index) {
    final user = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(TRoutes.userDetails, arguments: user),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
          controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Row(
            children: [
              TRoundedImage(
                width: 50,
                height: 50,
                padding: TSizes.sm,
                image: user.profilePicture,
                imageType: ImageType.network,
                borderRadius: TSizes.borderRadiusMd,
                backgroundColor: TColors.primaryBackground,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  user.fullName,
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
        DataCell(Text(user.email)),
        DataCell(Text(user.createdAt == null ? '' : user.formattedDate)),
        DataCell(
          TTableActionButtons(
            view: true,
            edit: true,
            delete: false,
            onViewPressed: () =>
                Get.toNamed(TRoutes.userDetails, arguments: user),
            onEditPressed: () => controller.toggleUserStatus(user),
            // onDeletePressed: () => controller.toggleUserStatus(user),
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
