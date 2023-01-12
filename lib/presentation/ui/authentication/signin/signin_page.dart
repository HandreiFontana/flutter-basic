import 'dart:convert';
import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:basic/shared/exceptions/auth_exception.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:basic/shared/themes/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  bool _isLoading = false;
  final Map<String, String> _authData = {
    'login': '',
    'password': '',
  };

  // App bar

  AppBar get buildAppBar {
    return AppBar(
      title: const Text('Login'),
      centerTitle: true,
    );
  }

  // Logo

  Widget get buildFormLogo {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        width: 250,
        height: 60,
        child: Image.asset(AppImages.signInLogo),
      ),
    );
  }

  // Email

  Widget get buildFormFieldEmail {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (login) => _authData['login'] = login ?? '',
        validator: (value) =>
            (value ?? '').isNotEmpty ? null : 'Campo obrigatório!',
      ),
    );
  }

  // Password

  Widget get buildFormFieldPassword {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Senha',
        ),
        obscureText: true,
        onSaved: (password) =>
            _authData['password'] = base64.encode(utf8.encode(password ?? '')),
        validator: (passwordPar) {
          final password = passwordPar ?? '';
          if (password.isEmpty || password.length < 5) {
            return 'Informe uma senha válida';
          }
          return null;
        },
      ),
    );
  }

  // Logo Vamilly

  Widget get buildFormLogoVamilly {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Opacity(
        opacity: 0.2,
        child: SizedBox(
          width: 110,
          child: Image.asset(AppImages.companyLogo),
        ),
      ),
    );
  }

  // Dialog

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Authentication authentication = Provider.of(context, listen: false);

    try {
      await authentication
          .login(
            _authData['login']!,
            _authData['password']!,
          )
          .then((value) => Navigator.of(context).pushReplacementNamed('/home'));
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  Padding buildElevatedButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.primary),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
            foregroundColor:
                MaterialStateProperty.all<Color>(AppColors.background),
          ),
          onPressed: _submit,
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Acessar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );

  // Page

  Form buildFields(context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFormLogo,
            buildFormFieldEmail,
            buildFormFieldPassword,
            buildElevatedButton(context),
            buildFormLogoVamilly
          ],
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildFields(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }
}
