import 'package:get/get.dart';

import '../../../data/abstract/base_data_table_controller.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../setting/models/admin_model.dart';
import '../models/user_models.dart';

class UserController extends TBaseController<UserModel> {
  static UserController get instance => Get.find();

  final _userRepository = Get.put(UserRepository());

  @override
  Future<List<UserModel>> fetchItems() async {
    return await _userRepository.getAllUsers();
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending,
        (UserModel o) => o.fullName.toString().toLowerCase());
  }

  @override
  bool containsSearchQuery(UserModel item, String query) {
    return item.fullName.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(UserModel item) async {
    await _userRepository.deleteUser(item.id ?? '');
  }

  void toggleUserStatus(UserModel user) async {
    await _userRepository.toggleUserStatus(user.id ?? '', user.status);
    await fetchItems(); // Refresh user list after update
  }
}
