import 'package:app_cooperativa/database/cadastro_cooperadoDB.dart';
import '../../core/utils/http_utils.dart';

class CooperadoHttpSync {
  static Future<List<Cooperado>> get() async {
    final List<Map<String, dynamic>> response = await HttpUtils.get<Cooperado>(url: '/public/cadastro');
    final List<Cooperado> cooperados = response.map((cooperadoJson) => Cooperado.fromMap(cooperadoJson)).toList();
    return cooperados;
  }

  static Future<Cooperado> post({required Cooperado cooperado}) async {
    final Map<String, dynamic> response = await HttpUtils.post<Cooperado>(url: '/public/cadastro', body: cooperado);
    final Cooperado cooperadoInserido = Cooperado.fromMap(response);

    return cooperadoInserido;
  }

  static Future<Cooperado> put({required Cooperado cooperado}) async {
    final Map<String, dynamic> response = await HttpUtils.put<Cooperado>(url: '/public/cadastro/${cooperado.cpf}', body: cooperado);
    final Cooperado cooperadoInserido = Cooperado.fromMap(response);

    return cooperadoInserido;
  }

  static Future<Cooperado> delete(String cpf) async {
    final Map<String, dynamic> response = await HttpUtils.delete(url: '/public/cadastro/$cpf');
    final Cooperado cooperadoRemovido = Cooperado.fromMap(response);

    return cooperadoRemovido;
  }
}
