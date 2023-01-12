import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic/shared/exceptions/http_exception.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:basic/domain/models/common/estado.dart';
import 'package:basic/data/repositories/common/estado_repository.dart';

class EstadoListWidget extends StatelessWidget {
  final Estado estado;

  const EstadoListWidget(
    this.estado, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return Column(children: <Widget>[
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
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: AppColors.cardTextColor,
                  onPressed: () {
                    //Navigator.of(context).pushNamed(
                    //  AppRoutes.productForm,
                    //  arguments: estado.id,
                    //);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: AppColors.cardTextColor,
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Excluir registro'),
                        content: const Text('Tem certeza?'),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                        ],
                      ),
                    ).then((value) async {
                      if (value ?? false) {
                        try {
                          await Provider.of<EstadoRepository>(
                            context,
                            listen: false,
                          ).delete(estado);
                        } on HttpException catch (error) {
                          msg.showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
