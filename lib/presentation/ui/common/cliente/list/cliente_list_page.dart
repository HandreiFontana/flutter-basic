import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic/data/repositories/common/cliente_repository.dart';
import 'package:basic/presentation/components/app_no_data.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/app_search_bar.dart';
import 'cliente_list_widget.dart';

class ClienteListPage extends StatefulWidget {
  const ClienteListPage({Key? key}) : super(key: key);

  @override
  State<ClienteListPage> createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<ClienteListPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Clientes'),
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
                future: Provider.of<ClienteRepository>(context, listen: false).list(query, 50, 0, ['ASC', 'ASC']),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.error != null) {
                    return AppNoData();
                  } else {
                    Map<String, dynamic> snapshotData = snapshot.data as Map<String, dynamic>;
                    if (snapshotData['items'].isNotEmpty) {
                      return Consumer<ClienteRepository>(
                        builder: (ctx, clientes, child) => ListView.builder(
                          itemCount: clientes.itemsCount,
                          itemBuilder: (ctx, i) => ClienteListWidget(clientes.items[i]),
                        ),
                      );
                    } else {
                      return AppNoData();
                    } else {
                      Map<String, dynamic> snapshotData =
                          snapshot.data as Map<String, dynamic>;
                      if (snapshotData['items'].isNotEmpty) {
                        return Consumer<ClienteRepository>(
                          builder: (ctx, clientes, child) => RefreshIndicator(
                            onRefresh: (() {
                              return Future.delayed(
                                Duration(microseconds: 500),
                                (() {
                                  setState(() {});
                                }),
                              );
                            }),
                            child: ListView.builder(
                              itemCount: clientes.itemsCount,
                              itemBuilder: (ctx, i) =>
                                  ClienteListWidget(clientes.items[i]),
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
