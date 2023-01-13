import 'package:flutter/cupertino.dart';

class Cliente {
  String? id;
  String? nome;
  String? estadoId;
  String? estadoUf;
  String? cidadeId;
  String? cidadeNome;

  Cliente({
    this.id,
    this.nome,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNome,
  });
}

class ClienteController {
  TextEditingController id;
  TextEditingController nome;
  TextEditingController estadoId;
  TextEditingController estadoUf;
  TextEditingController cidadeId;
  TextEditingController cidadeNome;

  ClienteController({
    required this.id,
    required this.nome,
    required this.estadoId,
    required this.estadoUf,
    required this.cidadeId,
    required this.cidadeNome,
  });
}
