import 'package:dashboard/features/setting/controllers/settings_controller.dart';
import 'package:get/get.dart';
import '../features/setting/controllers/admin_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => AdminController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
