import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-09-message.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegularUploadPhoto extends StatefulWidget{

  RegularUploadPhotoState createState() => RegularUploadPhotoState();
}

class RegularUploadPhotoState extends State<RegularUploadPhoto>{

  File _image;
  final picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future openCamera() async{
    final profilePicture = await picker.getImage(source: ImageSource.camera);

    if(profilePicture != null){
      setState(() {
        _image = File(profilePicture.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateButtonText>(
          create: (context) => BlocUpdateButtonText(),
        ),
        BlocProvider<BlocShowMessage>(
          create: (context) => BlocShowMessage(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Stack(
          children: [

            BlocBuilder<BlocShowMessage, bool>(
              builder: (context, state){
                return state
                ? MiscMessageTemplate(message: 'Please upload a photo.',)
                : Container();
              },
            ),

            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Center(child: Text('Upload Photo', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 8, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  BlocBuilder<BlocUpdateButtonText, int>(
                    builder: (context, state){
                      return GestureDetector(
                        onTap: () async{
                          context.bloc<BlocUpdateButtonText>().add();

                          var choice = await showDialog(context: (context), builder: (build) => UploadFrom());

                          if(choice == null){
                            choice = 0;
                          }else{
                            if(choice == 1){
                              await openCamera();
                            }else{
                              await getImage();
                            }
                          }

                          context.bloc<BlocUpdateButtonText>().reset();
                          
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: _image != null
                                  ? Stack(
                                    children: [
                                      Container(color: Color(0xffffffff),),

                                      Align(alignment: Alignment.center, child: Image.asset(_image.path),),
                                    ],
                                  )
                                  : Stack(
                                    children: [
                                      Container(color: Color(0xffffffff),),

                                      Align(alignment: Alignment.center, child: Icon(Icons.add, color: Color(0xffE3E3E3), size: SizeConfig.safeBlockVertical * 30,),),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('Add a photo',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height: SizeConfig.blockSizeVertical * 50,
                          width: SizeConfig.screenWidth / 1.2,
                          color: Color(0xffF9F8EE),
                        ),
                      );
                    }
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                  BlocBuilder<BlocUpdateButtonText, int>(
                    builder: (context, state){
                      return MiscButtonTemplate(
                        buttonText: state == 1
                        ? 'Sign Up'
                        : 'Next',
                        buttonTextStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ), 
                        onPressed: (){
                          if(_image != null){
                            context.bloc<BlocShowMessage>().reset();
                            context.bloc<BlocUpdateButtonText>().reset();
                            Navigator.pushReplacementNamed(context, '/home/');
                          }else{
                            context.bloc<BlocShowMessage>().showMessage();
                            Duration duration = Duration(seconds: 2);

                            Future.delayed(duration, (){
                              context.bloc<BlocShowMessage>().showMessage();
                            });
                          }
                        }, 
                        width: SizeConfig.screenWidth / 2, 
                        height: SizeConfig.blockSizeVertical * 7, 
                        buttonColor: Color(0xff04ECFF),
                      );
                    }
                  ),

                  Expanded(child: Container(),),

                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Connect / ', 
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff888888),
                          ),
                        ),

                        TextSpan(
                          text: 'Remember / ',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff888888),
                          ),
                        ),

                        TextSpan(
                          text: 'Honor',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff888888),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

