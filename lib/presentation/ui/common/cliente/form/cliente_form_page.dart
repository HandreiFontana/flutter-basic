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
  bool _dataIsLoaded = false;
  bool _isViewPage = false;

  final _controllers = ClienteController(
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
    if (args != null && !_dataIsLoaded) {
      _controllers.id.text = args['id'] ?? '';
      _loadData(_controllers.id.text);
      _isViewPage = args['view'] ?? false;
      _dataIsLoaded = true;
    }

    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        _isViewPage
            ? Navigator.of(context).pushNamedAndRemoveUntil('/clientes', (route) => false)
            : await showDialog(
                context: context,
                builder: (context) {
                  return ConfirmActionWidget(
                    message: 'Deseja mesmo sair sem salvar as alterações?',
                    cancelButtonText: 'Não',
                    confirmButtonText: 'Sim',
                  );
                },
              ).then((value) => value ? Navigator.of(context).pushNamedAndRemoveUntil('/clientes', (route) => false) : retorno = value);

        return retorno;
      },
      child: AppScaffold(
        title: Text('Clientes Form'),
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
              _nomeField,
              _estadoIdField,
              _cidadeIdField,
              _actionButtons,
            ],
          ),
        ),
      ),
    );
  }

  // Form Fields

  Widget get _nomeField {
    return FormTextInput(
      label: 'Nome',
      isDisabled: _isViewPage,
      controller: _controllers.nome,
      clear: true,
      isRequired: true,
      validator: (value) => value != '' ? null : 'Campo obrigatório!',
    );
  }

  Widget get _estadoIdField {
    return FormSelectInput(
      label: 'UF',
      isDisabled: _isViewPage,
      controllerValue: _controllers.estadoId,
      controllerLabel: _controllers.estadoUf,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<EstadoRepository>(context, listen: false).select(pattern),
      onSaved: (suggestion) {
        setState(() {
          _controllers.estadoId.text = suggestion['value'] ?? '';
          _controllers.estadoUf.text = suggestion['label'] ?? '';
        });
      },
    );
  }

  Widget get _cidadeIdField {
    return FormSelectInput(
      label: 'Cidade',
      isDisabled: _isViewPage || _controllers.estadoId.text == '',
      controllerValue: _controllers.cidadeId,
      controllerLabel: _controllers.cidadeNome,
      isRequired: true,
      itemsCallback: (pattern) async => Provider.of<CidadeRepository>(context, listen: false).select(pattern, _controllers.estadoId.text),
    );
  }

  Widget get _actionButtons {
    return _isViewPage
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
      _controllers.id.text = cliente.id ?? '';
      _controllers.nome.text = cliente.nome ?? '';
      _controllers.estadoId.text = cliente.estadoId ?? '';
      _controllers.estadoUf.text = cliente.estadoUf ?? '';
      _controllers.cidadeId.text = cliente.cidadeId ?? '';
      _controllers.cidadeNome.text = cliente.cidadeNome ?? '';
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
        'id': _controllers.id.text,
        'nome': _controllers.nome.text,
        'estadoId': _controllers.estadoId.text,
        'cidadeId': _controllers.cidadeId.text,
      };

      await Provider.of<ClienteRepository>(context, listen: false).save(payload).then((validado) {
        if (validado) {
          return showDialog(
            context: context,
            builder: (context) {
              return ConfirmActionWidget(
                message: _controllers.id.text == '' ? 'Cliente criado com sucesso!' : 'Cliente atualizada com sucesso!',
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
