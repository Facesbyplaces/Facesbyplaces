import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-04-upload-photo.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMUploadPhoto extends StatefulWidget{

  BLMUploadPhotoState createState() => BLMUploadPhotoState();
}

class BLMUploadPhotoState extends State<BLMUploadPhoto>{

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

            SizedBox(height: 40,),

            Center(child: Text('Upload Photo', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

            SizedBox(height: 40,),

            GestureDetector(
              onTap: () async{

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
                                    fit: BoxFit.cover,
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
                        child: Text('A valid photo of yourself would be a better choice because it would be worth a thousand words.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 80,),

            MiscBLMButtonTemplate(
              buttonText: image != null ? 'Sign Up' : 'Speak Now',
              buttonTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
              width: SizeConfig.screenWidth! / 2,
              height: 45,
              buttonColor: image != null
              ? Color(0xff04ECFF)
              : Color(0xff000000),
              onPressed: () async{
                if(image != null){

                  context.showLoaderOverlay();
                  bool result = await apiBLMUploadPhoto(image: image);
                  context.hideLoaderOverlay();

                  if(result){
                    Navigator.pushReplacementNamed(context, '/home/blm');
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
                  await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: Text('Please upload a photo.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      buttonOkColor: Colors.red,
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                }
              },
            ),

            SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
}