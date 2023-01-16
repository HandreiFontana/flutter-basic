import 'package:basic/data/repositories/common/estado_repository.dart';
import 'package:basic/domain/models/common/estado.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_form_button.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:basic/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstadoFormPage extends StatefulWidget {
  const EstadoFormPage({super.key});

  @override
  State<EstadoFormPage> createState() => _EstadoFormPageState();
}

class _EstadoFormPageState extends State<EstadoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool dataIsLoaded = false;
  bool isViewPage = false;

  final controllers = EstadoController(
    id: TextEditingController(),
    nome: TextEditingController(),
    uf: TextEditingController(),
  );

  // Builder

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (args != null && !dataIsLoaded) {
      controllers.id.text = args['id'] ?? '';
      _loadData(controllers.id.text);
      isViewPage = args['view'] ?? false;
      dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/estados', (route) => false)
            : await showDialog(
                context: context,
                builder: (context) {
                  return ConfirmActionWidget(
                    message: 'Deseja mesmo sair sem salvar as alterações?',
                    cancelButtonText: 'Não',
                    confirmButtonText: 'Sim',
                  );
                },
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/estados', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Estados Form'),
        showDrawer: false,
        body: formFields(context),
      ),
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

  // Form Fields

  Widget get nomeField {
    return FormTextInput(
      label: 'Nome',
      isDisabled: isViewPage,
      controller: controllers.nome,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get ufField {
    return FormTextInput(
      label: 'UF',
      isDisabled: isViewPage,
      controller: controllers.uf,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get actionButtons {
    return isViewPage
        ? SizedBox.shrink()
        : Row(
            children: [
              Expanded(child: AppFormButton(submit: _cancel, label: 'Cancelar')),
              SizedBox(width: 10),
              Expanded(child: AppFormButton(submit: _submit, label: 'Salvar')),
            ],
          );
  }

  // Functions

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
              return ConfirmActionWidget(
                message: controllers.id.text == '' ? 'Estado criado com sucesso!' : 'Estado atualizado com sucesso!',
                cancelButtonText: 'Ok',
              );
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
