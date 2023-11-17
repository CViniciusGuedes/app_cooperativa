import 'package:uuid/uuid.dart';
import 'package:app_cooperativa/database/uuid_utils.dart';

import '../core/models/abstract_entity.dart';

const uuid = Uuid();

class Propriedade implements AbstractEntity<Propriedade> {
  final String? id;
  final String nome;
  final String endereco;
  final String bairro;
  final String cidade;
  final String uf;
  final String area;

  Propriedade({
    String? id,
    required this.nome,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.area,
  }) : id = id ?? UuidUtils.simplify(uuid.v4());

  factory Propriedade.fromMap(Map<String, dynamic> record) => Propriedade(
        id: record['id'],
        nome: record['nome'],
        endereco: record['endereco'],
        bairro: record['bairro'],
        cidade: record['cidade'],
        uf: record['uf'],
        area: record['area'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'endereco': endereco,
        'bairro': bairro,
        'cidade': cidade,
        'uf': uf,
        'area': area,
      };

  @override
  String toString() {
    return '$id - $nome - $endereco - $bairro - $cidade - $uf - $area';
  }
}
