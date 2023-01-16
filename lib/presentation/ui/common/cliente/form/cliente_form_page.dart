import 'package:basic/data/repositories/common/cidade_repository.dart';
import 'package:basic/data/repositories/common/cliente_repository.dart';
import 'package:basic/data/repositories/common/estado_repository.dart';
import 'package:basic/domain/models/common/cliente.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_form_button.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/inputs/app_form_select_input_widget.dart';
import 'package:basic/presentation/components/inputs/app_form_text_input_widget.dart';
import 'package:basic/shared/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClienteFormPage extends StatefulWidget {
  const ClienteFormPage({super.key});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool dataIsLoaded = false;
  bool isViewPage = false;

  final controllers = ClienteController(
    id: TextEditingController(),
    nome: TextEditingController(),
    estadoId: TextEditingController(),
    estadoUf: TextEditingController(),
    cidadeId: TextEditingController(),
    cidadeNome: TextEditingController(),
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

    return AppScaffold(
      title: Text('Clientes Form'),
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
              estadoIdField,
              cidadeIdField,
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

  Widget get estadoIdField {
    return FormSelectInput(
      label: 'UF',
      isDisabled: isViewPage,
      controllerValue: controllers.estadoId,
      controllerLabel: controllers.estadoUf,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<EstadoRepository>(context, listen: false).select(pattern),
      onSaved: (suggestion) {
        setState(() {
          controllers.estadoId.text = suggestion['value'] ?? '';
          controllers.estadoUf.text = suggestion['label'] ?? '';
        });
      },
    );
  }

  Widget get cidadeIdField {
    return FormSelectInput(
      label: 'Cidade',
      isDisabled: isViewPage || controllers.estadoId.text == '',
      controllerValue: controllers.cidadeId,
      controllerLabel: controllers.cidadeNome,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<CidadeRepository>(context, listen: false).select(pattern, controllers.estadoId.text),
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
    await Provider.of<ClienteRepository>(context, listen: false).get(id).then((cliente) => _populateController(cliente));
  }

  Future<void> _populateController(Cliente cliente) async {
    setState(() {
      controllers.id.text = cliente.id ?? '';
      controllers.nome.text = cliente.nome ?? '';
      controllers.estadoId.text = cliente.estadoId ?? '';
      controllers.estadoUf.text = cliente.estadoUf ?? '';
      controllers.cidadeId.text = cliente.cidadeId ?? '';
      controllers.cidadeNome.text = cliente.cidadeNome ?? '';
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
        'estadoId': controllers.estadoId.text,
        'cidadeId': controllers.cidadeId.text,
      };

      await Provider.of<ClienteRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return ConfirmActionWidget(
                message: controllers.id.text == '' ? 'Cliente criado com sucesso!' : 'Cliente atualizada com sucesso!',
                cancelButtonText: 'Ok',
              );
            },
          ).then((value) => Navigator.of(context).pushReplacementNamed('/clientes'));
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
        Navigator.of(context).pushReplacementNamed('/clientes');
      }
    });
  }
}
