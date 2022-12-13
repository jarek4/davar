class DbConsts {
  static const String dbName = 'davar_database';
  static const int dbVersion = 1;

  // tables
  static const String tableWords = 'words';
  static const String tableUsers = 'users';
  static const String tableWordCategories = 'word_categories';

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
  static const String colWCategoryId = 'categoryId';
  static const String colWClue = 'clue';
  static const String colWUserTransl = 'userTranslation';
  static const String colWCatchword = 'catchword';
  static const String colWIsFavorite = 'isFavorite';
  static const String colWIsSentence = 'isSentence';
  static const String colWUserLearn = 'userLearning';
  static const String colWUserNative = 'userNative';
  static const String colWPoints = 'points';
  static const String colWUserId = 'userId';

  //word_categories table columns (fields)
  static const String colCUserId = 'userId';
  static const String colCName = 'name';

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String intNotNullType = 'INTEGER NOT NULL';
  static const String intType = 'INTEGER';
  static const String intTypeDefault0 = 'INTEGER DEFAULT 0';
  static const String txtNotNullType = 'TEXT NOT NULL';
  static const String txtType = 'TEXT';
  static const String txtTypeDefaultNull = 'TEXT DEFAULT NULL';
  static const String timeStampType = 'TEXT DEFAULT CURRENT_TIMESTAMP';

// QUERIES:

  // create tables:
  static const String createWordCategoriesTableStatement =
      '''CREATE TABLE IF NOT EXISTS $tableWordCategories (
  $colId $idType, 
  $colCName $txtType, 
  $colCUserId $intType DEFAULT 1, 
  FOREIGN KEY ($colCUserId) 
  REFERENCES $tableUsers ($colId) 
  ON UPDATE NO ACTION 
  ON DELETE SET DEFAULT
  )''';

  static const String createWordsTableStatement = '''CREATE TABLE IF NOT EXISTS $tableWords (
 $colWCategory $txtType,
      $colWCategoryId $intType DEFAULT 1,
      $colCreated $timeStampType,
      $colWClue $txtType,
      $colId $idType,
      $colWUserTransl $txtType,
      $colWCatchword $txtNotNullType,
      $colWIsFavorite $intTypeDefault0,
      $colWIsSentence  $intTypeDefault0,
      $colWUserLearn $txtType,
      $colWUserNative $txtType,
      $colWPoints $intType,
      $colWUserId $intType DEFAULT 1,
      FOREIGN KEY ($colWUserId) 
      REFERENCES $tableUsers ($colId) 
      ON UPDATE NO ACTION 
      ON DELETE SET DEFAULT,
      FOREIGN KEY ($colWCategoryId) 
      REFERENCES $tableWordCategories ($colId) 
      ON UPDATE NO ACTION 
      ON DELETE SET DEFAULT
      )''';

  static const String createUsersTableStatement = '''CREATE TABLE IF NOT EXISTS $tableUsers (
      $colId $idType, 
      $colUEmail $txtType, 
      $colCreated $timeStampType, 
      $colULearning $txtNotNullType, 
      $colUName $txtType, 
      $colUNative $txtNotNullType, 
      $colUPwd $txtType, 
      $colUToken $txtType
      )''';

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
    colWCategoryId,
    colCreated,
    colWClue,
    colId,
    colWUserTransl,
    colWCatchword,
    colWIsFavorite,
    colWIsSentence,
    colWUserLearn,
    colWUserNative,
    colWPoints,
    colWUserId
  ];
  static const List<String> wordsColumnsWithoutId = [
    colWCategoryId,
    colCreated,
    colWClue,
    colWUserTransl,
    colWCatchword,
    colWIsFavorite,
    colWIsSentence,
    colWUserLearn,
    colWUserNative,
    colWPoints,
    colWUserId
  ];
  static const List<String> allWordCategoriesColumns = [colId, colCUserId, colCName];

  ///commonNoCategory = {'id': 1, 'userId': 1, 'name': 'no category'} emptyUser.id == 1
  static const Map<String, dynamic> commonNoCategory = {
    colId: 1,
    colCUserId: 1,
    colCName: 'no category',
  };

  /// Select * From words Left Join Where words.userId=?
  static const String selectAllFromTableWords = '''
      SELECT
          ${DbConsts.colWCatchword}, 
          ${DbConsts.tableWords}.${DbConsts.colId},
          ${DbConsts.tableWords}.${DbConsts.colWUserId},
          ${DbConsts.colWUserTransl},
          ${DbConsts.colCName} AS ${DbConsts.colWCategory},
          ${DbConsts.colWCategoryId},
          ${DbConsts.colWIsFavorite},
          ${DbConsts.colWIsSentence},
          ${DbConsts.colWPoints},
          ${DbConsts.colWUserLearn},
          ${DbConsts.colWUserNative},
          ${DbConsts.colWClue},
          ${DbConsts.colCreated}
      FROM
          ${DbConsts.tableWords}
      LEFT JOIN ${DbConsts.tableWordCategories} ON
          ${DbConsts.tableWords}.${DbConsts.colWCategoryId} = ${DbConsts.tableWordCategories}.${DbConsts.colId} 
      WHERE
          ${DbConsts.tableWords}.${DbConsts.colWUserId}=?''';
}
