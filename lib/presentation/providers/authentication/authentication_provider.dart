import 'package:provider/provider.dart';
import 'package:basic/domain/models/authentication/authentication.dart';

var authenticationProvider = [
  ChangeNotifierProvider(
    create: (_) => Authentication(),
  ),
];
