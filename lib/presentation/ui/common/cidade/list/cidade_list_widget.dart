import 'package:basic/data/repositories/common/cidade_repository.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:basic/presentation/components/app_list_dismissible_card.dart';
import 'package:basic/shared/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:basic/domain/models/common/cidade.dart';
import 'package:provider/provider.dart';

class CidadeListWidget extends StatelessWidget {
  final Cidade cidade;

  const CidadeListWidget(
    this.cidade, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return AppDismissible(
      endToStart: () async {
        await Provider.of<CidadeRepository>(context, listen: false).delete(cidade).then((message) {
          return scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: AppConstants.snackBarDuration),
          ));
        });
      },
      startToEnd: () {
        Map data = {'id': cidade.id, 'view': false};
        Navigator.of(context).pushReplacementNamed('/cidades-form', arguments: data);
      },
      onDoubleTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmActionWidget(
              title: 'Visualizar',
              message: '${cidade.nome}\n${cidade.estadoUf}',
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
              title: Text(cidade.nome ?? '',
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                  )),
              subtitle: Text(cidade.estadoUf ?? '',
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
