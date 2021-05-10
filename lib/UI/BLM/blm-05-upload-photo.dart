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
      setState(() {
        image.value = File(profilePicture.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('Upload photo blm screen build!');
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [

            const SizedBox(height: 40,),

            const Center(child: const Text('Upload Photo', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: () async{

                var choice = await showDialog(context: (context), builder: (build) => const MiscBLMUploadFromDialog());

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
                        child: ValueListenableBuilder(
                          valueListenable: image,
                          builder: (_, File imageListener, __) => imageListener.path != ''
                          ? Stack(
                            children: [
                              Container(color: const Color(0xffffffff),),

                              Align(
                                alignment: Alignment.center, 
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(image.value),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Stack(
                            children: [
                              Container(color: const Color(0xffffffff),),

                              Align(alignment: Alignment.center, child: const Icon(Icons.add, color: const Color(0xffE3E3E3), size: 250,),),
                            ],
                          ),
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

            const SizedBox(height: 80,),

            MiscBLMButtonTemplate(
              buttonText: image.value.path != '' ? 'Sign Up' : 'Speak Now',
              buttonTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),
              width: SizeConfig.screenWidth! / 2,
              height: 45,
              buttonColor: image.value.path != ''
              ? const Color(0xff04ECFF)
              : const Color(0xff000000),
              onPressed: () async{
                if(image.value.path != ''){

                  context.loaderOverlay.show();
                  bool result = await apiBLMUploadPhoto(image: image);
                  context.loaderOverlay.hide();

                  if(result){
                    Navigator.pushReplacementNamed(context, '/home/blm');
                  }else{
                    await showDialog(
                      context: context,
                      builder: (_) => 
                        AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: const Text('Something went wrong. Please try again.',
                          textAlign: TextAlign.center,
                        ),
                        onlyOkButton: true,
                        buttonOkColor: const Color(0xffff0000),
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
                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Please upload a photo.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      buttonOkColor: const Color(0xffff0000),
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                }
              },
            ),

            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
}