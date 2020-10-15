import 'package:flutter_bloc/flutter_bloc.dart';

class BlocHomeUpdateCubit extends Cubit<int>{

  BlocHomeUpdateCubit() : super(0);
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

class BlocHomeUpdateMemorialToggle extends Cubit<int>{

  BlocHomeUpdateMemorialToggle() : super(0);
  void updateToggle(int index) => emit(index);
}


class BlocHomeUpdateToggleFeed extends Cubit<int>{

  BlocHomeUpdateToggleFeed() : super(0);
  void updateToggle(int index) => emit(index);
}

class BlocUserProfileTabs extends Cubit<int>{

  BlocUserProfileTabs() : super(0);
  void updateToggle(int index) => emit(index);
}

class BlocHomeUpdateListSuggested extends Cubit<List<bool>>{

  BlocHomeUpdateListSuggested() : super([false, false, false, false, false, false, false, false, false, false,]);

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


class BlocHomeUpdateListNearby extends Cubit<List<bool>>{

  BlocHomeUpdateListNearby() : super([false, false, false, false, false, false, false, false, false, false,]);

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

class BlocHomeUpdateListBLM extends Cubit<List<bool>>{

  BlocHomeUpdateListBLM() : super([false, false, false, false, false, false, false, false, false, false,]);

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
