import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMiscBLMDropDown extends Cubit<String>{

  BlocMiscBLMDropDown() : super('Copy Link');
  void modify(String value) => emit(value);
}
