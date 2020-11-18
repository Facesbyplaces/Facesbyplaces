import 'package:flutter_bloc/flutter_bloc.dart';

class BlocHomeRegularUpdateCubit extends Cubit<int>{

  BlocHomeRegularUpdateCubit() : super(0);
  void modify(int number) => emit(number);
}

class BlocHomeRegularUpdateToggle extends Cubit<List<bool>>{

  BlocHomeRegularUpdateToggle() : super([true, false, false, false]);

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

class BlocHomeRegularStoryType extends Cubit<int>{

  BlocHomeRegularStoryType() : super(0);
  void updateToggle(int index) => emit(index);
}

class BlocHomeRegularBackgroundImage extends Cubit<int>{

  BlocHomeRegularBackgroundImage() : super(0);
  void updateToggle(int index) => emit(index);
}




class BlocHomeRegularUpdateToggleFeed extends Cubit<int>{

  BlocHomeRegularUpdateToggleFeed() : super(0);
  void updateToggle(int index) => emit(index);
}

class BlocHomeRegularUpdateListSuggested extends Cubit<List<bool>>{

  BlocHomeRegularUpdateListSuggested() : super([false, false, false, false, false, false, false, false, false, false,]);

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

class BlocHomeRegularUpdateListNearby extends Cubit<List<bool>>{

  BlocHomeRegularUpdateListNearby() : super([false, false, false, false, false, false, false, false, false, false,]);

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

class BlocHomeRegularUpdateListBLM extends Cubit<List<bool>>{

  BlocHomeRegularUpdateListBLM() : super([false, false, false, false, false, false, false, false, false, false,]);

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

class BlocHomeRegularUpdateMemorialToggle extends Cubit<int>{

  BlocHomeRegularUpdateMemorialToggle() : super(0);
  void updateToggle(int index) => emit(index);
}

// class BlocHomeRegularCreateMemorial extends Cubit<APIRegularCreateMemorial>{

//   BlocHomeRegularCreateMemorial() : super(memorial);
//   // void updateToggle(int index) => emit(index);
// }

class BlocHomeRegularCreateMemorial extends Cubit<int>{

  BlocHomeRegularCreateMemorial() : super(0);
  void modify(int number) => emit(number);
}
