import 'package:app_cooperativa/database/propriedadeDB.dart';
import '../../core/utils/http_utils.dart';

class PropriedadeHttpSync {
  static Future<List<Propriedade>> get() async {
    final List<Map<String, dynamic>> response = await HttpUtils.get<Propriedade>(url: '/public/propriedade');
    final List<Propriedade> propriedades = response.map((propriedadeJson) => Propriedade.fromMap(propriedadeJson)).toList();
    return propriedades;
  }

  static Future<Propriedade> post({required Propriedade propriedade}) async {
    final Map<String, dynamic> response = await HttpUtils.post<Propriedade>(url: '/public/propriedade', body: propriedade);
    final Propriedade propriedadeInserida = Propriedade.fromMap(response);

    return propriedadeInserida;
  }

  static Future<Propriedade> put({required Propriedade propriedade}) async {
    final Map<String, dynamic> response = await HttpUtils.put<Propriedade>(url: '/public/propriedade/${propriedade.nome}', body: propriedade);
    final Propriedade propriedadeInserida = Propriedade.fromMap(response);

    return propriedadeInserida;
  }

  static Future<Propriedade> delete(String nome) async {
    final Map<String, dynamic> response = await HttpUtils.delete(url: '/public/propriedade/$nome');
    final Propriedade propriedadeRemovida = Propriedade.fromMap(response);

    return propriedadeRemovida;
  }
}
