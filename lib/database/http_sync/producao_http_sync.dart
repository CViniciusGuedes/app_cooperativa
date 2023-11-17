import 'package:app_cooperativa/database/producaoDB.dart';
import '../../core/utils/http_utils.dart';

class ProducaoHttpSync {
  static Future<List<Producao>> get() async {
    final List<Map<String, dynamic>> response = await HttpUtils.get<Producao>(url: '/producoes');
    final List<Producao> producoes = response.map((producaoJson) => Producao.fromMap(producaoJson)).toList();
    return producoes;
  }

  static Future<Producao> post({required Producao producao}) async {
    final Map<String, dynamic> response = await HttpUtils.post<Producao>(url: '/producoes', body: producao);
    final Producao producaoInserida = Producao.fromMap(response);

    return producaoInserida;
  }

  static Future<Producao> put({required Producao producao}) async {
    final Map<String, dynamic> response = await HttpUtils.put<Producao>(url: '/producoes/${producao.nome}', body: producao);
    final Producao producaoInserida = Producao.fromMap(response);

    return producaoInserida;
  }

  static Future<Producao> delete(String nome) async {
    final Map<String, dynamic> response = await HttpUtils.delete(url: '/producoes/$nome');
    final Producao producaoRemovido = Producao.fromMap(response);

    return producaoRemovido;
  }
}
