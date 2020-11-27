import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-09-blm-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-04-blm-upload-photo.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMUploadPhoto extends StatefulWidget{

  BLMUploadPhotoState createState() => BLMUploadPhotoState();
}

class BLMUploadPhotoState extends State<BLMUploadPhoto>{

  File _image;
  final picker = ImagePicker();

  File temporaryFile;
  

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
        BlocProvider<BlocUpdateButtonText>(create: (context) => BlocUpdateButtonText(),),
        BlocProvider<BlocShowMessage>(create: (context) => BlocShowMessage(),),
      ],
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: BlocBuilder<BlocUpdateButtonText, int>(
          builder: (context, textNumber){
            return BlocBuilder<BlocShowMessage, bool>(
              builder: (context, showMessage){
                return Stack(
                  children: [

                    ((){ return showMessage ? MiscBLMMessageTemplate(message: 'Please upload a photo.',) : Container(); }()),

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

                                  var choice = await showDialog(context: (context), builder: (build) => MiscBLMUploadFromDialog());

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
                                          child: Text('Select a photo',
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

                          MiscBLMButtonTemplate(
                            buttonText: textNumber == 1 ? 'Sign Up' : 'Speak Now',
                            buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
                            onPressed: () async{
                              if(_image != null){

                                context.showLoaderOverlay();
                                bool result = await apiBLMUploadPhoto(_image);
                                context.hideLoaderOverlay();

                                context.bloc<BlocUpdateButtonText>().reset();

                                if(result){
                                  Navigator.pushReplacementNamed(context, '/home/blm');
                                }else{
                                  await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.', color: Colors.red,));
                                }
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
                            buttonColor: textNumber == 1
                            ? Color(0xff04ECFF)
                            : Color(0xff000000),
                          ),

                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

