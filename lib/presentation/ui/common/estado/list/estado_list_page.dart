import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic/data/repositories/common/estado_repository.dart';
import 'package:basic/presentation/components/app_no_data.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/app_search_bar.dart';
import 'estado_list_widget.dart';

class EstadoListPage extends StatefulWidget {
  const EstadoListPage({Key? key}) : super(key: key);

  @override
  State<EstadoListPage> createState() => _EstadoListPageState();
}

class _EstadoListPageState extends State<EstadoListPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Text('Estados'),
        route: '/estados-form',
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
                future: Provider.of<EstadoRepository>(context, listen: false).list(query, 50, 0, ['ASC', 'ASC']),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.error != null) {
                    return AppNoData();
                  } else {
                    Map<String, dynamic> snapshotData = snapshot.data as Map<String, dynamic>;
                    if (snapshotData['items'].isNotEmpty) {
                      return Consumer<EstadoRepository>(
                        builder: (ctx, estados, child) => ListView.builder(
                          itemCount: estados.itemsCount,
                          itemBuilder: (ctx, i) => EstadoListWidget(estados.items[i]),
                        ),
                      );
                    } else {
                      return AppNoData();
                    } else {
                      Map<String, dynamic> snapshotData =
                          snapshot.data as Map<String, dynamic>;
                      if (snapshotData['items'].isNotEmpty) {
                        return Consumer<EstadoRepository>(
                          builder: (ctx, estados, child) => RefreshIndicator(
                            onRefresh: (() {
                              return Future.delayed(
                                Duration(microseconds: 500),
                                (() {
                                  setState(() {});
                                }),
                              );
                            }),
                            child: ListView.builder(
                              itemCount: estados.itemsCount,
                              itemBuilder: (ctx, i) =>
                                  EstadoListWidget(estados.items[i]),
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
    );
  }
}
