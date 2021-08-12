import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-02-show-page-images.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-08-update-page-image.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
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

class HomeRegularMemorialPageImage extends StatefulWidget{
  final int memorialId;
  const HomeRegularMemorialPageImage({required this.memorialId});

  HomeRegularMemorialPageImageState createState() => HomeRegularMemorialPageImageState();
}

class HomeRegularMemorialPageImageState extends State<HomeRegularMemorialPageImage>{
  List<String> backgroundImages = ['assets/icons/alm-memorial-cover-1.jpeg', 'assets/icons/alm-memorial-cover-2.jpeg'];
  Future<APIRegularShowPageImagesMain>? futureMemorialSettings;
  ValueNotifier<File> backgroundImage = ValueNotifier<File>(File(''));
  ValueNotifier<File> profileImage = ValueNotifier<File>(File(''));
  ValueNotifier<int> backgroundImageToggle = ValueNotifier<int>(0);
  final picker = ImagePicker();

  Future getProfileImage() async{
    try{
      final pickedFile = await picker.getImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        profileImage.value = File(pickedFile.path);
      }
    }catch (error){
      print('Error: ${error.toString()}');
    }
  }

  Future getBackgroundImage() async{
    try{
      final pickedFile = await picker.getImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        backgroundImage.value = File(pickedFile.path);
      }
    }catch (error){
      print('Error: ${error.toString()}');
    }
  }

  Future<APIRegularShowPageImagesMain> getMemorialSettings(int memorialId) async{
    return await apiRegularShowPageImages(memorialId: memorialId);
  }

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
              centerTitle: true,
              title: Row(
                children: [
                  Text('Page Image', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),

                  Spacer(),
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52,),
                onPressed: () async{
                  if(profileImage.value.path != '' || (backgroundImage.value.path != '' && backgroundImageToggle.value != 0)){
                    bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to discard the changes?', confirmColor_1: const Color(0xff04ECFF), confirmColor_2: const Color(0xffFF0000),),);

                    if(confirmResult){
                      Navigator.pop(context);
                    }
                  }else{
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: FutureBuilder<APIRegularShowPageImagesMain>(
              future: futureMemorialSettings,
              builder: (context, memorialImageSettings){
                if(memorialImageSettings.hasData){
                  return Stack(
                    children: [
                      const MiscRegularBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            const SizedBox(height: 20,),

                            Text('Upload or Select an Image', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.65, fontFamily: 'NexaRegular',color: const Color(0xff000000),),),
                            
                            SizedBox(height: 20,),

                            Container(
                              height: 200,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                              image: backgroundImageListener.path != ''
                              ? DecorationImage(fit: BoxFit.cover, image: AssetImage('${backgroundImageListener.path}'),)
                              : DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider('${memorialImageSettings.data!.almMemorial.showPageImagesBackgroundImage}'),),),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xffffffff),
                                        radius: 50,
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
                                            foregroundImage: NetworkImage(memorialImageSettings.data!.almMemorial.showPageImagesProfileImage),
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
                                    left: SizeConfig.screenWidth! / 2,
                                    bottom: 40,
                                    child: const CircleAvatar(
                                      child: const CircleAvatar(radius: 25, backgroundColor: Colors.transparent, child: const Icon(Icons.camera, color: const Color(0xffaaaaaa), size: 45,),),
                                      backgroundColor: const Color(0xffffffff),
                                      radius: 25,
                                    ),
                                  ),

                                  const Positioned(
                                    child: const CircleAvatar(radius: 25, backgroundColor: const Color(0xffffffff), child: const Icon(Icons.camera, color: const Color(0xffaaaaaa), size: 45,),),
                                    right: 10,
                                    top: 10,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20,),

                            Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),),

                            const SizedBox(height: 40,),

                            Text('Choose Background',style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.65, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                            const SizedBox(height: 20,),

                            Container(
                              height: 100,
                              child: ListView.separated(
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                separatorBuilder: (context, index){
                                  return const SizedBox(width: 25,);
                                },
                                itemBuilder: (context, index){
                                  return ((){
                                    if(index == 2){
                                      return GestureDetector(
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: const Icon(Icons.add_rounded, color: const Color(0xff000000), size: 60,),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xffcccccc),
                                            border: Border.all(color: const Color(0xff000000),),
                                          ),
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
                                          decoration: BoxDecoration(color: const Color(0xff04ECFF), borderRadius: BorderRadius.circular(10),),
                                          padding: const EdgeInsets.all(5),
                                          height: 100,
                                          width: 100,
                                          child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                            height: 100,
                                            width: 100,
                                          ),
                                        )
                                        : Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                                          padding: const EdgeInsets.all(5),
                                          height: 100,
                                          width: 100,
                                          child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                        onTap: () async{
                                          final ByteData bytes = await rootBundle.load(backgroundImages[index]);
                                          final Uint8List list = bytes.buffer.asUint8List();

                                          final tempDir = await getTemporaryDirectory();
                                          final file = await new File('${tempDir.path}/regular-background-image-$index.png').create();
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

                            Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),),

                            const SizedBox(height: 80,),

                            MiscRegularButtonTemplate(
                              buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffFFFFFF)),
                              buttonColor: const Color(0xff000000),
                              buttonText: 'Speak Out',
                              width: 150,
                              height: 45,
                              onPressed: () async{
                                if(profileImage.value.path != '' || backgroundImage.value.path != ''){
                                  context.loaderOverlay.show();
                                  bool result = await apiRegularUpdatePageImages(memorialId: widget.memorialId, backgroundImage: backgroundImage.value, profileImage: profileImage.value);
                                  context.loaderOverlay.hide();

                                  if(result){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        description: Text('Successfully updated the memorial image.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                        title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        onlyOkButton: true,
                                        onOkButtonPressed: (){
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    );
                                    Route route = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, managed: true, newlyCreated: false, relationship: memorialImageSettings.data!.almMemorial.showPageImagesRelationship));
                                    Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/regular'));
                                  }else{
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                        title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
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
                  return Container(height: SizeConfig.screenHeight, child: const Center(child: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),),);
                }else{
                  return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}