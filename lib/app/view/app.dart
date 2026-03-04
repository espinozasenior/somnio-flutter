import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/app/theme/app_theme.dart';
import 'package:somnio/app/theme/theme_cubit.dart';
import 'package:somnio/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, Brightness>(
        builder: (context, brightness) {
          final theme = brightness == Brightness.light
              ? AppTheme.lightTheme
              : AppTheme.darkTheme;
          return CupertinoApp.router(
            theme: theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
