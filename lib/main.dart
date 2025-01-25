import 'package:dashboard/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'utils/constants/api_constants.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Entry point of Flutter App
Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage
  await GetStorage.init();

  // Remove # sign from url
  usePathUrlStrategy();

  // Initialize Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey)
      .then((_) => Get.put(AuthenticationRepository()));

  // Main App Starts here...
  runApp(const App());
}
