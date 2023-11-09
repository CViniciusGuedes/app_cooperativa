import 'package:app_cooperativa/database/database_helper.dart';
import 'package:app_cooperativa/database/cadastro_usuarioDB.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioRepository {
  final DatabaseHelper _databaseHelper;

  UsuarioRepository(this._databaseHelper);

  Future<int> addAll(List<Usuario> usuarios) async {
    int result = 0;
    final Database database = await _databaseHelper.init();
    for (final usuario in usuarios) {
      result = await database.insert('Usuario', usuario.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  add(Usuario usuario) async {
    final database = await _databaseHelper.init();
    final raw = await database.insert(
      'Usuario',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  update(Usuario usuario) async {
    final database = await _databaseHelper.init();
    final response = await database.update('Usuario', usuario.toMap(), where: 'id = ?', whereArgs: [usuario.id]);
    return response;
  }

  Future<List<Usuario>> findAll() async {
    final database = await _databaseHelper.init();
    final response = await database.query('Usuario');
    List<Usuario> list = response.map((usuario) => Usuario.fromMap(usuario)).toList();
    return list;
  }

  Future<Usuario?> findById(String id) async {
    final database = await _databaseHelper.init();
    final response = await database.query('Usuario', where: 'id = ?', whereArgs: [id]);
    return response.isNotEmpty ? Usuario.fromMap(response.first) : null;
  }

  deleteAll() async {
    final database = await _databaseHelper.init();
    database.delete('Usuario');
  }

  deleteById(String id) async {
    final database = await _databaseHelper.init();
    return database.delete('Usuario', where: 'id = ?', whereArgs: [id]);
  }
}
