import 'package:facesbyplaces/UI/BLM/blm-03-register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc/bloc-01-bloc.dart';
import 'Configurations/size_configuration.dart';
import 'UI/BLM/blm-01-join.dart';
import 'UI/BLM/blm-02-login.dart';
import 'UI/BLM/blm-04-verify-email.dart';
import 'UI/BLM/blm-05-upload-photo.dart';
import 'UI/Regular/regular-01-join.dart';
import 'UI/Regular/regular-02-login.dart';
import 'UI/Regular/regular-03-register.dart';
import 'UI/Regular/regular-04-verify-email.dart';
import 'UI/Regular/regular-05-upload-photo.dart';
import 'UI/ui-01-get-started.dart';
import 'UI/ui-02-login.dart';
import 'UI/ui-03-login02.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'Faces by Places',
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateCubit>(
          create: (context) => BlocUpdateCubit(),
        ),
        BlocProvider<BlocUpdateCubitBLM>(
          create: (context) => BlocUpdateCubitBLM(),
        ),
        BlocProvider<BlocShowMessage>(
          create: (context) => BlocShowMessage(),
        ),
        BlocProvider<BlocUpdateButtonText>(
          create: (context) => BlocUpdateButtonText(),
        ),
        BlocProvider<UpdateCubitRegular>(
          create: (context) => UpdateCubitRegular(),
        ),
      ],
      child: FacesByPlacesHome(),
    );

  }
}

class FacesByPlacesHome extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: Container(
            child: BlocBuilder<BlocUpdateCubit, int>(
              builder: (context, state){
                return ((){
                  switch(state){
                    case 0: return UIGetStarted(); break;
                    case 1: return UILogin01(); break;
                    case 2: return BlocBuilder<BlocUpdateCubitBLM, int>(
                      builder: (context, state){
                        return ((){
                          switch(state){
                            case 0: return BLMJoin(); break;
                            case 1: return BLMLogin(); break;
                            case 2: return BLMRegister(); break;
                            case 3: return BLMVerifyEmail(); break;
                            case 4: return BLMUploadPhoto(); break;
                            default: return BLMJoin(); break;
                          }
                        }());
                      },
                    ); break;
                    case 3: return BlocBuilder<UpdateCubitRegular, int>(
                      builder: (context, state){
                        return ((){
                          switch(state){
                            case 0: return RegularJoin(); break;
                            case 1: return RegularLogin(); break;
                            case 2: return RegularRegister(); break;
                            case 3: return RegularVerifyEmail(); break;
                            case 4: return RegularUploadPhoto(); break;
                          }
                        }());
                      },
                    ); break;
                    case 4: return UILogin02(); break;
                  }
                }());
              },
            ),
          ),
        ),
      ),
    );
  }
}