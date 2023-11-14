import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/producaoDB.dart';
import 'package:sqflite/sqflite.dart';

class ProducaoRepository {
  final DatabaseHelper _databaseHelper;

  ProducaoRepository(this._databaseHelper);

  Future<int> addAll(List<Producao> producoes) async {
    int result = 0;
    final Database database = await _databaseHelper.init();
    for (final producao in producoes) {
      result = await database.insert(
        'Producao',
        producao.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return result;
  }

  add(Producao producao) async {
    final database = await _databaseHelper.init();
    final raw = await database.insert(
      'Producao',
      producao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  update(Producao producao) async {
    final database = await _databaseHelper.init();
    final response = await database.update(
      'Producao',
      producao.toMap(),
      where: 'id = ?',
      whereArgs: [producao.id],
    );
  }

  Future<List<Producao>> findAll() async {
    final database = await _databaseHelper.init();
    final response = await database.query('Producao');
    List<Producao> list = response.map((producao) => Producao.fromMap(producao)).toList();
    return list;
  }

  Future<Producao?> findById(String id) async {
    final database = await _databaseHelper.init();
    final response = await database.query(
      'Producao',
      where: 'id = ?',
      whereArgs: [id],
    );
    return response.isNotEmpty ? Producao.fromMap(response.first) : null;
  }

  deleteAll() async {
    final database = await _databaseHelper.init();
    database.delete('Producao');
  }

  deleteById(String id) async {
    final database = await _databaseHelper.init();
    return database.delete(
      'Producao',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
