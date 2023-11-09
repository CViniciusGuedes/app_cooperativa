import 'package:uuid/uuid.dart';
import 'package:app_cooperativa/database/uuid_utils.dart';

const uuid = Uuid();

class Propriedade {
  final String? id;
  final String nome;
  final String endereco;
  final String bairro;
  final String cidade;
  final String uf;
  final String area;
  final String tipoSolo;

  Propriedade({
    String? id,
    required this.nome,
    required this.endereco,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.area,
    required this.tipoSolo,
  }) : id = id ?? UuidUtils.simplify(uuid.v4());

  factory Propriedade.fromMap(Map<String, dynamic> record) => Propriedade(
        id: record['id'],
        nome: record['nome'],
        endereco: record['endereco'],
        bairro: record['bairro'],
        cidade: record['cidade'],
        uf: record['uf'],
        area: record['area'],
        tipoSolo: record['tipoSolo'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'endereco': endereco,
        'bairro': bairro,
        'cidade': cidade,
        'uf': uf,
        'area': area,
        'tipoSolo': tipoSolo,
      };

  @override
  String toString() {
    return '$id - $nome - $endereco - $bairro - $cidade - $uf - $area - $tipoSolo';
  }
}
