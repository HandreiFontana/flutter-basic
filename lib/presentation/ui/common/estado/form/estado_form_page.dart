import 'package:basic/data/repositories/common/estado_repository.dart';
import 'package:basic/domain/models/common/estado.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_form_button.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:basic/shared/exceptions/auth_exception.dart';
import 'package:basic/shared/utils/arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstadoFormPage extends StatefulWidget {
  const EstadoFormPage({super.key});

  @override
  State<EstadoFormPage> createState() => _EstadoFormPageState();
}

class _EstadoFormPageState extends State<EstadoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool isViewPage = false;

  final controllers = EstadoController(
    id: TextEditingController(),
    nome: TextEditingController(),
    uf: TextEditingController(),
  );

  @override
  void initState() {
    final args = ModalRoute.of(context)!.settings.arguments as Arguments?;
    if (args != null) {
      controllers.id.text = args.data['id'] ?? '';
      _loadData(controllers.id.text);
      isViewPage = args.data['view'] ?? false;
    }

    super.initState();
  }

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
            children: [
              nomeField,
              ufField,
              actionButtons,
            ],
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

  Widget get actionButtons {
    return Row(
      children: [
        Expanded(child: AppFormButton(submit: _cancel, label: 'Cancelar')),
        SizedBox(width: 10),
        Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
      ],
    );
  }

  Future<void> _loadData(String id) async {
    await Provider.of<EstadoRepository>(context, listen: false).get(id).then((estado) => _populateController(estado));
  }

  Future<void> _populateController(Estado estado) async {
    setState(() {
      controllers.id.text = estado.id ?? '';
      controllers.nome.text = estado.nome ?? '';
      controllers.uf.text = estado.uf ?? '';
    });
  }

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

      await Provider.of<EstadoRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return ConfirmActionWidget(message: 'Estado criado com sucesso!', cancelButtonText: 'Ok');
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/estados'));
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

  Future<void> _cancel() async {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmActionWidget(
          message: 'Tem certeza que deseja sair?',
          cancelButtonText: 'Não',
          confirmButtonText: 'Sim',
        );
      },
    ).then((value) {
      if (value) {
        Navigator.of(context).pushReplacementNamed('/estados');
      }
    });
  }
}
