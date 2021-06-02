import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-04-upload-photo.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegularUploadPhoto extends StatefulWidget{

  RegularUploadPhotoState createState() => RegularUploadPhotoState();
}

class RegularUploadPhotoState extends State<RegularUploadPhoto>{

  ValueNotifier<File> image = ValueNotifier<File>(File(''));
  final picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      image.value = File(pickedFile.path);
    }
  }

  Future openCamera() async{
    final profilePicture = await picker.getImage(source: ImageSource.camera);

    if(profilePicture != null){
      image.value = File(profilePicture.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: image,
      builder: (_, File imageListener, __) => RepaintBoundary(
        child: Scaffold(
          backgroundColor: Color(0xffffffff),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [

                const SizedBox(height: 40),

                const Center(
                  child: const Text('Upload Photo',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold, 
                      color: const Color(0xff000000),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

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
                    color: const Color(0xffF9F8EE),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Stack(
                              children: [
                                Container(color: const Color(0xffffffff),),

                                imageListener.path != ''
                                ? Align(
                                  alignment: Alignment.center, 
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(imageListener),
                                      ),
                                    ),
                                  ),
                                )
                                : Align(
                                  alignment: Alignment.center, 
                                  child: const Icon(Icons.add, color: const Color(0xffE3E3E3), size: 250,),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: const Center(
                            child: const Text('A valid photo of yourself would be a better choice because it would be worth a thousand words.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                MiscRegularButtonTemplate(
                  buttonText: imageListener.path != '' ? 'Sign Up' : 'Next',
                  buttonTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),
                  width: SizeConfig.screenWidth! / 2,
                  height: 45,
                  buttonColor: const Color(0xff04ECFF),
                  onPressed: () async{
                    if(imageListener.path != ''){

                      context.loaderOverlay.show();
                      bool result = await apiRegularUploadPhoto(image: imageListener);
                      context.loaderOverlay.hide();

                      if(result){
                        Navigator.pushReplacementNamed(context, '/home/regular');
                      }else{
                        await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error', textAlign: TextAlign.center,  style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
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
                        builder: (_) => AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Error', textAlign: TextAlign.center,  style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Please upload a photo.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
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

                const SizedBox(height: 20),

                RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Connect / ', 
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff888888),
                        ),
                      ),

                      const TextSpan(
                        text: 'Remember / ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff888888),
                        ),
                      ),

                      const TextSpan(
                        text: 'Honor',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xff888888),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}