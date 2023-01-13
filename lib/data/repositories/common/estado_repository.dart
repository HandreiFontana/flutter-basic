import 'dart:convert';
import 'package:basic/domain/models/shared/suggestionSelect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  // Save

  Future<bool> save(
    Map<String, String?> data,
  ) async {
    const url = '${AppConstants.apiUrl}/estados';

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
    _estados.clear();

    final url = '${AppConstants.apiUrl}/estados?page=$page&pageSize=$rowsPerPage&search=$search';

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

  // get

  Future<Estado> get(String id) async {
    Estado estado = Estado();

    final url = '${AppConstants.apiUrl}/estados/$id';

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
      estado.uf = data['uf'];
    }

    return estado;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/estados/select?filter=$search';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    List<SuggestionModelSelect> suggestions = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      suggestions = List<SuggestionModelSelect>.from(
        data['items'].map((model) => SuggestionModelSelect.fromJson(model)),
      );
    }

    return Future.value(
      suggestions
          .map(
            (e) => {
              'value': e.value,
              'label': e.label,
            },
          )
          .toList(),
    );
  }

  // delete

  Future<String> delete(Estado estado) async {
    int index = _estados.indexWhere((p) => p.id == estado.id);

    if (index >= 0) {
      final estado = _estados[index];
      _estados.remove(estado);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/estados/${estado.id}';

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode != 200) {
        _estados.insert(index, estado);
        notifyListeners();

        return jsonDecode(response.body)['message'];
      }

      return 'Sucesso';
    }

    return 'Item não encontrado';
  }
}
