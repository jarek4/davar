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

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// You cannot try any more. Please register new user
  ///
  /// In en, this message translates to:
  /// **'You cannot try any more. Please register new user'**
  String get cannotTryNoMore;

  /// points
  ///
  /// In en, this message translates to:
  /// **'You can score:'**
  String get canScore;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get category;

  /// No description provided for @changePwd.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePwd;

  /// No description provided for @chooseLang.
  ///
  /// In en, this message translates to:
  /// **'Please choose language'**
  String get chooseLang;

  /// click ad
  ///
  /// In en, this message translates to:
  /// **'Support my app by clicking this ad'**
  String get clickAdToSupport;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get close;

  /// No description provided for @clue.
  ///
  /// In en, this message translates to:
  /// **'clue'**
  String get clue;

  /// No description provided for @clueNotAdded.
  ///
  /// In en, this message translates to:
  /// **'clue not added'**
  String get clueNotAdded;

  /// No description provided for @confirmDeleteWord.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to delete this word?'**
  String get confirmDeleteWord;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'created at'**
  String get createdAt;

  /// No description provided for @createLearningProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your learning profile'**
  String get createLearningProfile;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @doFillFields.
  ///
  /// In en, this message translates to:
  /// **'Do you filled all fields'**
  String get doFillFields;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get edit;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get error;

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

  /// Forgot password?
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPwd;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'invalid email'**
  String get invalidEmail;

  /// Invalid password! Example:
  ///
  /// In en, this message translates to:
  /// **'Invalid password! Example:'**
  String get invalidPwd;

  /// language you want to learn
  ///
  /// In en, this message translates to:
  /// **'language you want to learn'**
  String get languageToLearn;

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

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

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

  /// New password
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPwd;

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

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// no data
  ///
  /// In en, this message translates to:
  /// **'Data is unavailable'**
  String get noData;

  /// No description provided for @noMoreToPlay.
  ///
  /// In en, this message translates to:
  /// **'No more word to play'**
  String get noMoreToPlay;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing was found'**
  String get nothingFound;

  /// No description provided for @notSaved.
  ///
  /// In en, this message translates to:
  /// **'not saved'**
  String get notSaved;

  /// quiz lose
  ///
  /// In en, this message translates to:
  /// **'Not this time'**
  String get notThisTime;

  /// delete
  ///
  /// In en, this message translates to:
  /// **'You cannot undo deleting'**
  String get noUndo;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// password
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get pwd;

  /// password is not strong
  ///
  /// In en, this message translates to:
  /// **'password is not strong'**
  String get pwdNotStrong;

  /// Reset password
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get pwdReset;

  /// Which language you learn?
  ///
  /// In en, this message translates to:
  /// **'Which language you learn?'**
  String get pwdResetWhichLang;

  /// No description provided for @pwdWasChanged.
  ///
  /// In en, this message translates to:
  /// **'Password was changed'**
  String get pwdWasChanged;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'quit'**
  String get quit;

  /// add words number
  ///
  /// In en, this message translates to:
  /// **'Add at least:'**
  String get quizAddAtLeast;

  /// until now numbers of words
  ///
  /// In en, this message translates to:
  /// **'Until now you have been added'**
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

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'remove'**
  String get remove;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'reset'**
  String get reset;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save your changes'**
  String get saveChanges;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'see more'**
  String get seeMore;

  /// log out hope to see you soon
  ///
  /// In en, this message translates to:
  /// **'Hope to see you soon'**
  String get seeYou;

  /// correct answer
  ///
  /// In en, this message translates to:
  /// **'Select the correct answer'**
  String get selectCorrect;

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

  /// No description provided for @someThingHappend.
  ///
  /// In en, this message translates to:
  /// **'something has happened'**
  String get someThingHappend;

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

  /// 1
  ///
  /// In en, this message translates to:
  /// **'takes 1 point'**
  String get takesPoint;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thankYou;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Please try again from the beginning
  ///
  /// In en, this message translates to:
  /// **'Please try again from the beginning'**
  String get tryFromBeginniing;

  /// wait
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get wait;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// word
  ///
  /// In en, this message translates to:
  /// **'word'**
  String get word;

  /// plural
  ///
  /// In en, this message translates to:
  /// **'words'**
  String get words;

  /// No description provided for @wordsQuiz.
  ///
  /// In en, this message translates to:
  /// **'Words Quiz'**
  String get wordsQuiz;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// points
  ///
  /// In en, this message translates to:
  /// **'You win'**
  String get youWin;
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
