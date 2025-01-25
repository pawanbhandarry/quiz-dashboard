import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../setting/models/user_model.dart';

class CustomerDetailController extends GetxController {
  static CustomerDetailController get instance => Get.find();

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  Rx<UserModel> customer = UserModel.empty().obs;

  final searchTextController = TextEditingController();

  /// -- Search Query Filter
}
