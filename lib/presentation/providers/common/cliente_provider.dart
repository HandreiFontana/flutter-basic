import 'package:provider/provider.dart';
import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:basic/data/repositories/common/cliente_repository.dart';

var clienteProvider = [
  ChangeNotifierProxyProvider<Authentication, ClienteRepository>(
    create: (_) => ClienteRepository(),
    update: (ctx, auth, previous) {
      return ClienteRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
