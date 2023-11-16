import 'dart:convert';
import 'package:app_cooperativa/config/constants.dart';
import 'package:app_cooperativa/core/models/abstract_entity.dart';
import 'package:http/http.dart' as http;

const Map<String, dynamic> DEFAULT_HEADERS = {'Accept': 'application/json', 'content-type': 'application/json'};

abstract class HttpUtils {
  static Future<List<Map<String, dynamic>>> get<T extends AbstractEntity>({required String url, Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse(Constants.API_URL + url),
      headers: {...?headers, ...DEFAULT_HEADERS},
    );
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          (json.decode(utf8.decode(response.bodyBytes))["items"] as List).map((e) => e as Map<String, dynamic>).toList();

      return data;
    } else {
      throw Exception('Falha ao carregar os dados');
    }
  }

  static Future<Map<String, dynamic>> post<T extends AbstractEntity>({required String url, required T body, Map<String, String>? headers}) async {
    final response = await http.post(Uri.parse(Constants.API_URL + url), headers: {...?headers, ...DEFAULT_HEADERS}, body: json.encode(body.toMap()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> item = json.decode(utf8.decode(response.bodyBytes));
      return item;
    } else {
      throw Exception('Falha ao salvar os dados');
    }
  }

  static Future<Map<String, dynamic>> put<T extends AbstractEntity>({required String url, required T body, Map<String, String>? headers}) async {
    final response = await http.put(Uri.parse(Constants.API_URL + url), headers: {...?headers, ...DEFAULT_HEADERS}, body: json.encode(body.toMap()));
    if (response.statusCode == 200) {
      final Map<String, dynamic> item = json.decode(utf8.decode(response.bodyBytes));
      return item;
    } else {
      throw Exception('Falha ao atualizar os dados');
    }
  }

  static Future<Map<String, dynamic>> delete<T extends AbstractEntity>({required String url, Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse(Constants.API_URL + url),
      headers: {...?headers, ...DEFAULT_HEADERS},
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      final Map<String, dynamic> item = json.decode(utf8.decode(response.bodyBytes));
      return item;
    } else {
      throw Exception('Falha ao carregar os dados');
    }
  }
}
