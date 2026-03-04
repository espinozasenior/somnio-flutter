import 'package:somnio/app/app.dart';
import 'package:somnio/bootstrap.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/routing/app_router.dart';

Future<void> main() async {
  await bootstrap(() => App(router: getIt<AppRouter>().router));
}
