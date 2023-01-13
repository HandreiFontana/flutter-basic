import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:basic/shared/exceptions/http_exception.dart';
import 'package:basic/shared/config/app_constants.dart';
import 'package:basic/domain/models/common/cidade.dart';

class CidadeRepository with ChangeNotifier {
  final String _token;
  final List<Cidade> _cidades;

  List<Cidade> get items => [..._cidades];

  int get itemsCount {
    return _cidades.length;
  }

  CidadeRepository([
    this._token = '',
    this._cidades = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, String?> data,
  ) async {
    const url = '${AppConstants.apiUrl}/cidades';

    if (data['id'] == '') {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    }

    final response = await http.put(
      Uri.parse('$url/${data['id']!}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // list

  Future<Map<String, dynamic>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _cidades.clear();

    final url = '${AppConstants.apiUrl}/cidades?page=$page&pageSize=$rowsPerPage&search=$search';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    data['items'].forEach((cidadeData) {
      _cidades.add(
        Cidade(
          id: cidadeData['id'],
          nome: cidadeData['nome'],
          estadoId: cidadeData['estadoId'],
          estadoUf: cidadeData['estadoUf'],
        ),
      );
    });

    notifyListeners();

    return data;
  }

  // get

  Future<Cidade> get(String id) async {
    Cidade estado = Cidade();

    final url = '${AppConstants.apiUrl}/cidades/$id';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      estado.id = data['id'];
      estado.nome = data['nome'];
      estado.estadoId = data['estadoId'];
      estado.estadoUf = data['estadoUf'];
    }

    return estado;
  }

  // delete

  Future<String> delete(Cidade cidade) async {
    int index = _cidades.indexWhere((p) => p.id == cidade.id);

    if (index >= 0) {
      final cidade = _cidades[index];
      _cidades.remove(cidade);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/cidades/${cidade.id}';

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode >= 400) {
        _cidades.insert(index, cidade);
        notifyListeners();

        return jsonDecode(response.body)['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
