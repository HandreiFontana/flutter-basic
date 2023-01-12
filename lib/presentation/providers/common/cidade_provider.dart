import 'package:provider/provider.dart';
import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:basic/data/repositories/common/cidade_repository.dart';

var cidadeProvider = [
  ChangeNotifierProxyProvider<Authentication, CidadeRepository>(
    create: (_) => CidadeRepository(),
    update: (ctx, auth, previous) {
      return CidadeRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
