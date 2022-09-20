import 'package:davar/src/data/repositories/local/secured.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/data/repositories/authentication_repository.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/domain/i_secure_storage.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
import 'package:davar/src/settings/settings_controller.dart';
import 'package:davar/src/settings/settings_service.dart';
import 'package:get_it/get_it.dart';

import 'src/data/repositories/local/database/db.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // the order is important!
  locator.registerLazySingleton<ISecureStorage>(() => Secured());
  locator.registerLazySingleton<IUserLocalDb<Map<String, dynamic>>>(
          () => DB.instance);
  locator.registerSingleton<IAuthenticationRepository<User>>(
      AuthenticationRepository());
  locator.registerSingleton<SettingsService>(SettingsService());
  locator.registerSingleton<SettingsController>(SettingsController());
}
