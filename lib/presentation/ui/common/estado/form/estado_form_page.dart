import 'package:basic/data/repositories/common/estado_repository.dart';
import 'package:basic/domain/models/common/estado.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:basic/shared/exceptions/auth_exception.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstadoFormPage extends StatefulWidget {
  const EstadoFormPage({super.key});

  @override
  State<EstadoFormPage> createState() => _EstadoFormPageState();
}

class _EstadoFormPageState extends State<EstadoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final controllers = EstadoController(
    id: TextEditingController(),
    nome: TextEditingController(),
    uf: TextEditingController(),
  );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Estados Form'),
      showDrawer: true,
      body: formFields(context),
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
            children: [nomeField, ufField, buildElevatedButton(context)],
          ),
        ),
      ),
    );
  }

  Widget get nomeField {
    return FormTextInput(
      label: 'Nome',
      controller: controllers.nome,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get ufField {
    return FormTextInput(
      label: 'UF',
      controller: controllers.uf,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Padding buildElevatedButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
            foregroundColor: MaterialStateProperty.all<Color>(AppColors.background),
          ),
          onPressed: _submit,
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Salvar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    try {
      _formKey.currentState?.save();

      final Map<String, String?> payload = {
        'id': controllers.id.text,
        'nome': controllers.nome.text,
        'uf': controllers.uf.text,
      };
      // ignore: unused_local_variable
      final response = await Provider.of<EstadoRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return ConfirmActionWidget(message: 'Cliente criado com sucesso!', cancelButtonText: 'Ok');
            },
          );
        } else {
          return showDialog(
            context: context,
            builder: (context) {
              return ConfirmActionWidget(message: 'CPF/CNPJ já registrado para outro cliente!', cancelButtonText: 'Ok');
            },
          );
        }
      });
    } on AuthException catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return ConfirmActionWidget(message: error.toString(), cancelButtonText: 'Ok');
        },
      );
    } catch (error) {
      return showDialog(
        context: context,
        builder: (context) {
          return ConfirmActionWidget(message: 'Ocorreu um erro inesperado!', cancelButtonText: 'Ok');
        },
      );
    }
  }
}
