import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_list_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:basic/domain/models/common/estado.dart';
import 'package:provider/provider.dart';

class EstadoListWidget extends StatelessWidget {
  final Estado estado;

  const EstadoListWidget(
    this.estado, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Authentication authentication = Provider.of(context, listen: false);
    return AppDismissible(
      direction: authentication.permitUpdateDelete('/estados'),
      endToStart: () {
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
        Map data = {'id': estado.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/estados-form', arguments: data);
      },
      onDoubleTap: () {
        Map data = {'id': estado.id, 'view': true};
        Navigator.of(context).pushReplacementNamed('/estados-form', arguments: data);
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
              title: Text(estado.nome ?? '',
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                  )),
              subtitle: Text(estado.uf ?? '',
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
