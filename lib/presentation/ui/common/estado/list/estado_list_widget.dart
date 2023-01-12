import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_list%20_dismissible_card.dart';
import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:basic/domain/models/common/estado.dart';

class EstadoListWidget extends StatelessWidget {
  final Estado estado;

  const EstadoListWidget(
    this.estado, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final msg = ScaffoldMessenger.of(context);
    return AppDismissible(
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
              message: '${estado.nome}\n${estado.uf}',
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
