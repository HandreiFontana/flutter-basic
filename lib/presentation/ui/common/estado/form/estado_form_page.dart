import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class EstadoFormPage extends StatefulWidget {
  const EstadoFormPage({super.key});

  @override
  State<EstadoFormPage> createState() => _EstadoFormPageState();
}

class _EstadoFormPageState extends State<EstadoFormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Estados Form'),
      showDrawer: true,
      body: Column(),
    );
  }

  Form formFields(context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [],
          ),
        ),
      ),
    );
  }
}
