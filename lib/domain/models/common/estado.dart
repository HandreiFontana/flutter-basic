import 'package:flutter/cupertino.dart';

class Estado {
  String? id;
  String? nome;
  String? uf;

  Estado({
    this.id,
    this.nome,
    this.uf,
  });
}

class EstadoController {
  TextEditingController id;
  TextEditingController nome;
  TextEditingController uf;

  EstadoController({
    required this.id,
    required this.nome,
    required this.uf,
  });
}
