import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal() {
    if (_database == null) database;
  }

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    return await openDatabase(join(await getDatabasesPath(), 'app_cooperativa.db'), version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Propriedade ('
          'id TEXT PRIMARY KEY,'
          'nome TEXT,'
          'endereco TEXT,'
          'bairro TEXT,'
          'cidade TEXT,'
          'uf TEXT,'
          'area TEXT'
          // 'tipoSolo TEXT' //tirar
          ')');

      await db.execute('CREATE TABLE Cooperado ('
          'id TEXT PRIMARY KEY,'
          'nome TEXT,'
          'cpf TEXT,'
          'email TEXT,'
          'celular TEXT,'
          'cep TEXT,'
          'estado TEXT,'
          'cidade TEXT,'
          'logradouro TEXT,'
          'numero TEXT,'
          'bairro TEXT'
          ')');

      await db.execute('CREATE TABLE Producao ('
          'id TEXT PRIMARY KEY,'
          'nome TEXT,'
          'descricao TEXT,'
          'preco TEXT,'
          'tipo TEXT'
          ')');
    });
  }
}
