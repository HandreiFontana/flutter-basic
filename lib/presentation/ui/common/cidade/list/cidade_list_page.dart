import 'package:basic/domain/models/common/cidade.dart';
import 'package:basic/presentation/components/app_confirm_action.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:basic/data/repositories/common/cidade_repository.dart';
import 'package:basic/presentation/components/app_scaffold.dart';
import 'package:basic/presentation/components/app_search_bar.dart';
import 'cidade_list_widget.dart';

class CidadeListPage extends StatefulWidget {
  const CidadeListPage({Key? key}) : super(key: key);

  @override
  State<CidadeListPage> createState() => _CidadeListPageState();
}

class _CidadeListPageState extends State<CidadeListPage> {
  String _query = '';
  late int _page;
  final int _nextPageTrigger = 3;
  final int _pageSize = 50;
  late bool _isLastPage;
  late bool _hasError;
  late bool _isLoading;
  late List<Cidade> _cards;

  @override
  void initState() {
    super.initState();
    _page = 1;
    _cards = [];
    _isLastPage = false;
    _isLoading = true;
    _hasError = false;
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Cidade> cidadeList = [];
    await Provider.of<CidadeRepository>(context, listen: false).list(_query, _pageSize, _page, ['ASC', 'ASC']).then(
      (value) {
        cidadeList = value;
        setState(() {
          _isLastPage = cidadeList.length < _pageSize;
          _isLoading = false;
          _page = _page + 1;
          _cards.addAll(cidadeList);
        });
      },
    ).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  void _hasErrorDialog() async {
    await showDialog(
            context: context,
            builder: (context) => ConfirmActionWidget(message: 'Ocorreu um erro ao carregar as cidades.', cancelButtonText: 'Tentar novamente'))
        .then((value) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _fetchData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (_hasError) {
        _hasErrorDialog();
      }
    }
    return WillPopScope(
      onWillPop: () async {
        bool retorno = true;
        Navigator.of(context).pushReplacementNamed('/home');
        return retorno;
      },
      child: AppScaffold(
        title: Text('Cidades'),
        route: '/cidades-form',
        showDrawer: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Campo de busca
              AppSearchBar(
                onSearch: (q) {
                  setState(() {
                    _query = q;
                    _cards.clear();
                    _fetchData();
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: _cards.length + (_isLastPage ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == _cards.length - _nextPageTrigger && !_isLastPage) {
                        _fetchData();
                      }

                      if (index == _cards.length) {
                        if (_hasError) {
                          _hasErrorDialog();
                        } else {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }
                      final Cidade card = _cards[index];
                      return CidadeListWidget(card);
                    },
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
