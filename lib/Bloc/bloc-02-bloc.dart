import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeUpdateCubit extends Cubit<int>{

  HomeUpdateCubit() : super(0);

  int changeValue(int index){
    return index;
  }

  void forward() => emit(state + 1);
  void backward() => emit(state - 1);
  void forwardTimes(int number) => emit(state + number);
  void backwardTimes(int number) => emit(state - number);
  void modify(int number) => emit(changeValue(number));

}

class HomeUpdateAppBar extends Cubit<PreferredSizeWidget>{

  HomeUpdateAppBar() : super(MiscAppBar1());

  void search() => emit(MiscAppBar2());

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

// class HomeUpdateToggleFeed extends Cubit<List<bool>>{

//   HomeUpdateToggleFeed() : super([true, false, false, false]);

//   List<bool> changeToggle(int index){
//     List<bool> newList = [true, false, false, false];
//     for(int i = 0; i < state.length; i++){
//       if(i == index){
//         newList[i] = true;
//       }else{
//         newList[i] = false;
//       }
//     }
    
//     return newList;
//   }

//   void updateToggle(int index) => emit(changeToggle(index));

// }

class HomeUpdateToggleFeed extends Cubit<int>{

  HomeUpdateToggleFeed() : super(0);

  void updateToggle(int index) => emit(index);

}