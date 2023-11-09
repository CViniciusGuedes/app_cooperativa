import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/propriedadeDB.dart';
import 'package:sqflite/sqflite.dart';

class PropriedadeRepository {
  final DatabaseHelper _databaseHelper;

  PropriedadeRepository(this._databaseHelper);

  Future<int> addAll(List<Propriedade> propriedades) async {
    int result = 0;
    final Database database = await _databaseHelper.init();
    for (final propriedade in propriedades) {
      result = await database.insert('Propriedade', propriedade.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  add(Propriedade propriedade) async {
    final database = await _databaseHelper.init();
    final raw = await database.insert(
      'Propriedade',
      propriedade.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  update(Propriedade propriedade) async {
    final database = await _databaseHelper.init();
    final response = await database.update('Propriedade', propriedade.toMap(), where: 'id = ?', whereArgs: [propriedade.id]);
    return response;
  }

  Future<List<Propriedade>> findAll() async {
    final database = await _databaseHelper.init();
    final response = await database.query('Propriedade');
    List<Propriedade> list = response.map((propriedade) => Propriedade.fromMap(propriedade)).toList();
    return list;
  }

  Future<Propriedade?> findById(String id) async {
    final database = await _databaseHelper.init();
    final response = await database.query('Propriedade', where: 'id = ?', whereArgs: [id]);
    return response.isNotEmpty ? Propriedade.fromMap(response.first) : null;
  }

  deleteAll() async {
    final database = await _databaseHelper.init();
    database.delete('Propriedade');
  }

  deleteById(String id) async {
    final database = await _databaseHelper.init();
    return database.delete('Propriedade', where: 'id = ?', whereArgs: [id]);
  }
}
