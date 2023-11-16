import 'package:uuid/uuid.dart';
import 'package:app_cooperativa/database/uuid_utils.dart';

import '../core/models/abstract_entity.dart';

const uuid = Uuid();

class Cooperado implements AbstractEntity<Cooperado> {
  final String? id;
  final String nome;
  final String cpf;
  final String email;
  final String celular;
  final String cep;
  final String estado;
  final String cidade;
  final String logradouro;
  final String numero;
  final String bairro;

  Cooperado({
    String? id,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.celular,
    required this.cep,
    required this.estado,
    required this.cidade,
    required this.logradouro,
    required this.numero,
    required this.bairro,
  }) : id = id ?? UuidUtils.simplify(uuid.v4());

  factory Cooperado.fromMap(Map<String, dynamic> record) => Cooperado(
        id: record['id'],
        nome: record['nome'],
        cpf: record['cpf'],
        email: record['email'],
        celular: record['celular'],
        cep: record['cep'],
        estado: record['estado'],
        cidade: record['cidade'],
        logradouro: record['logradouro'],
        numero: record['numero'],
        bairro: record['bairro'],
      );
  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'cpf': cpf,
        'email': email,
        'celular': celular,
        'cep': cep,
        'estado': estado,
        'cidade': cidade,
        'logradouro': logradouro,
        'numero': numero,
        'bairro': bairro,
      };

  @override
  String toString() {
    return '$id - $nome - $cpf - $email - $celular - $cep - $estado - $cidade - $logradouro - $numero - $bairro';
  }
}
