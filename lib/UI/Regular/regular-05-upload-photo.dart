import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-04-upload-photo.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
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
        BlocProvider<BlocUpdateButtonText>(create: (context) => BlocUpdateButtonText(),),
        BlocProvider<BlocShowMessage>(create: (context) => BlocShowMessage(),),
      ],
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: ResponsiveWrapper(
          maxWidth: SizeConfig.screenWidth,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
          child: Container(
            height: SizeConfig.screenHeight,
            child: BlocBuilder<BlocUpdateButtonText, int>(
              builder: (context, textNumber){
                return BlocBuilder<BlocShowMessage, bool>(
                  builder: (context, showMessage){
                    return Stack(
                      children: [

                        SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                        ((){ return showMessage ? MiscRegularMessageTemplate(message: 'Please upload a photo.',) : Container(); }()),

                        SingleChildScrollView(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [

                              SizedBox(height: 40),

                              Center(
                                child: Text('Upload Photo', 
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold, 
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),

                              SizedBox(height: 40),

                              GestureDetector(
                                onTap: () async{
                                  context.read<BlocUpdateButtonText>().add();

                                  var choice = await showDialog(context: (context), builder: (build) => MiscRegularUploadFromDialog());

                                  if(choice == null){
                                    choice = 0;
                                  }else{
                                    if(choice == 1){
                                      await openCamera();
                                    }else{
                                      await getImage();
                                    }
                                  }

                                  context.read<BlocUpdateButtonText>().reset();
                                  
                                },
                                child: Container(
                                  height: SizeConfig.screenWidth / 1.2,
                                  width: SizeConfig.screenWidth / 1.2,
                                  color: Color(0xffF9F8EE),
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

                                              Align(
                                                alignment: Alignment.center, 
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: FileImage(_image),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                          : Stack(
                                            children: [
                                              Container(color: Color(0xffffffff),),

                                              Align(alignment: Alignment.center, child: Icon(Icons.add, color: Color(0xffE3E3E3), size: 250,),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text('Add a photo',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 80),

                              MiscRegularButtonTemplate(
                                buttonText: textNumber == 1
                                ? 'Sign Up'
                                : 'Next',
                                buttonTextStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xffffffff),
                                ),
                                width: SizeConfig.screenWidth / 2,
                                height: 45,
                                buttonColor: Color(0xff04ECFF),
                                onPressed: () async{
                                  if(_image != null){

                                    context.showLoaderOverlay();
                                    bool result = await apiRegularUploadPhoto(image: _image);
                                    context.hideLoaderOverlay();

                                    context.read<BlocUpdateButtonText>().reset();

                                    if(result){
                                      Navigator.pushReplacementNamed(context, '/home/regular');
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (_) => 
                                          AssetGiffyDialog(
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                          entryAnimation: EntryAnimation.DEFAULT,
                                          description: Text('Something went wrong. Please try again.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(),
                                          ),
                                          onlyOkButton: true,
                                          buttonOkColor: Colors.red,
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        )
                                      );
                                    }

                                  }else{
                                    context.read<BlocShowMessage>().showMessage();
                                    Duration duration = Duration(seconds: 2);

                                    Future.delayed(duration, (){
                                      context.read<BlocShowMessage>().showMessage();
                                    });
                                  }
                                },
                              ),

                              SizedBox(height: 20),

                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Connect / ', 
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff888888),
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'Remember / ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff888888),
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'Honor',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff888888),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),

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
        ),
      ),
    );
  }
}

