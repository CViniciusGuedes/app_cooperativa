import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/cadastro_cooperadoDB.dart';
import 'package:sqflite/sqflite.dart';

class CooperadoRepository {
  final DatabaseHelper _databaseHelper;

  CooperadoRepository(this._databaseHelper);

  Future<int> addAll(List<Cooperado> cooperados) async {
    int result = 0;
    final Database database = await _databaseHelper.init();
    for (final cooperado in cooperados) {
      result = await database.insert('Cooperado', cooperado.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  add(Cooperado cooperado) async {
    final database = await _databaseHelper.init();
    final raw = await database.insert(
      'Cooperado',
      cooperado.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  update(Cooperado cooperado) async {
    final database = await _databaseHelper.init();
    final response = await database.update('Cooperado', cooperado.toMap(),
        where: 'id = ?', whereArgs: [cooperado.id]);
    return response;
  }

  Future<List<Cooperado>> findAll() async {
    final database = await _databaseHelper.init();
    final response = await database.query('Cooperado');
    List<Cooperado> list =
        response.map((cooperado) => Cooperado.fromMap(cooperado)).toList();
    return list;
  }

  Future<Cooperado?> findById(String id) async {
    final database = await _databaseHelper.init();
    final response =
        await database.query('Cooperado', where: 'id = ?', whereArgs: [id]);
    return response.isNotEmpty ? Cooperado.fromMap(response.first) : null;
  }

  deleteAll() async {
    final database = await _databaseHelper.init();
    database.delete('Cooperado');
  }

  deleteById(String id) async {
    final database = await _databaseHelper.init();
    return database.delete('Cooperado', where: 'id = ?', whereArgs: [id]);
  }
}
