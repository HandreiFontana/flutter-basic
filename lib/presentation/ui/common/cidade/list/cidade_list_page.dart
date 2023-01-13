import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic/data/repositories/common/cidade_repository.dart';
import 'package:basic/presentation/components/app_no_data.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/app_search_bar.dart';
import 'cidade_list_widget.dart';

class CidadeListPage extends StatefulWidget {
  const CidadeListPage({Key? key}) : super(key: key);

  @override
  State<CidadeListPage> createState() => _CidadeListPageState();
}

class _CidadeListPageState extends State<CidadeListPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;

        Navigator.of(context).pushReplacementNamed('/home');

        return retorno;
      },
      child: AppScaffold(
        title: Text('Cidades'),
        showDrawer: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AppSearchBar(
                onSearch: (q) {
                  setState(() {
                    query = q;
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  child: FutureBuilder(
                    future:
                        Provider.of<CidadeRepository>(context, listen: false)
                            .list(query, 50, 0, ['ASC', 'ASC']),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.error != null) {
                        return AppNoData();
                      } else {
                        Map<String, dynamic> snapshotData =
                            snapshot.data as Map<String, dynamic>;
                        if (snapshotData['items'].isNotEmpty) {
                          return Consumer<CidadeRepository>(
                            builder: (ctx, cidades, child) => RefreshIndicator(
                              onRefresh: (() {
                                return Future.delayed(
                                  Duration(microseconds: 2),
                                  (() {
                                    setState(() {});
                                  }),
                                );
                              }),
                              child: ListView.builder(
                                itemCount: cidades.itemsCount,
                                itemBuilder: (ctx, i) =>
                                    CidadeListWidget(cidades.items[i]),
                                physics: const AlwaysScrollableScrollPhysics(),
                              ),
                            ),
                          );
                        } else {
                          return AppNoData();
                        }
                      }
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
