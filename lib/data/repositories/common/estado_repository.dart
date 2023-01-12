import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:basic/shared/exceptions/http_exception.dart';
import 'package:basic/shared/config/app_constants.dart';
import 'package:basic/domain/models/common/estado.dart';

class EstadoRepository with ChangeNotifier {
  final String _token;
  final List<Estado> _estados;

  List<Estado> get items => [..._estados];

  int get itemsCount {
    return _estados.length;
  }

  EstadoRepository([
    this._token = '',
    this._estados = const [],
  ]);

  // list

  Future<Map<String, dynamic>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _estados.clear();

    final url =
        '${AppConstants.apiUrl}/estados?page=$page&pageSize=$rowsPerPage&search=$search';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    data['items'].forEach((estadoData) {
      _estados.add(
        Estado(
          id: estadoData['id'],
          nome: estadoData['nome'],
          uf: estadoData['uf'],
        ),
      );
    });

    notifyListeners();

    return data;
  }

  // delete

  Future<void> delete(Estado estado) async {
    int index = _estados.indexWhere((p) => p.id == estado.id);

    if (index >= 0) {
      final estado = _estados[index];
      _estados.remove(estado);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${AppConstants.apiUrl}/estados/${estado.id}'),
      );

      if (response.statusCode >= 400) {
        _estados.insert(index, estado);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o registro.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
