// Stub file pour éviter les erreurs d'import sur web
class Database {
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs, int? limit, String? orderBy, List<String>? columns}) async => [];
  Future<int> insert(String table, Map<String, dynamic> values, {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) async => 0;
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs}) async => 0;
  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async => 0;
  Future<void> execute(String sql, [List<dynamic>? arguments]) async {}
  Batch batch() => Batch();
  Future<void> close() async {}
}

class Batch {
  void insert(String table, Map<String, dynamic> values, {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) {}
  Future<void> commit({bool? noResult}) async {}
}

class ConflictAlgorithm {
  static ConflictAlgorithm get replace => ConflictAlgorithm();
}

Future<String> getDatabasesPath() async => '';

Future<Database> openDatabase(String path, {int? version, Function(Database, int)? onCreate}) async {
  throw UnimplementedError('SQLite not available on web');
}
