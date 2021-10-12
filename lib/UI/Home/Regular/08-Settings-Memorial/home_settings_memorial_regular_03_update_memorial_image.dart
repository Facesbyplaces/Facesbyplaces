import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_02_show_page_images.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_08_update_page_image.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeRegularMemorialPageImage extends StatefulWidget{
  final int memorialId;
  const HomeRegularMemorialPageImage({Key? key, required this.memorialId}) : super(key: key);

  @override
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

  Future<APIRegularShowPageImagesMain> getMemorialSettings(int memorialId) async{
    return await apiRegularShowPageImages(memorialId: memorialId);
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
              centerTitle: false,
              title: const Text('Page Image', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                onPressed: () async{
                  if(profileImage.value.path != '' || (backgroundImage.value.path != '' && backgroundImageToggle.value != 0)){
                    bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Confirm', content: 'Do you want to discard the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),),);

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
                      const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                              image: backgroundImageListener.path != ''
                              ? DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImageListener.path),)
                              : DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(memorialImageSettings.data!.almMemorial.showPageImagesBackgroundImage),),),
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
                                      child: CircleAvatar(radius: 25, backgroundColor: Colors.transparent, child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),),
                                      backgroundColor: Color(0xffffffff),
                                      radius: 25,
                                    ),
                                  ),

                                  const Positioned(
                                    child: CircleAvatar(radius: 25, backgroundColor: Color(0xffffffff), child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),),
                                    right: 10,
                                    top: 10,
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
                                          child: const Icon(Icons.add_rounded, color: Color(0xff000000), size: 60,),
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
                                          final file = await File('${tempDir.path}/regular-background-image-$index.png').create();
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

                            MiscButtonTemplate(
                              buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF)),
                              buttonColor: const Color(0xff000000),
                              buttonText: 'Speak Out',
                              width: 150,
                              height: 50,
                              onPressed: () async{
                                if(profileImage.value.path != '' || backgroundImage.value.path != ''){
                                  context.loaderOverlay.show();
                                  bool result = await apiRegularUpdatePageImages(memorialId: widget.memorialId, backgroundImage: backgroundImage.value, profileImage: profileImage.value);
                                  context.loaderOverlay.hide();

                                  if(result){
                                    await showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: 'Success',
                                        description: 'Successfully updated the memorial image.',
                                        okButtonColor: const Color(0xff4caf50), // GREEN
                                        includeOkButton: true,
                                      ),
                                    );
                                    Route route = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, managed: true, newlyCreated: false, relationship: memorialImageSettings.data!.almMemorial.showPageImagesRelationship));
                                    Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/regular'));
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
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }else if(memorialImageSettings.hasError){
                  return SizedBox(height: SizeConfig.screenHeight, child: const Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),);
                }else{
                  return SizedBox(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}