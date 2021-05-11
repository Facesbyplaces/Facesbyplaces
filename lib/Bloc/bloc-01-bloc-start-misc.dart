import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMiscStartNewlyInstalled extends Cubit<int>{

  BlocMiscStartNewlyInstalled() : super(0);
  void modify(int value) => emit(value);
}