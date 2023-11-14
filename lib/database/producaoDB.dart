import 'package:uuid/uuid.dart';
import 'package:app_cooperativa/database/uuid_utils.dart';

const uuid = Uuid();

class Producao {
  final String? id;
  final String nome;
  final String descricao;
  final String preco;
  final String tipo;

  Producao({
    String? id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.tipo,
  }) : id = id ?? UuidUtils.simplify(uuid.v4());

  factory Producao.fromMap(Map<String, dynamic> record) => Producao(
        id: record['id'],
        nome: record['nome'],
        descricao: record['descricao'],
        preco: record['preco'],
        tipo: record['tipo'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'tipo': tipo,
      };

  @override
  String toString() {
    return '$id - $nome - $descricao - $preco - $tipo';
  }
}
