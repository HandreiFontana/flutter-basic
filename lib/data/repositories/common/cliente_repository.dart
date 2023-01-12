import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:basic/shared/exceptions/http_exception.dart';
import 'package:basic/shared/config/app_constants.dart';
import 'package:basic/domain/models/common/cliente.dart';

class ClienteRepository with ChangeNotifier {
  final String _token;
  final List<Cliente> _clientes;

  List<Cliente> get items => [..._clientes];

  int get itemsCount {
    return _clientes.length;
  }

  ClienteRepository([
    this._token = '',
    this._clientes = const [],
  ]);

  // list

  Future<Map<String, dynamic>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _clientes.clear();

    final url =
        '${AppConstants.apiUrl}/clientes?page=$page&pageSize=$rowsPerPage&search=$search';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    data['items'].forEach((clienteData) {
      _clientes.add(
        Cliente(
          id: clienteData['id'],
          nome: clienteData['nome'],
        ),
      );
    });

    notifyListeners();

    return data;
  }

  // delete

  Future<void> delete(Cliente cliente) async {
    int index = _clientes.indexWhere((p) => p.id == cliente.id);

    if (index >= 0) {
      final cliente = _clientes[index];
      _clientes.remove(cliente);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${AppConstants.apiUrl}/clientes/${cliente.id}'),
      );

      if (response.statusCode >= 400) {
        _clientes.insert(index, cliente);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o registro.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
