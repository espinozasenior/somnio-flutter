import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:somnio/app/theme/app_theme.dart';
import 'package:somnio/app/theme/theme_cubit.dart';
import 'package:somnio/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:somnio/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    required this.router,
    required this.authCubit,
    super.key,
  });

  final GoRouter router;
  final AuthCubit authCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider.value(value: authCubit),
      ],
      child: BlocBuilder<ThemeCubit, Brightness>(
        builder: (context, brightness) {
          final theme = brightness == Brightness.light
              ? AppTheme.lightTheme
              : AppTheme.darkTheme;
          return MaterialApp.router(
            theme: theme,
            darkTheme: AppTheme.darkTheme,
            themeMode: brightness == Brightness.light
                ? ThemeMode.light
                : ThemeMode.dark,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
