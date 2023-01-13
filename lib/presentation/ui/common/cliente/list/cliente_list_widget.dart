import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_list%20_dismissible_card.dart';
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
    Authentication authentication = Provider.of(context, listen: false);
    final msg = ScaffoldMessenger.of(context);
    return AppDismissible(
      direction: authentication.permitUpdateDelete('/cliente'),
      endToStart: () {
        msg.showSnackBar(SnackBar(
          content: Text('teste'),
          duration: Duration(seconds: 1),
        ));
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmActionWidget(
              title: 'Sucesso',
              message: 'Excluido com sucesso',
              cancelButtonText: 'Fechar',
            );
          },
        );
      },
      startToEnd: () {
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmActionWidget(
              title: 'Sucesso',
              message: 'Editado com sucesso',
              cancelButtonText: 'Fechar',
            );
          },
        );
      },
      onDoubleTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmActionWidget(
              title: 'Visualizar',
              message: '${cliente.nome}\n${cliente.cidadeNome}',
              cancelButtonText: 'Fechar',
            );
          },
        );
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
