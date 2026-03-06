import 'package:somnio/app/app.dart';
import 'package:somnio/bootstrap.dart';
import 'package:somnio/core/di/injection.dart';
import 'package:somnio/core/routing/app_router.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_cubit.dart';

Future<void> main() async {
  await bootstrap(
    () => App(
      router: getIt<AppRouter>().router,
      authCubit: getIt<AuthCubit>(),
    ),
  );
}
