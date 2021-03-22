import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-04-upload-photo.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegularUploadPhoto extends StatefulWidget{

  RegularUploadPhotoState createState() => RegularUploadPhotoState();
}

class RegularUploadPhotoState extends State<RegularUploadPhoto>{

  File? image;
  final picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future openCamera() async{
    final profilePicture = await picker.getImage(source: ImageSource.camera);

    if(profilePicture != null){
      setState(() {
        image = File(profilePicture.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
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
                
              },
              child: Container(
                height: SizeConfig.screenWidth! / 1.2,
                width: SizeConfig.screenWidth! / 1.2,
                color: Color(0xffF9F8EE),
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: image != null
                        ? Stack(
                          children: [
                            Container(color: Color(0xffffffff),),

                            Align(
                              alignment: Alignment.center, 
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(image!),
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
              buttonText: image != null
              ? 'Sign Up'
              : 'Next',
              buttonTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, 
                color: Color(0xffffffff),
              ),
              width: SizeConfig.screenWidth! / 2,
              height: 45,
              buttonColor: Color(0xff04ECFF),
              onPressed: () async{
                if(image != null){

                  context.showLoaderOverlay();
                  bool result = await apiRegularUploadPhoto(image: image);
                  context.hideLoaderOverlay();

                  if(result){
                    Navigator.pushReplacementNamed(context, '/home/regular');
                  }else{
                    await showOkAlertDialog(
                      context: context,
                      title: 'Error',
                      message: 'Something went wrong. Please try again.',
                    );
                  }
                }else{
                  await showOkAlertDialog(
                    context: context,
                    title: 'Error',
                    message: 'Please upload a photo.',
                  );
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
    );
  }
}

