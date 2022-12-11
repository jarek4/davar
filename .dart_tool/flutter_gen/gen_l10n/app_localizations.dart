import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('en'),
    Locale('pl'),
    Locale('ru'),
    Locale('tr')
  ];

  /// translation
  ///
  /// In en, this message translates to:
  /// **'translation'**
  String get addTranslation;

  /// you learn
  ///
  /// In en, this message translates to:
  /// **'you learn'**
  String get authLearn;

  /// want to log out?
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to logout?'**
  String get authLogout;

  /// No description provided for @authName.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get authName;

  /// No description provided for @authYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'your language'**
  String get authYourLanguage;

  /// click ad
  ///
  /// In en, this message translates to:
  /// **'Support my app by clicking this ad'**
  String get clickAdToSupport;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// field cannt be empty
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get fieldNotEmpty;

  /// elemet to add
  ///
  /// In en, this message translates to:
  /// **'Which element you want to add at the beginning of the main list'**
  String get listAddListTop;

  /// No description provided for @listEmpty.
  ///
  /// In en, this message translates to:
  /// **'Maybe your word\'s list is empty'**
  String get listEmpty;

  /// No description provided for @listSearch.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get listSearch;

  /// loading
  ///
  /// In en, this message translates to:
  /// **'Loading ... wait…'**
  String get loading;

  /// No description provided for @moreAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Add new category'**
  String get moreAddCategory;

  /// info
  ///
  /// In en, this message translates to:
  /// **'more information'**
  String get moreInfo;

  /// No description provided for @moreManageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage categories. Add new one, delete or edit.'**
  String get moreManageCategories;

  /// add new sentence
  ///
  /// In en, this message translates to:
  /// **'New sentence'**
  String get newSentence;

  /// add new word
  ///
  /// In en, this message translates to:
  /// **'New word'**
  String get newWord;

  /// no data
  ///
  /// In en, this message translates to:
  /// **'Data is unavailable'**
  String get noData;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing was found'**
  String get nothingFound;

  /// No description provided for @pageAddClue.
  ///
  /// In en, this message translates to:
  /// **'clue'**
  String get pageAddClue;

  /// add words number
  ///
  /// In en, this message translates to:
  /// **'Add at least: {num} more to play.'**
  String get quizAddAtLeast;

  /// until now numbers of words
  ///
  /// In en, this message translates to:
  /// **'Until now you have been added {num} words'**
  String get quizAdded;

  /// how to play
  ///
  /// In en, this message translates to:
  /// **'how to play'**
  String get quizHow;

  /// how to play quiz
  ///
  /// In en, this message translates to:
  /// **'Your task is to choose the correct answer. You can win up to 3 points if your first choice is correct.  If you guess the second time you get 2 points.'**
  String get quizManual1;

  /// how to play quiz
  ///
  /// In en, this message translates to:
  /// **'If you have added a clue to the word,  you will be able to use it. But it will takes 1 point. The number of the points of a particular word will be increased accordingly.'**
  String get quizManual2;

  /// sentence
  ///
  /// In en, this message translates to:
  /// **'sentence'**
  String get sentence;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackup;

  /// No description provided for @settingsBackupAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention! If you import any data from a file, all current words and sentences will be replaced.'**
  String get settingsBackupAttention;

  /// dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get settingsDark;

  /// backup copy
  ///
  /// In en, this message translates to:
  /// **'Export backup copy'**
  String get settingsExport;

  /// data to file
  ///
  /// In en, this message translates to:
  /// **'You can export all your data to the file'**
  String get settingsExportTo;

  /// backup copy
  ///
  /// In en, this message translates to:
  /// **'Import backup copy'**
  String get settingsImport;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// light mode
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get settingsLight;

  /// light/dark theme
  ///
  /// In en, this message translates to:
  /// **'Light/Dark mode'**
  String get settingsMode;

  /// quiz score
  ///
  /// In en, this message translates to:
  /// **'The highest quiz score.'**
  String get statsQuizScore;

  /// refresh
  ///
  /// In en, this message translates to:
  /// **'refresh'**
  String get statsRefresh;

  /// all sentences
  ///
  /// In en, this message translates to:
  /// **'all sentences'**
  String get statsSentences;

  /// last update
  ///
  /// In en, this message translates to:
  /// **'last update'**
  String get statsUpdate;

  /// words
  ///
  /// In en, this message translates to:
  /// **'all words'**
  String get statsWords;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// wait
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get wait;

  /// word
  ///
  /// In en, this message translates to:
  /// **'word'**
  String get word;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bg', 'en', 'pl', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg': return AppLocalizationsBg();
    case 'en': return AppLocalizationsEn();
    case 'pl': return AppLocalizationsPl();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
