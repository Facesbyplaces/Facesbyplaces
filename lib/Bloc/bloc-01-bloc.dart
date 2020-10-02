import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCubit extends Cubit<int>{

  UpdateCubit() : super(0);

  void forward() => emit(state + 1);
  void backward() => emit(state - 1);
  void forwardTimes(int number) => emit(state + number);
  void backwardTimes(int number) => emit(state - number);
  void reset() => emit(0);
}

class UpdateCubitBLM extends Cubit<int>{

  UpdateCubitBLM() : super(0);

  void forward() => emit(state + 1);
  void backward() => emit(state - 1);
  void forwardTimes(int number) => emit(state + number);
  void backwardTimes(int number) => emit(state - number);
  void reset() => emit(0);
}

class UpdateCubitRegular extends Cubit<int>{

  UpdateCubitRegular() : super(0);

  void forward() => emit(state + 1);
  void backward() => emit(state - 1);
  void forwardTimes(int number) => emit(state + number);
  void backwardTimes(int number) => emit(state - number);
  void reset() => emit(0);
}


class BlocShowMessage extends Cubit<bool>{

  BlocShowMessage() : super(false);

  void showMessage() => emit(!state);  
  void reset() => emit(false);
}

class BlocUpdateButtonText extends Cubit<int>{

  BlocUpdateButtonText() : super(0);

  void add() => emit(state + 1);
  void remove() => emit(state - 1);
  void reset() => emit(0);
}

// class BlocSetProfilePicture extends Cubit<File>{

//   File _newImage;

//   BlocSetProfilePicture() : super(null);

//   Future getImage() async{
//     File _image;
//     final _picker = ImagePicker();
//     final pickedFile = await _picker.getImage(source: ImageSource.gallery);

//     if(pickedFile != null){
//       _image = File(pickedFile.path);
//     }
    
//     // return _image;
//     _newImage = _image;
//   }

//   File setImage(){
//     getImage();
//     return _newImage;
//   }

//   void setProfile() => emit(setImage());
  
// }

