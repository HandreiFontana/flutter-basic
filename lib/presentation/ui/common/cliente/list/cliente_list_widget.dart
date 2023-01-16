import 'package:basic/data/repositories/common/cliente_repository.dart';
import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_list_dismissible_card.dart';
import 'package:basic/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:basic/domain/models/common/cliente.dart';
import 'package:provider/provider.dart';

class ClienteListWidget extends StatelessWidget {
  final Cliente cliente;

  const ClienteListWidget(
    this.cliente, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    Authentication authentication = Provider.of(context, listen: false);

    return AppDismissible(
      direction: authentication.permitUpdateDelete('/clientes'),
      endToStart: () async {
        await Provider.of<ClienteRepository>(context, listen: false).delete(cliente).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': cliente.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/clientes-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': cliente.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/clientes-form', arguments: data);
      },
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: AppColors.cardColor,
            elevation: 5,
            child: ListTile(
              title: Text(cliente.nome ?? '',
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                  )),
              subtitle: Text(cliente.cidadeNome ?? '',
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
