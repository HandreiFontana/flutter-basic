import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic/shared/exceptions/http_exception.dart';
import 'package:basic/shared/themes/app_colors.dart';
import 'package:basic/domain/models/common/cidade.dart';
import 'package:basic/data/repositories/common/cidade_repository.dart';

class CidadeListWidget extends StatelessWidget {
  final Cidade cidade;

  const CidadeListWidget(
    this.cidade, {
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
          title: Text(cidade.nome ?? '',
              style: TextStyle(
                color: AppColors.cardTextColor,
              )),
          subtitle: Text(cidade.estadoUf ?? '',
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
                    //  arguments: cidade.id,
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
                          await Provider.of<CidadeRepository>(
                            context,
                            listen: false,
                          ).delete(cidade);
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
