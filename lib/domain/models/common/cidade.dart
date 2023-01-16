import 'package:flutter/cupertino.dart';

class Cidade {
  String? id;
  String? nome;
  String? estadoId;
  String? estadoUf;

  Cidade({
    this.id,
    this.nome,
    this.estadoId,
    this.estadoUf,
  });
}

class CidadeController {
  TextEditingController id;
  TextEditingController nome;
  TextEditingController estadoId;
  TextEditingController estadoUf;

  CidadeController({
    required this.id,
    required this.nome,
    required this.estadoId,
    required this.estadoUf,
  });
}
