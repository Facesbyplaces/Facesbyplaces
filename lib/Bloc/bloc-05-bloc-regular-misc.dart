import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMiscRegularManageMemorialButton extends Cubit<bool>{

  BlocMiscRegularManageMemorialButton() : super(false);
  void modify(bool value) => emit(value);
}

class BlocMiscRegularDropDown extends Cubit<String>{

  BlocMiscRegularDropDown() : super('Copy Link');
  void modify(String value) => emit(value);
}

class BlocMiscRegularJoinMemorialButton extends Cubit<bool>{

  BlocMiscRegularJoinMemorialButton() : super(false);
  void modify(bool value) => emit(value);
}
