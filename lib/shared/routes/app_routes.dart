import 'package:basic/presentation/ui/authentication/home/home_page.dart';
import 'package:basic/presentation/ui/authentication/signin/signin_page.dart';
import 'package:basic/presentation/ui/common/cidade/list/cidade_list_page.dart';
import 'package:basic/presentation/ui/common/cliente/list/cliente_list_page.dart';
import 'package:basic/presentation/ui/common/estado/form/estado_form_page.dart';
import 'package:basic/presentation/ui/common/estado/list/estado_list_page.dart';
import 'package:flutter/material.dart';

var appRoutes = <String, WidgetBuilder>{
  '/': (context) => const AuthenticationPage(),
  '/home': (context) => const HomePage(),
  '/estados': (context) => const EstadoListPage(),
  '/estados-form': (context) => const EstadoFormPage(),
  '/cidades': (context) => const CidadeListPage(),
  '/clientes': (context) => const ClienteListPage(),
};
