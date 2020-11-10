import 'package:flutter_bloc/flutter_bloc.dart';

class BlocHomeBLMToggleBottom extends Cubit<int>{

  BlocHomeBLMToggleBottom() : super(0);
  void modify(int number) => emit(number);
}

class BlocHomeUpdateToggle extends Cubit<List<bool>>{

  BlocHomeUpdateToggle() : super([true, false, false, false]);

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

class BlocHomeBLMUpdateMemorialToggle extends Cubit<int>{

  BlocHomeBLMUpdateMemorialToggle() : super(0);
  void updateToggle(int index) => emit(index);
}


class BlocHomeBLMUpdateToggleFeed extends Cubit<int>{

  BlocHomeBLMUpdateToggleFeed() : super(0);
  void updateToggle(int index) => emit(index);
}

class BlocHomeBLMUpdateListSuggested extends Cubit<List<bool>>{

  BlocHomeBLMUpdateListSuggested() : super([false, false, false, false, false, false, false, false, false, false,]);

  List<bool> changeState(int number){
    List<bool> newList = [false, false, false, false, false, false, false, false, false, false,];

    for(int h = 0; h < state.length; h++){
      newList[h] = state[h];
    }


    for(int i = 0; i < state.length; i++){
      if(i == number){
        newList[i] = !newList[i];
      }
    }

    return newList;
  }

  void updateList(int number) => emit(changeState(number));
}


class BlocHomeBLMUpdateListNearby extends Cubit<List<bool>>{

  BlocHomeBLMUpdateListNearby() : super([false, false, false, false, false, false, false, false, false, false,]);

  List<bool> changeState(int number){
    List<bool> newList = [false, false, false, false, false, false, false, false, false, false,];

    for(int h = 0; h < state.length; h++){
      newList[h] = state[h];
    }


    for(int i = 0; i < state.length; i++){
      if(i == number){
        newList[i] = !newList[i];
      }
    }

    return newList;
  }

  void updateList(int number) => emit(changeState(number));
}

class BlocHomeBLMUpdateListBLM extends Cubit<List<bool>>{

  BlocHomeBLMUpdateListBLM() : super([false, false, false, false, false, false, false, false, false, false,]);

  List<bool> changeState(int number){
    List<bool> newList = [false, false, false, false, false, false, false, false, false, false,];

    for(int h = 0; h < state.length; h++){
      newList[h] = state[h];
    }


    for(int i = 0; i < state.length; i++){
      if(i == number){
        newList[i] = !newList[i];
      }
    }

    return newList;
  }

  void updateList(int number) => emit(changeState(number));
}


class BlocHomeBLMStoryType extends Cubit<int>{

  BlocHomeBLMStoryType() : super(0);
  void updateToggle(int index) => emit(index);
}

class BlocHomeBLMBackgroundImage extends Cubit<int>{

  BlocHomeBLMBackgroundImage() : super(0);
  void updateToggle(int index) => emit(index);
}