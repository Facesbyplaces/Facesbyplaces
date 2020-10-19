import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class BlocUpdateCubit extends Cubit<int>{

  BlocUpdateCubit() : super(0);
  void modify(int number) => emit(number);
}

class BlocUpdateCubitBLM extends Cubit<int>{

  BlocUpdateCubitBLM() : super(0);
  void modify(int number) => emit(number);
}

class UpdateCubitRegular extends Cubit<int>{

  UpdateCubitRegular() : super(0);
  void modify(int number) => emit(number);
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


class BlocUpdateProfilePicture extends Cubit<Future<File>>{

  Future<File> getImage() async{
    File _image;
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      _image = File(pickedFile.path);
    }

    return _image;
  }

  BlocUpdateProfilePicture() : super(null);

  void updateImage() => emit(getImage());
}
