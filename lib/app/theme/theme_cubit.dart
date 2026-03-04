import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

class ThemeCubit extends Cubit<Brightness> {
  ThemeCubit() : super(Brightness.light);

  void toggleTheme() {
    emit(state == Brightness.light ? Brightness.dark : Brightness.light);
  }
}
