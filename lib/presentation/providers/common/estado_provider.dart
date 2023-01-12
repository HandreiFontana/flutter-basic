import 'package:provider/provider.dart';
import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:basic/data/repositories/common/estado_repository.dart';

var estadoProvider = [
  ChangeNotifierProxyProvider<Authentication, EstadoRepository>(
    create: (_) => EstadoRepository(),
    update: (ctx, auth, previous) {
      return EstadoRepository(
        auth.token ?? '',
        previous?.items ?? [],
      );
    },
  ),
];
