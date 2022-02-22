import 'package:facesbyplaces/API/Regular/04-Create-Memorial/api_create_memorial_regular_01_create_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
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
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:misc/misc.dart';
import 'dart:typed_data';
import 'dart:io';

class HomeRegularCreateMemorial2 extends StatefulWidget{
  final String relationship;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;
  final String latitude;
  final String longitude;
  const HomeRegularCreateMemorial2({Key? key, required this.relationship, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country, required this.latitude, required this.longitude}) : super(key: key);

  @override
  HomeRegularCreateMemorial2State createState() => HomeRegularCreateMemorial2State();
}

class HomeRegularCreateMemorial2State extends State<HomeRegularCreateMemorial2> with TickerProviderStateMixin{
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  ValueNotifier<List<XFile>> slideImages = ValueNotifier<List<XFile>>([]);
  TextEditingController controllerStory = TextEditingController();
  ValueNotifier<File> videoFile = ValueNotifier<File>(File(''));
  ValueNotifier<int> slideCount = ValueNotifier<int>(0);
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<File> videoThumbnail = ValueNotifier<File>(File(''));
  TabController? controller1;
  TabController? controller2;
  ValueNotifier<File> backgroundImage = ValueNotifier<File>(File(''));
  ValueNotifier<File> profileImage = ValueNotifier<File>(File(''));
  ValueNotifier<int> backgroundImageToggle = ValueNotifier<int>(0);
  ValueNotifier<bool> isCroppedProfile = ValueNotifier<bool>(false);
  ValueNotifier<bool> isCroppedBackground = ValueNotifier<bool>(false);
  List<String> backgroundImages = ['assets/icons/alm-memorial-cover-1.jpeg', 'assets/icons/alm-memorial-cover-2.jpeg'];

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
        final file = await File('${tempDir.path}/alm-qr-code.png').create();
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
        slideImages.value.addAll(pickedFile);
        slideCount.value += pickedFile.length;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future getCroppedImage({bool isProfile = true}) async{
    try{
      final imageCropper = ImageCropper();
      File? croppedFile = await imageCropper.cropImage(
        sourcePath: isProfile ? profileImage.value.path : backgroundImage.value.path,
        aspectRatioPresets: isProfile ? [CropAspectRatioPreset.square,] : [CropAspectRatioPreset.ratio16x9,],
        cropStyle: isProfile ? CropStyle.circle : CropStyle.rectangle,
        androidUiSettings: const AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: Colors.deepOrange, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false), 
        iosUiSettings: const IOSUiSettings( minimumAspectRatio: 1.0,),
        compressQuality: 5,
      );

      if(croppedFile != null){
        if(isProfile){
          isCroppedProfile.value = true;
          profileImage.value = croppedFile;
        }else{
          isCroppedBackground.value = true;
          backgroundImage.value = croppedFile;
        }
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
        profileImage.value = File(pickedFile.path);
        await getCroppedImage();
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
        await getCroppedImage(isProfile: false);
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
          valueListenable: isCroppedProfile,
          builder: (_, bool isCroppedProfileListener, __) => Scaffold(
            appBar: AppBar(
              title: const Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff))),
              backgroundColor: const Color(0xff04ECFF),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(height: SizeConfig.screenHeight, child: const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
                ),

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
                                    File newFile = await compressImage(backgroundImage.value);
                                    backgroundImage.value = newFile;
                                  }else if(backgroundImageToggle.value == 1){
                                    File newFile = await compressImage(backgroundImage.value);
                                    backgroundImage.value = newFile;
                                  }
                                }else{
                                  File newFile = await compressImage(backgroundImage.value);
                                  backgroundImage.value = newFile;
                                }

                                if(profileImage.value.path == ''){
                                  final ByteData bytes = await rootBundle.load('assets/icons/cover-icon.png');
                                  final Uint8List list = bytes.buffer.asUint8List();

                                  final tempDir = await getTemporaryDirectory();
                                  final file = await File('${tempDir.path}/regular-profile-image.png').create();
                                  file.writeAsBytesSync(list);

                                  profileImage.value = file;
                                }else{
                                  if(!isCroppedProfile.value){
                                    File newFile = await compressImage(profileImage.value);
                                    profileImage.value = newFile;
                                  }
                                }

                                List<dynamic> newFiles = [];

                                if(videoFile.value.path != ''){
                                  newFiles.add(videoFile.value);
                                }

                                if(slideImages.value != []){
                                  List<File> newCompressedFiles = await compressMultipleImages(slideImages.value);
                                  newFiles.addAll(newCompressedFiles);
                                }

                                APIRegularCreateMemorial memorial = APIRegularCreateMemorial(
                                  almRelationship: widget.relationship,
                                  almBirthPlace: widget.birthplace,
                                  almDob: widget.dob,
                                  almRip: widget.rip,
                                  almCemetery: widget.cemetery,
                                  almCountry: widget.country,
                                  almMemorialName: _key1.currentState!.controller.text,
                                  almDescription: controllerStory.text,
                                  almBackgroundImage: backgroundImage.value,
                                  almProfileImage: profileImage.value,
                                  almImagesOrVideos: newFiles,
                                  almLatitude: widget.latitude,
                                  almLongitude: widget.longitude,
                                );

                                context.loaderOverlay.show(widget: const CustomLoaderTextLoader());
                                int result = await apiRegularCreateMemorial(memorial: memorial);
                                context.loaderOverlay.hide();

                                if(result != 0){
                                  Route newRoute = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: result, managed: true, newlyCreated: true, relationship: widget.relationship,),);
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
                  image: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/alm-memorial-cover-1.jpeg'),),
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
                          final file = await File('${tempDir.path}/regular-background-image-$index.png').create();
                          file.writeAsBytesSync(list);

                          

                          backgroundImageToggle.value = index;
                          backgroundImage.value = file;

                          await getCroppedImage(isProfile: false);
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
      cursorColor: const Color(0xff000000),
      keyboardType: TextInputType.text,
      readOnly: false,
      maxLines: 10,
      decoration: const InputDecoration(
        filled: true,
        labelText: '',
        alignLabelWithHint: true,
        fillColor: Color(0xffffffff),
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff888888)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10),),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
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
      builder: (_, List<XFile> slideImagesListener, __) => ValueListenableBuilder(
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
                            child: const Icon(Icons.add_rounded, color: Color(0xff000000), size: 60),
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
                                  child: Image.file(File(slideImagesListener[index].path), fit: BoxFit.cover,),
                                ),

                                Stack(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        child: Text('${index + 1}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                        backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                        radius: 25,
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
                              transitionDuration: const Duration(milliseconds: 0),
                              barrierDismissible: true,
                              barrierLabel: 'Dialog',
                              pageBuilder: (_, __, ___){
                                return Scaffold(
                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                  body: SizedBox.expand(
                                    child: SafeArea(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),

                                          const SizedBox(height: 20,),

                                          Expanded(child: Image.file(File(slideImagesListener[index].path), fit: BoxFit.contain,),),

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

            const SizedBox(height: 10,),

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