import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somnio/app/theme/theme_cubit.dart';

void main() {
  group('$ThemeCubit', () {
    ThemeCubit buildCubit() => ThemeCubit();

    test('constructor returns normally', () {
      expect(buildCubit, returnsNormally);
    });

    test('initial state is ${Brightness.light}', () {
      expect(buildCubit().state, Brightness.light);
    });

    blocTest<ThemeCubit, Brightness>(
      'emits [${Brightness.dark}] when toggleTheme is called once',
      build: buildCubit,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [Brightness.dark],
    );

    blocTest<ThemeCubit, Brightness>(
      'emits [dark, light] when toggleTheme is called twice',
      build: buildCubit,
      act: (cubit) {
        cubit
          ..toggleTheme()
          ..toggleTheme();
      },
      expect: () => [Brightness.dark, Brightness.light],
    );
  });
}
