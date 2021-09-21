// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-04-upload-photo.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMUploadPhoto extends StatefulWidget{
  const BLMUploadPhoto({Key? key}) : super(key: key);

  @override
  BLMUploadPhotoState createState() => BLMUploadPhotoState();
}

class BLMUploadPhotoState extends State<BLMUploadPhoto>{
  ValueNotifier<File> image = ValueNotifier<File>(File(''));
  final picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      image.value = File(pickedFile.path);
    }
  }

  Future openCamera() async{
    final profilePicture = await picker.pickImage(source: ImageSource.camera);

    if(profilePicture != null){
      setState((){
        image.value = File(profilePicture.path);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: image,
      builder: (_, File imageListener, __) => Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraint){
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 40,),

                        const Center(child: Text('Upload Photo', style: TextStyle(fontSize: 42, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),

                        const SizedBox(height: 40,),

                        GestureDetector(
                          child: Container(
                            height: SizeConfig.screenWidth! / 1.2,
                            width: SizeConfig.screenWidth! / 1.2,
                            color: const Color(0xffF9F8EE),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Stack(
                                      children: [
                                        Container(color: const Color(0xffffffff),),

                                        imageListener.path != ''
                                        ? Align(alignment: Alignment.center, child: Container(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: FileImage(imageListener),),),),)
                                        : const Align(alignment: Alignment.center, child: Icon(Icons.add, color: Color(0xffE3E3E3), size: 250,),),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const Text('A valid photo of yourself would be a better choice because it would be worth a thousand words.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                ),
                              ],
                            ),
                          ),
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
                        ),

                        Expanded(child: Container()),

                        const SizedBox(height: 50),

                        MiscBLMButtonTemplate(
                          buttonText: imageListener.path != '' ? 'Sign Up' : 'Speak Now',
                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                          buttonColor: imageListener.path != '' ? const Color(0xff04ECFF) : const Color(0xff000000),
                          width: SizeConfig.screenWidth! / 2,
                          height: 50,
                          onPressed: () async{
                            if(imageListener.path != ''){
                              context.loaderOverlay.show();
                              bool result = await apiBLMUploadPhoto(image: imageListener);
                              context.loaderOverlay.hide();

                              if(result){
                                Navigator.pushReplacementNamed(context, '/home/blm');
                              }else{
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                    description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    buttonOkColor: const Color(0xffff0000),
                                    onlyOkButton: true,
                                    onOkButtonPressed: (){
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                              }
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                  description: const Text('Please upload a photo.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  buttonOkColor: const Color(0xffff0000),
                                  onlyOkButton: true,
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}