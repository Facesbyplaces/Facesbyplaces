import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMiscBLMNumberOfCommentLikes extends Cubit<List<int>>{
  
  BlocMiscBLMNumberOfCommentLikes() : super([]);
  void modify(List<int> value) => emit(value);
}

class BlocMiscBLMCommentLikesStatus extends Cubit<List<bool>>{
  
  BlocMiscBLMCommentLikesStatus() : super([]);
  void modify(List<bool> value) => emit(value);
}