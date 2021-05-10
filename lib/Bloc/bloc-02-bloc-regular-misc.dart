import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMiscRegularDropDown extends Cubit<String>{

  BlocMiscRegularDropDown() : super('Copy Link');
  void modify(String value) => emit(value);
}

class BlocMiscStartNewlyInstalled extends Cubit<int>{

  BlocMiscStartNewlyInstalled() : super(0);
  void modify(int value) => emit(value);
}