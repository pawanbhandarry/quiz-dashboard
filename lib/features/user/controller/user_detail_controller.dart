import 'package:dashboard/features/user/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../setting/models/admin_model.dart';

class UserDetailController extends GetxController {
  static UserDetailController get instance => Get.find();

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final searchTextController = TextEditingController();

  /// -- Search Query Filter
}
