import 'package:flutter_bloc/flutter_bloc.dart';

class HomeUpdateCubit extends Cubit<int>{

  HomeUpdateCubit() : super(0);

  void forward() => emit(state + 1);
  void backward() => emit(state - 1);
  void forwardTimes(int number) => emit(state + number);
  void backwardTimes(int number) => emit(state - number);
}

class HomeUpdateToggle extends Cubit<List<bool>>{

  HomeUpdateToggle() : super([true, false, false, false]);

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

}