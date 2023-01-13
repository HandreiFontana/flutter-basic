import 'package:basic/data/repositories/common/estado_repository.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_list_dismissible_card.dart';
import 'package:basic/shared/config/app_constants.dart';
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return AppDismissible(
      endToStart: () async {
        await Provider.of<EstadoRepository>(context, listen: false).delete(estado).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': estado.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/estados-form', arguments: data);
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
