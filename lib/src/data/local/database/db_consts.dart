class DbConsts {

  static const String name = 'davar.db';
  static const int  version = 1;

  // tables
  static const String tableWords = 'words';
  static const String tableUsers = 'users';

  //common table columns (fields)
  static const String colCreated = 'createdAt';
  static const String colId = 'id';
  //users table columns (fields)

  static const String colUEmail = 'email';
  static const String colULearning = 'learning';
  static const String colUName = 'name';
  static const String colUNative = 'native';
  static const String colUPwd = 'password';
  static const String colUToken = 'authToken';

  //words table columns (fields)
  static const String colWCategory = 'category';
  static const String colWClue = 'clue';
  static const String colWUserTransl = 'userTranslation';
  static const String colWCatchword = 'catchword';
  static const String colWIsFavorite = 'isFavorite';
  static const String colIsSentence = 'isSentence';
  static const String colWUserLearn = 'userLearning';
  static const String colWUserNative = 'userNative';
  static const String colWPoints = 'points';
  static const String colWUserId = 'userId';

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String intNotNullType = 'INTEGER NOT NULL';
  static const String intType = 'INTEGER';
  static const String intTypeDefault0 = 'INTEGER  DEFAULT 0';
  static const String txtNotNullType = 'TEXT NOT NULL';
  static const String txtType = 'TEXT';
  static const String txtTypeDefaultNull = 'TEXT DEFAULT NULL';
  static const String timeStampType = 'TEXT DEFAULT CURRENT_TIMESTAMP';

// QUERIES:

  // create tables:
  static const String createWordsTableStatement =
  '''CREATE TABLE $tableWords ($colWCategory $txtType, $colCreated $timeStampType, $colWClue $txtType, $colId $idType, $colWUserTransl, $txtType, $colWCatchword $txtNotNullType, $colWIsFavorite $intTypeDefault0, $colIsSentence  $intTypeDefault0, $colWUserLearn $txtType, $colWUserNative $txtType, $colWPoints $intType, $colWUserId $txtType)''';

  static const String createUsersTableStatement =
  '''CREATE TABLE $tableUsers ($colId $idType, $colUEmail $txtType, $colCreated $timeStampType, $colULearning $txtNotNullType, $colUName $txtType, $colUNative $txtNotNullType, $colUPwd $txtType, $colUToken $txtType)''';

  static const List<String> allUsersColumns = [
    colId,
    colUEmail,
    colCreated,
    colULearning,
    colUName,
    colUNative,
    colUPwd,
    colUToken,
  ];
  static const List<String> allWordsColumns = [
    colWCategory,
    colCreated,
    colWClue,
    colId,
    colWUserTransl,
    colWCatchword,
    colWIsFavorite,
    colIsSentence,
    colWUserLearn,
    colWUserNative,
    colWPoints,
    colWUserId
  ];
  static const List<String> wordsColumnsWithoutId = [
    colWCategory,
    colCreated,
    colWClue,
    colWUserTransl,
    colWCatchword,
    colWIsFavorite,
    colIsSentence,
    colWUserLearn,
    colWUserNative,
    colWPoints,
    colWUserId
  ];
}