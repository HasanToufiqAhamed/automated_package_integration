import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'global_variable.dart';
import 'helper_service.dart';

final currentStateProvider = StateProvider.autoDispose<AllState>((ref) {
  return AllState.init;
});

final selectedDirectoryProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final androidExistProvider = FutureProvider.autoDispose.family<bool, String>((ref, directory) async {
  return HelperService().checkValidAndroidDirectoryAvailable(directory);
});

final iosExistProvider = FutureProvider.autoDispose.family<bool, String>((ref, directory) async {
  return HelperService().checkValidIosDirectoryAvailable(directory);
});

final platformConfigurationExistProvider = FutureProvider.autoDispose.family<bool, String>((ref, directory) async {
  return HelperService().checkPlatformConfigurationAvailable(directory);
});