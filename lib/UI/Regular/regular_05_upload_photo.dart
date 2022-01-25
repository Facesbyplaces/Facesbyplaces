import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_04_upload_photo.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class RegularUploadPhoto extends StatefulWidget{
  const RegularUploadPhoto({Key? key}) : super(key: key);

  @override
  RegularUploadPhotoState createState() => RegularUploadPhotoState();
}

class RegularUploadPhotoState extends State<RegularUploadPhoto>{
  ValueNotifier<File> image = ValueNotifier<File>(File(''));
  final picker = ImagePicker();

  Future getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      // File newFile = await compressImage(File(pickedFile.path));
      // image.value = newFile;
      image.value = File(pickedFile.path);
    }
  }

  Future openCamera() async{
    final profilePicture = await picker.pickImage(source: ImageSource.camera);

    if(profilePicture != null){
      // File newFile = await compressImage(File(profilePicture.path));
      // image.value = newFile;
      image.value = File(profilePicture.path);
    }
  }

  Future<File> compressImage(File file) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path, percentage: 5);

    return compressedFile;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: image,
      builder: (_, File imageListener, __) => RepaintBoundary(
        child: Scaffold(
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
                          const SizedBox(height: 40),

                          const Center(child: Text('Upload Photo', style: TextStyle(fontSize: 42, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),

                          const SizedBox(height: 40),

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
                                          ? Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: FileImage(imageListener),),),),
                                          )
                                          : const Align(
                                            alignment: Alignment.center,
                                            child: Icon(Icons.add, color: Color(0xffE3E3E3), size: 250,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const Text('A valid photo of yourself would be a better choice because it would be worth a thousand words.',
                                    style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async{
                              var choice = await showDialog(context: (context), builder: (build) => const MiscUploadFromDialog());

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

                          const Expanded(child: SizedBox()),

                          const SizedBox(height: 50),

                          MiscButtonTemplate(
                            buttonText: imageListener.path != '' ? 'Sign Up' : 'Next',
                            buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                            buttonColor: const Color(0xff04ECFF),
                            width: SizeConfig.screenWidth! / 2,
                            height: 50,
                            onPressed: () async{
                              if(imageListener.path != ''){
                                context.loaderOverlay.show();
                                File newFile = await compressImage(imageListener);
                                imageListener = newFile;

                                bool result = await apiRegularUploadPhoto(image: imageListener);
                                context.loaderOverlay.hide();

                                if(result){
                                  Navigator.pushReplacementNamed(context, '/home/regular');
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (context) => CustomDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: 'Error',
                                      description: 'Something went wrong. Please try again.',
                                      okButtonColor: const Color(0xfff44336), // RED
                                      includeOkButton: true,
                                    ),
                                  );
                                }
                              }else{
                                await showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: 'Error',
                                    description: 'Please upload a photo.',
                                    okButtonColor: const Color(0xfff44336), // RED
                                    includeOkButton: true,
                                  ),
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 50),

                          RichText(
                            text: const TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: 'Connect / ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Color(0xff888888),),),

                                TextSpan(text: 'Remember / ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Color(0xff888888),),),

                                TextSpan(text: 'Honor', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Color(0xff888888),),),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}