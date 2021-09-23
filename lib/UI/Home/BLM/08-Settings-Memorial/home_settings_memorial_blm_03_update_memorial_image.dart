import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_08_update_page_image.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_02_show_page_images.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_02_blm_dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_06_blm_button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_07_blm_background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeBLMMemorialPageImage extends StatefulWidget{
  final int memorialId;
  const HomeBLMMemorialPageImage({Key? key, required this.memorialId}) : super(key: key);

  @override
  HomeBLMMemorialPageImageState createState() => HomeBLMMemorialPageImageState();
}

class HomeBLMMemorialPageImageState extends State<HomeBLMMemorialPageImage>{
  List<String> backgroundImages = ['assets/icons/blm-memorial-cover-1.jpeg', 'assets/icons/blm-memorial-cover-2.jpeg'];
  ValueNotifier<File> backgroundImage = ValueNotifier<File>(File(''));
  ValueNotifier<File> profileImage = ValueNotifier<File>(File(''));
  ValueNotifier<int> backgroundImageToggle = ValueNotifier<int>(0);
  Future<APIBLMShowPageImagesMain>? futureMemorialSettings;
  final picker = ImagePicker();

  Future getProfileImage() async{
    try{
      final pickedFile = await picker.pickImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        profileImage.value = File(pickedFile.path);
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future getBackgroundImage() async{
    try{
      final pickedFile = await picker.pickImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        backgroundImage.value = File(pickedFile.path);
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future<APIBLMShowPageImagesMain> getMemorialSettings(int memorialId) async{
    return await apiBLMShowPageImages(memorialId: memorialId);
  }

  @override
  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(widget.memorialId);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: backgroundImage,
      builder: (_, File backgroundImageListener, __) => ValueListenableBuilder(
        valueListenable: profileImage,
        builder: (_, File profileImageListener, __) => ValueListenableBuilder(
          valueListenable: backgroundImageToggle,
          builder: (_, int backgroundImageToggleListener, __) => Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff04ECFF),
              title: const Text('Page Image', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                onPressed: () async{
                  if(profileImage.value.path != '' || (backgroundImage.value.path != '' && backgroundImageToggle.value != 0)){
                    bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to discard the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));
                    if(confirmResult){
                      Navigator.pop(context);
                    }
                  }else{
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: FutureBuilder<APIBLMShowPageImagesMain>(
              future: futureMemorialSettings,
              builder: (context, memorialImageSettings) {
                if(memorialImageSettings.hasData){
                  return Stack(
                    children: [
                      const MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            const SizedBox(height: 20,),

                            const Text('Upload or Select an Image', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                            const SizedBox(height: 20,),

                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: backgroundImageListener.path != ''
                                ? DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImageListener.path),)
                                : DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider('${memorialImageSettings.data!.blmMemorial.showPageImagesBackgroundImage}')),
                              ),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: const Color(0xffffffff),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: profileImageListener.path != ''
                                          ? CircleAvatar(
                                            radius: 120,
                                            backgroundColor: const Color(0xff888888),
                                            foregroundImage: AssetImage(profileImageListener.path),
                                            backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                          )
                                          : CircleAvatar(
                                            radius: 120,
                                            backgroundColor: const Color(0xff888888),
                                            foregroundImage: NetworkImage(memorialImageSettings.data!.blmMemorial.showPageImagesProfileImage),
                                            backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async{
                                      await getProfileImage();
                                    },
                                  ),
                                  Positioned(
                                    bottom: 40,
                                    left: SizeConfig.screenWidth! / 2,
                                    child: const CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Color(0xffffffff),
                                      child: CircleAvatar(radius: 25, backgroundColor: Colors.transparent, child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),),
                                    ),
                                  ),
                                  const Positioned(
                                    top: 10,
                                    right: 10,
                                    child: CircleAvatar(radius: 25, backgroundColor: Color(0xffffffff), child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20,),

                            const Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),

                            const SizedBox(height: 40,),

                            const Text('Choose Background', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                            const SizedBox(height: 20,),

                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                physics: const ClampingScrollPhysics(),
                                separatorBuilder: (context, index){
                                  return const SizedBox(width: 25,);
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index){
                                  return ((){
                                    if(index == 2){
                                      return GestureDetector(
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: const Icon(Icons.add_rounded, color: Color(0xff000000), size: 60,),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),),),
                                        ),
                                        onTap: () async{
                                          backgroundImageToggle.value = index;
                                          await getBackgroundImage();
                                        },
                                      );
                                    }else{
                                      return GestureDetector(
                                        child: backgroundImageToggleListener == index
                                        ? Container(
                                          padding: const EdgeInsets.all(5),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(color: const Color(0xff04ECFF), borderRadius: BorderRadius.circular(10),),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                          ),
                                        )
                                        : Container(
                                          padding: const EdgeInsets.all(5),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                          ),
                                        ),
                                        onTap: () async{
                                          final ByteData bytes = await rootBundle.load(backgroundImages[index]);
                                          final Uint8List list = bytes.buffer.asUint8List();

                                          final tempDir = await getTemporaryDirectory();
                                          final file = await File('${tempDir.path}/blm-background-image-$index.png').create();
                                          file.writeAsBytesSync(list);

                                          backgroundImageToggle.value = index;
                                          backgroundImage.value = file;
                                        },
                                      );
                                    }
                                  }());
                                },
                              ),
                            ),

                            const SizedBox(height: 20,),

                            const Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),

                            const SizedBox(height: 80,),

                            MiscBLMButtonTemplate(
                              buttonText: 'Update',
                              buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                              buttonColor: const Color(0xff04ECFF),
                              width: 150,
                              height: 50,
                              onPressed: () async{
                                if(profileImage.value.path != '' || backgroundImage.value.path != ''){
                                  context.loaderOverlay.show();
                                  bool result = await apiBLMUpdatePageImages(memorialId: widget.memorialId, backgroundImage: backgroundImage.value, profileImage: profileImage.value);
                                  context.loaderOverlay.hide();

                                  if(result){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                        description: const Text('Successfully updated the memorial image.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        onlyOkButton: true,
                                        onOkButtonPressed: (){
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    );
                                    Route route = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, managed: true, newlyCreated: false, relationship: memorialImageSettings.data!.blmMemorial.showPageImagesRelationship,),);
                                    Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/blm'));
                                  }else{
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                        description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }else if(memorialImageSettings.hasError){
                  return SizedBox(
                    height: SizeConfig.screenHeight,
                    child: const Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),
                  );
                }else{
                  return SizedBox(
                    height: SizeConfig.screenHeight,
                    child: Center(child: Container(child: const SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}