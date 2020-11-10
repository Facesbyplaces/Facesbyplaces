import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMiscBLMManageMemorialButton extends Cubit<bool>{

  BlocMiscBLMManageMemorialButton() : super(false);
  void modify(bool value) => emit(value);
}
