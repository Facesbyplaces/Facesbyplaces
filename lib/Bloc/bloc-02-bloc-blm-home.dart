import 'package:flutter_bloc/flutter_bloc.dart';

class BlocHomeBLMToggleBottom extends Cubit<int>{

  BlocHomeBLMToggleBottom() : super(0);
  void modify(int number) => emit(number);
}

class BlocHomeBLMUpdateToggle extends Cubit<List<bool>>{

  BlocHomeBLMUpdateToggle() : super([true, false, false, false]);

  List<bool> changeToggle(int index){
    List<bool> newList = [true, false, false, false];
    for(int i = 0; i < state.length; i++){
      if(i == index){
        newList[i] = true;
      }else{
        newList[i] = false;
      }
    }
    return newList;
  }

  void updateToggle(int index) => emit(changeToggle(index));
  void reset() => emit([true, false, false, false]);
}