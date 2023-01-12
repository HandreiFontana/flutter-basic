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

  // list

  Future<Map<String, dynamic>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _cidades.clear();

    final url =
        '${AppConstants.apiUrl}/cidades?page=$page&pageSize=$rowsPerPage&search=$search';

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

  // delete

  Future<void> delete(Cidade cidade) async {
    int index = _cidades.indexWhere((p) => p.id == cidade.id);

    if (index >= 0) {
      final cidade = _cidades[index];
      _cidades.remove(cidade);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${AppConstants.apiUrl}/cidades/${cidade.id}'),
      );

      if (response.statusCode >= 400) {
        _cidades.insert(index, cidade);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o registro.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
