import 'package:facesbyplaces/API/BLM/04-Create-Memorial/api_create_memorial_blm_01_create_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_compress/video_compress.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:better_player/better_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeBLMCreateMemorial2 extends StatefulWidget{
  final String relationship;
  final String locationOfIncident;
  final String rip;
  final String country;
  final String state;
  final String latitude;
  final String longitude;
  const HomeBLMCreateMemorial2({Key? key, required this.relationship, required this.locationOfIncident, required this.rip, required this.country, required this.state, required this.latitude, required this.longitude}) : super(key: key);

  @override
  HomeBLMCreateMemorial2State createState() => HomeBLMCreateMemorial2State();
}

class HomeBLMCreateMemorial2State extends State<HomeBLMCreateMemorial2> with TickerProviderStateMixin{
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  TextEditingController controllerStory = TextEditingController(text: '');
  ValueNotifier<List<File>> slideImages = ValueNotifier<List<File>>([]);
  ValueNotifier<File> videoFile = ValueNotifier<File>(File(''));
  ValueNotifier<int> slideCount = ValueNotifier<int>(0);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<File> videoThumbnail = ValueNotifier<File>(File(''));
  TabController? controller1;
  TabController? controller2;
  ValueNotifier<File> backgroundImage = ValueNotifier<File>(File(''));
  ValueNotifier<File> profileImage = ValueNotifier<File>(File(''));
  ValueNotifier<int> backgroundImageToggle = ValueNotifier<int>(0);
  List<String> backgroundImages = ['assets/icons/blm-memorial-cover-1.jpeg', 'assets/icons/blm-memorial-cover-2.jpeg'];

  @override
  void initState(){
    super.initState();
    controller1 = TabController(initialIndex: 0, length: 2, vsync: this);
    controller2 = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  Future getVideo() async{
    try{
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        videoFile.value = File(pickedFile.path);

        Uint8List? uint8list = await VideoThumbnail.thumbnailData(
          video: videoFile.value.path,
          imageFormat: ImageFormat.JPEG,
        );

        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          videoFile.value.path,
          quality: VideoQuality.LowQuality, 
          deleteOrigin: false, // It's false by default
        );

        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/blm-qr-code.png').create();
        file.writeAsBytesSync(uint8list!);

        videoThumbnail.value = file;
        videoFile.value = mediaInfo!.file!;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future getSlideImage() async{
    try{
      final pickedFile = await picker.pickMultiImage().then((picture){
        return picture;
      });

      if(pickedFile != null){
        List<File> newFiles = await compressMultipleImages(pickedFile);
        slideImages.value.addAll(newFiles);
        slideCount.value += pickedFile.length;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future getCroppedImage() async{
    try{
      File? croppedFile = await ImageCropper.cropImage(
        sourcePath: profileImage.value.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: const AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: Colors.deepOrange, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false), iosUiSettings: const IOSUiSettings( minimumAspectRatio: 1.0,),
      );

      if(croppedFile != null){
        profileImage.value = croppedFile;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future getProfileImage() async{
    try{
      final pickedFile = await picker.pickImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        File newFile = await compressImage(File(pickedFile.path));
        profileImage.value = newFile;
      }

      await getCroppedImage();
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
        File newFile = await compressImage(File(pickedFile.path));
        backgroundImage.value = newFile;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future<File> compressImage(File file) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path, percentage: 50);

    return compressedFile;
  }

  Future<List<File>> compressMultipleImages(List<XFile> files) async {
    List<File> newFiles = [];

    for(int i = 0; i < files.length; i++){
      File compressedFile = await FlutterNativeImage.compressImage(File(files[i].path).path, percentage: 50);
      newFiles.add(compressedFile);
    }

    return newFiles;
  }


  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: toggle,
          builder: (_, int toggleListener, __) => Scaffold(
            appBar: AppBar(
              title: const Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              backgroundColor: const Color(0xff04ECFF),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: SizedBox(height: SizeConfig.screenHeight, child: const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          MiscInputFieldTemplate(
                            key: _key1, 
                            labelText: 'Name of your Memorial Page',
                          ),

                          const SizedBox(height: 20,),

                          DefaultTabController(
                            length: 2,
                            child: TabBar(
                              indicator: const BoxDecoration(border: Border(left: BorderSide(width: 1, color: Color(0xff000000)), right: BorderSide(width: 1, color: Color(0xff000000))),),
                              unselectedLabelColor: const Color(0xff888888),
                              labelColor: const Color(0xff000000),
                              indicatorColor: Colors.transparent,
                              tabs: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text('PROFILE PICTURE', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: 'NexaBold',),),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff04ECFF),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text('BACKGROUND PICTURE', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: 'NexaBold',),),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff04ECFF),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                ),

                              ],
                              onTap: (int number){
                                controller1!.animateTo(number);
                              },
                            ),
                          ),

                          const SizedBox(height: 20,),

                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              controller: controller1,
                              children: [
                                profilePicture(),

                                backgroundPicture(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 50,),

                          DefaultTabController(
                            length: 3,
                            child: TabBar(
                              indicator: const BoxDecoration(border: Border(left: BorderSide(width: 1, color: Color(0xff000000)), right: BorderSide(width: 1, color: Color(0xff000000))),),
                              unselectedLabelColor: const Color(0xff888888),
                              labelColor: const Color(0xff000000),
                              indicatorColor: Colors.transparent,
                              tabs: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text('TEXT', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: 'NexaBold',),),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff04ECFF),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text('VIDEO', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: 'NexaBold',),),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff04ECFF),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text('SLIDE', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: 'NexaBold',),),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff04ECFF),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                              ],
                              onTap: (int number){
                                controller2!.animateTo(number);
                              },
                            ),
                          ),

                          const SizedBox(height: 20,),

                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              controller: controller2,
                              children: [
                                shareStory1(),

                                shareStory2(),

                                shareStory3(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20,),

                          const Center(child: Text('Share your Memories', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),),

                          const SizedBox(height: 80,),
                          
                          MiscButtonTemplate(
                            buttonText: 'Create my Memorial Page',
                            buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),
                            width: SizeConfig.screenWidth! / 1.2,
                            height: 50,
                            onPressed: () async{
                              if(!(_formKey.currentState!.validate())){
                                await showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: 'Error',
                                    description: 'Please input the name of the memorial page.',
                                    okButtonColor: const Color(0xfff44336), // RED
                                    includeOkButton: true,
                                  ),
                                );
                              }else{
                                if(backgroundImageToggle.value == 0 || backgroundImageToggle.value == 1){
                                  if(backgroundImageToggle.value == 0){
                                    final ByteData bytes = await rootBundle.load('assets/icons/blm-memorial-cover-1.jpeg');
                                    final Uint8List list = bytes.buffer.asUint8List();

                                    final tempDir = await getTemporaryDirectory();
                                    final file = await File('${tempDir.path}/blm-background-image-${backgroundImageToggle.value}.png').create();
                                    file.writeAsBytesSync(list);

                                    File newFile = await compressImage(file);
                                    backgroundImage.value = newFile;
                                  }else if(backgroundImageToggle.value == 1){
                                    final ByteData bytes = await rootBundle.load('assets/icons/blm-memorial-cover-2.jpeg');
                                    final Uint8List list = bytes.buffer.asUint8List();

                                    final tempDir = await getTemporaryDirectory();
                                    final file = await File('${tempDir.path}/blm-background-image-${backgroundImageToggle.value}.png').create();
                                    file.writeAsBytesSync(list);

                                    File newFile = await compressImage(file);
                                    backgroundImage.value = newFile;
                                  }
                                }

                                if(profileImage.value.path == ''){
                                  final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                                  final Uint8List list = bytes.buffer.asUint8List();

                                  final tempDir = await getTemporaryDirectory();
                                  final file = await File('${tempDir.path}/blm-profile-image.png').create();
                                  file.writeAsBytesSync(list);

                                  profileImage.value = file;
                                }

                                List<dynamic> newFiles = [];

                                if(videoFile.value.path != ''){
                                  newFiles.add(videoFile.value);
                                }

                                if(slideImages.value != []){
                                  newFiles.addAll(slideImages.value);
                                }

                                APIBLMCreateMemorial memorial = APIBLMCreateMemorial(
                                  blmMemorialName: _key1.currentState!.controller.text,
                                  blmDescription: controllerStory.text,
                                  blmLocationOfIncident: widget.locationOfIncident,
                                  blmRip: widget.rip,
                                  blmState: widget.state,
                                  blmCountry: widget.country,
                                  blmRelationship: widget.relationship,
                                  blmBackgroundImage: backgroundImage.value,
                                  blmProfileImage: profileImage.value,
                                  blmImagesOrVideos: newFiles,
                                  blmLatitude: widget.latitude,
                                  blmLongitude: widget.longitude,
                                );

                                context.loaderOverlay.show(widget: const CustomLoaderTextLoader());
                                int result = await apiBLMCreateMemorial(blmMemorial: memorial);
                                context.loaderOverlay.hide();

                                if(result != 0){
                                  Route newRoute = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: result, managed: true, newlyCreated: true, relationship: widget.relationship,),);
                                  Navigator.pushReplacement(context, newRoute);
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

                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profilePicture(){
    return ValueListenableBuilder(
      valueListenable: profileImage,
      builder: (_, File profileImageListener, __) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(
                child: Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: const Color(0xffffffff),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: profileImageListener.path != ''
                      ? CircleAvatar(
                        radius: 100,
                        backgroundColor: const Color(0xff888888),
                        foregroundImage: FileImage(profileImageListener),
                        backgroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                      )
                      : const CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff888888),
                        foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
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
                bottom: 0,
                child: const CircleAvatar(
                  child: CircleAvatar(radius: 25, backgroundColor: Colors.transparent, child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: 45,),),
                  backgroundColor: Color(0xffffffff),
                  radius: 25,
                ),
              ),
            ],
          ),

          const SizedBox(height: 50,),

          const Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
        ],
      ),
    );
  }

  backgroundPicture(){
    return ValueListenableBuilder(
      valueListenable: backgroundImage,
      builder: (_, File backgroundImageListener, __) => ValueListenableBuilder(
        valueListenable: backgroundImageToggle,
        builder: (_, int backgroundImageToggleListener, __) => Column(
          children: [
            SizedBox(
              height: 200,
              width: SizeConfig.screenWidth,
              child: backgroundImageListener.path != ''
              ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(backgroundImageListener, fit: BoxFit.cover,),)
              : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/blm-memorial-cover-1.jpeg'),),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            const Text('Choose Background', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
            
            const SizedBox(height: 20,),

            SizedBox(
              height: 100,
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index){
                  return const SizedBox(width: 25,);
                },
                itemCount: 3,
                itemBuilder: (context, index){
                  return ((){
                    if(index == 2){
                      return GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),),),
                          child: const Icon(Icons.add_rounded, color: Color(0xff000000), size: 60,),
                          height: 100,
                          width: 100,
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
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(color: const Color(0xff04ECFF), borderRadius: BorderRadius.circular(10),),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: AssetImage(backgroundImages[index]),),),
                            height: 100,
                            width: 100,
                          ),
                        )
                        : Container(
                          padding: const EdgeInsets.all(5),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
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
          ],
        ),
      ),
    );
  }

  shareStory1(){
    return TextFormField(
      controller: controllerStory,
      style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
      keyboardType: TextInputType.text,
      cursorColor: const Color(0xff000000),
      readOnly: false,
      maxLines: 10,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
        fillColor: Color(0xffffffff),
        alignLabelWithHint: true,
        labelText: '',
        filled: true,
      ),
    );
  }

  shareStory2(){
    return ValueListenableBuilder(
      valueListenable: videoFile,
      builder: (_, File videoFileListener, __) => ValueListenableBuilder(
        valueListenable: videoThumbnail,
        builder: (_, File videoThumbnailListener, __) => SizedBox(
          width: SizeConfig.screenWidth,
          child: videoFileListener.path != ''
          ? Stack(
            fit: StackFit.expand,
            children: [
              BetterPlayer.file(videoFileListener.path,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                  aspectRatio: 16 / 9,
                  fit: BoxFit.contain,
                  placeholder: videoThumbnailListener.path == ''
                  ? Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9)
                  : Image.file(videoThumbnailListener, fit: BoxFit.contain, scale: 16 / 9),
                  controlsConfiguration: const BetterPlayerControlsConfiguration(
                    enableFullscreen: false,
                  ),
                ),
              ),

              Positioned(
                right: 0,
                child: IconButton(
                  iconSize: 25,
                  icon: const CircleAvatar(backgroundColor: Color(0xff000000), child: Icon(Icons.close, color: Color(0xffffffff),),),
                  onPressed: (){
                    videoFile.value = File('');
                  },
                ),
              ),
            ],
          )
          : GestureDetector(
            onTap: () async{
              await getVideo();
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),), borderRadius: const BorderRadius.all(Radius.circular(10)),),
              child: const Icon(Icons.file_upload, color: Color(0xff888888), size: 100,),
              width: SizeConfig.screenWidth,
              height: 260,
            ),
          ),
        ),
      ),
    );
  }

  shareStory3(){
    return ValueListenableBuilder(
      valueListenable: slideImages,
      builder: (_, List<File> slideImagesListener, __) => ValueListenableBuilder(
        valueListenable: slideCount,
        builder: (_, int slideCountListener, __) => Column(
          children: [
            SizedBox(
              width: SizeConfig.screenWidth,
              height: 260,
              child: SizedBox(
                height: 100,
                child: GridView.count(
                  physics: const ClampingScrollPhysics(),
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 4,
                  children: List.generate(slideCountListener + 1, (index){
                    return ((){
                      if(index == slideCountListener){
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffcccccc), border: Border.all(color: const Color(0xff000000),),),
                            child: const Icon(Icons.add_rounded, color: Color(0xff000000), size: 60,),
                            width: 80,
                          ),
                          onTap: () async{
                            await getSlideImage();
                          },
                        );
                      }else{
                        return GestureDetector(
                          child: SizedBox(
                            width: 80,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(slideImagesListener[index], fit: BoxFit.cover,),
                                ),

                                Stack(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 25, 
                                        backgroundColor: const Color(0xffffffff).withOpacity(.5), 
                                        child: Text('${index + 1}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onDoubleTap: (){
                            slideImages.value.removeAt(index);
                            slideCount.value--;
                          },
                          onTap: (){
                            showGeneralDialog(
                              context: context,
                              barrierLabel: 'Dialog',
                              barrierDismissible: true,
                              transitionDuration: const Duration(milliseconds: 0),
                              pageBuilder: (_, __, ___){
                                return Scaffold(
                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                  body: SizedBox.expand(
                                    child: SafeArea(
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: GestureDetector(
                                              child: CircleAvatar(
                                                child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                radius: 20,
                                              ),
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 20,),
                                          
                                          Expanded(child: Image.file(slideImagesListener[index], fit: BoxFit.contain,),),

                                          const SizedBox(height: 80,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    }());
                  }),
                ),
              ),
            ),

            const SizedBox(height: 5,),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Double tap to remove images.', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
            ),
          ],
        ),
      ),
    );
  }
}