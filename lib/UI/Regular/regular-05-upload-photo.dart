import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-04-upload-photo.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateButtonText>(create: (context) => BlocUpdateButtonText(),),
        BlocProvider<BlocShowMessage>(create: (context) => BlocShowMessage(),),
      ],
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: ContainerResponsive(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          alignment: Alignment.center,
          child: ContainerResponsive(
            width: SizeConfig.screenWidth,
            heightResponsive: false,
            widthResponsive: true,
            alignment: Alignment.center,
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

                              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                              Center(
                                child: Text('Upload Photo', 
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true),
                                    fontWeight: FontWeight.bold, 
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

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

                                              // Align(alignment: Alignment.center, child: Image.asset(_image.path),),
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

                                              Align(alignment: Alignment.center, child: Icon(Icons.add, color: Color(0xffE3E3E3), size: SizeConfig.safeBlockVertical * 30,),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text('Add a photo',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  height: ScreenUtil().setHeight(335),
                                  width: SizeConfig.screenWidth / 1.2,
                                  color: Color(0xffF9F8EE),
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                              MiscRegularButtonTemplate(
                                buttonText: textNumber == 1
                                ? 'Sign Up'
                                : 'Next',
                                buttonTextStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xffffffff),
                                ), 
                                onPressed: () async{
                                  if(_image != null){

                                    context.showLoaderOverlay();
                                    bool result = await apiRegularUploadPhoto(image: _image);
                                    context.hideLoaderOverlay();

                                    context.read<BlocUpdateButtonText>().reset();

                                    if(result){
                                      Navigator.pushReplacementNamed(context, '/home/regular');
                                    }else{
                                      await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.', color: Colors.red,));
                                    }

                                  }else{
                                    context.read<BlocShowMessage>().showMessage();
                                    Duration duration = Duration(seconds: 2);

                                    Future.delayed(duration, (){
                                      context.read<BlocShowMessage>().showMessage();
                                    });
                                  }
                                }, 
                                width: SizeConfig.screenWidth / 2, 
                                height: ScreenUtil().setHeight(45),
                                buttonColor: Color(0xff04ECFF),
                              ),

                              SizedBox(height: ScreenUtil().setHeight(20)),

                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Connect / ', 
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff888888),
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'Remember / ',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff888888),
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'Honor',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
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

