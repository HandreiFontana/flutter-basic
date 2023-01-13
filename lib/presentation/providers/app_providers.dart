import 'package:basic/presentation/providers/common/user_provider.dart';

import './authentication/authentication_provider.dart';
import './common/estado_provider.dart';
import './common/cidade_provider.dart';
import './common/cliente_provider.dart';

mixin AppProviders {
  static var providers = [
    ...authenticationProvider,
    ...estadoProvider,
    ...cidadeProvider,
    ...clienteProvider,
    ...userProvider,
  ];
}
