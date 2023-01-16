// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:basic/domain/models/common/user.dart';
import 'package:basic/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRepository with ChangeNotifier {
  final String _token;
  final List<User> _users;

  List<User> get items => [..._users];

  int get itemsCount {
    return _users.length;
  }

  UserRepository([
    this._token = '',
    this._users = const [],
  ]);

  Future<bool> verificaSenha(String id, String senha) async {
    const url = '${AppConstants.apiUrl}/users-security/validate-admin';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({"userId": id, "password": senha}),
    );
    if (response.statusCode != 204) {
      return false;
    }
    return true;
  }

  Future<bool> resetaSenha(String senha, String tokenReset) async {
    final url = '${AppConstants.apiUrl}/passwords/reset?token=$tokenReset';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"password": senha}),
    );

    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }

  Future<String> confirmaReset(Map dados) async {
    const url = '${AppConstants.apiUrl}/passwords/verify';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "login": dados['login'],
        "cpfCnpj": dados['cpfCnpj'],
      }),
    );

    Map data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return '';
    }
    return data['data']['token'];
  }
}
