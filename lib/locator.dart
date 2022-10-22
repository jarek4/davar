import 'package:davar/src/data/local/database/word_categories_db.dart';
import 'package:davar/src/data/local/database/words_db.dart';
import 'package:davar/src/data/local/secured.dart';
import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/data/repositories/authentication_repository.dart';
import 'package:davar/src/data/repositories/word_categories_repository.dart';
import 'package:davar/src/domain/i_authentication_repository.dart';
import 'package:davar/src/domain/i_secure_storage.dart';
import 'package:davar/src/domain/i_user_local_db.dart';
import 'package:davar/src/domain/i_word_categories_repository.dart';
import 'package:davar/src/domain/i_words_local_db.dart';
import 'package:davar/src/domain/i_words_repository.dart';
import 'package:davar/src/settings/settings_controller.dart';
import 'package:davar/src/settings/settings_service.dart';
import 'package:get_it/get_it.dart';

import 'src/data/local/database/auth_db.dart';
import 'src/data/local/database/db.dart';
import 'src/data/repositories/words_repository.dart';
import 'src/domain/i_word_categories_local_db.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // the order is important!
  locator.registerLazySingleton<ISecureStorage>(() => Secured());
  locator.registerLazySingleton<DB>(() => DB.instance);
  locator.registerLazySingleton<IUserLocalDb<Map<String, dynamic>>>(() => AuthDb());
  locator.registerLazySingleton<IWordCategoriesLocalDb<Map<String, dynamic>>>(
      () => WordCategoriesDb());
  locator.registerLazySingleton<IWordsLocalDb<Map<String, dynamic>>>(() => WordsDb());
  locator.registerSingleton<IAuthenticationRepository<User>>(AuthenticationRepository());
  locator.registerSingleton<SettingsService>(SettingsService());
  locator.registerSingleton<SettingsController>(SettingsController());
  locator.registerSingleton<IWordsRepository<Word>>(WordsRepository());
  locator.registerSingleton<IWordCategoriesRepository<WordCategory>>(WordCategoriesRepository());
}
