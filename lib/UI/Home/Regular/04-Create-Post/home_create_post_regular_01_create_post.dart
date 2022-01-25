import 'package:facesbyplaces/API/Regular/05-Create-Post/api_create_post_regular_01_create_post.dart';
import 'package:facesbyplaces/API/Regular/05-Create-Post/api_create_post_regular_02_list_of_managed_pages.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_create_post_regular_02_01_create_post_location.dart';
import 'home_create_post_regular_02_02_create_post_user.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: library_prefixes
import 'package:location/location.dart' as Location;
import 'package:video_compress/video_compress.dart';
import 'package:better_player/better_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';
import 'dart:io';

class RegularTaggedUsers{
  final String name;
  final int userId;
  final int accountType;
  const RegularTaggedUsers({required this.name, required this.userId, required this.accountType});
}

class HomeRegularCreatePost extends StatefulWidget{
  final String name;
  final int memorialId;
  const HomeRegularCreatePost({Key? key, required this.name, required this.memorialId}) : super(key: key);

  @override
  HomeRegularCreatePostState createState() => HomeRegularCreatePostState();
}

class HomeRegularCreatePostState extends State<HomeRegularCreatePost>{
  ValueNotifier<List<File>> slideImages = ValueNotifier<List<File>>([]);
  // ValueNotifier<List<XFile>> slideImages = ValueNotifier<List<XFile>>([]);
  ValueNotifier<String> newLocation = ValueNotifier<String>('');
  ValueNotifier<int> currentIdSelected = ValueNotifier<int>(0);
  ValueNotifier<int> removeAttachment = ValueNotifier<int>(0);
  TextEditingController controller = TextEditingController();
  ValueNotifier<int> slideCount = ValueNotifier<int>(0);
  ValueNotifier<int> userCount = ValueNotifier<int>(0);
  List<RegularTaggedUsers> users = [];
  String currentSelection = '';
  final picker = ImagePicker();
  int maxLines = 5;
  double latitude = 0.0;
  double longitude = 0.0;
  Future<APIRegularShowListOfManagedPages>? showListOfManagedPages;

  @override
  void initState(){
    super.initState();
    showListOfManagedPages = getProfileInformation();
    currentSelection = widget.name;
    currentIdSelected.value = widget.memorialId;
  }

  Future<APIRegularShowListOfManagedPages> getProfileInformation() async{
    return await apiRegularShowListOfManagedPages();
  }

  Future getVideo() async{
    try{
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          File(pickedFile.path).path,
          quality: VideoQuality.LowQuality, 
          deleteOrigin: false, // It's false by default
        );

        slideImages.value.add(mediaInfo!.file!);
        slideCount.value++;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  Future getSlideFiles() async{
    try{
      final pickedFile = await picker.pickMultiImage().then((picture){
        return picture;
      });

      if(pickedFile != null){
        // List<File> newFiles = await compressMultipleImages(pickedFile);
        // slideImages.value.addAll(newFiles);
        // slideCount.value += pickedFile.length;

        // slideImages.value.addAll(pickedFile);
        for(int i = 0; i < pickedFile.length; i++){
          slideImages.value.add(File(pickedFile[i].path));
        }
        slideCount.value += pickedFile.length;
      }
    }catch (error){
      throw Exception('Error: $error');
    }
  }

  // Future<List<File>> compressMultipleImages(List<XFile> files) async {
  Future<List<File>> compressMultipleImages(List<File> files) async {
    List<File> newFiles = [];

    for(int i = 0; i < files.length; i++){
      File compressedFile = await FlutterNativeImage.compressImage(File(files[i].path).path, percentage: 5);
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
          valueListenable: removeAttachment,
          builder: (_, int removeAttachmentListener, __) => ValueListenableBuilder(
            valueListenable: slideImages,
            builder: (_, List<File> slideImagesListener, __) => ValueListenableBuilder(
              valueListenable: slideCount,
              builder: (_, int slideCountListener, __) => ValueListenableBuilder(
                valueListenable: userCount,
                builder: (_, int userCountListener, __) => ValueListenableBuilder(
                  valueListenable: newLocation,
                  builder: (_, String newLocationListener, __) => ValueListenableBuilder(
                    valueListenable: currentIdSelected,
                    builder: (_, int currentIdSelectedListener, __) => Scaffold(
                      appBar: AppBar(
                        backgroundColor: const Color(0xff04ECFF),
                        centerTitle: false,
                        title: const Text('Create Post', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        actions: [
                          GestureDetector(
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Center(child: Text('Post', style: TextStyle(fontSize: 28, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),),
                            ),
                            onTap: () async{
                              List<File> newFiles = [];
                              if(slideImages.value.isNotEmpty){
                                List<File> newCompressedFiles = await compressMultipleImages(slideImages.value);
                                // slideImages.value.addAll(newFiles);

                                // newFiles.addAll(slideImages.value);
                                newFiles.addAll(newCompressedFiles);
                              }

                              

                              if(controller.text == '' && newFiles.isEmpty){
                                await showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: 'Error',
                                    description: 'Please input a post before proceeding.',
                                    okButtonColor: const Color(0xfff44336), // RED
                                    includeOkButton: true,
                                  ),
                                );
                              }else{
                                List<RegularTaggedPeople> userIds = [];
                                APIRegularCreatePost? post;

                                if(userCount.value != 0){
                                  for(int i = 0; i < userCount.value; i++){
                                    userIds.add(RegularTaggedPeople(userId: users[i].userId, accountType: users[i].accountType,),);
                                  }
                                }

                                if(newLocation.value == ''){
                                  Location.Location location = Location.Location();

                                  bool serviceEnabled = await location.serviceEnabled();
                                  if(!serviceEnabled){
                                    serviceEnabled = await location.requestService();
                                    if(!serviceEnabled){
                                      return;
                                    }
                                  }

                                  Location.PermissionStatus permissionGranted = await location.hasPermission();
                                  if(permissionGranted == Location.PermissionStatus.denied){
                                    permissionGranted = await location.requestPermission();
                                    if(permissionGranted != Location.PermissionStatus.granted){
                                      await showDialog(
                                        context: context,
                                        builder: (context) => CustomDialog(
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          title: 'Error',
                                          description: 'Permission to access location has been denied from this app. In order to turn it on, go to settings and allow location access permission for this app.',
                                          okButtonColor: const Color(0xfff44336), // RED
                                          includeOkButton: true,
                                        ),
                                      );
                                      return;
                                    }
                                  }

                                  Location.LocationData locationData = await location.getLocation();

                                  post = APIRegularCreatePost(
                                    almPageType: 'Memorial',
                                    almPostBody: controller.text,
                                    almPageId: currentIdSelected.value,
                                    almLocation: '',
                                    almImagesOrVideos: newFiles,
                                    almLatitude: locationData.latitude!,
                                    almLongitude: locationData.longitude!,
                                    almTagPeople: userIds,
                                  );
                                }else{
                                  post = APIRegularCreatePost(
                                    almPageType: 'Memorial',
                                    almPostBody: controller.text,
                                    almPageId: currentIdSelected.value,
                                    almLocation: newLocation.value,
                                    almImagesOrVideos: newFiles,
                                    almLatitude: latitude,
                                    almLongitude: longitude,
                                    almTagPeople: userIds,
                                  );
                                }

                                context.loaderOverlay.show();
                                bool result = await apiRegularHomeCreatePost(post: post);
                                context.loaderOverlay.hide();

                                if(result){
                                  Navigator.popAndPushNamed(context, '/home/regular');
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
                      body: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: SafeArea(
                          child: Column(
                            children: [
                              Container(
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff888888),),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                                    border: UnderlineInputBorder(borderSide: BorderSide.none,),
                                  ),
                                  child: FutureBuilder<APIRegularShowListOfManagedPages>(
                                    future: showListOfManagedPages,
                                    builder: (context, listOfManagedPages){
                                      if(listOfManagedPages.connectionState == ConnectionState.done){
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            isExpanded: true,
                                            value: currentIdSelectedListener,
                                            items: listOfManagedPages.data!.almPagesList.map((page){
                                              return DropdownMenuItem<int>(
                                                value: page.showListOfManagedPagesId,
                                                child: ListTile(
                                                  leading: page.showListOfManagedPagesProfileImage != ''
                                                  ? CircleAvatar(
                                                    backgroundColor: const Color(0xff888888),
                                                    foregroundImage: NetworkImage(page.showListOfManagedPagesProfileImage),
                                                    backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                  )
                                                  : const CircleAvatar(
                                                    backgroundColor: Color(0xff888888),
                                                    foregroundImage: AssetImage('assets/icons/app-icon.png'),
                                                  ),
                                                  title: Text(page.showListOfManagedPagesName, overflow: TextOverflow.clip, maxLines: 1, style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (int? newValue){
                                              currentIdSelected.value = newValue!;
                                            },
                                          ),
                                        );
                                      }else if(listOfManagedPages.connectionState == ConnectionState.none || listOfManagedPages.connectionState == ConnectionState.waiting){
                                        return const Center(child: CustomLoaderThreeDots(),);
                                      }
                                      else if(listOfManagedPages.hasError){
                                        return const SizedBox(height: 0);
                                      }else{
                                        return const SizedBox(height: 0);
                                      }
                                    }
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: const Color(0xff888888).withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),

                              FocusScope(
                                child: Focus(
                                  child: Container(
                                    height: 500,
                                    padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: controller,
                                      style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xfF000000),),
                                      cursorColor: const Color(0xff000000),
                                      keyboardType: TextInputType.text,
                                      maxLines: maxLines,
                                      decoration: const InputDecoration(
                                        fillColor: Color(0xffffffff),
                                        alignLabelWithHint: true,
                                        labelText: 'Speak out...',
                                        labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent,),),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent,),),
                                      ),
                                    ),
                                  ),
                                  onFocusChange: (focus){
                                    if(focus){
                                      maxLines = 10;
                                    }else{
                                      maxLines = 5;
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(height: 10,),

                              newLocationListener != ''
                              ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.place, color: Color(0xff888888)),

                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Chip(
                                          labelPadding: const EdgeInsets.only(left: 8.0),
                                          label: Text(newLocationListener),
                                          deleteIcon: const Icon(Icons.close, size: 18,),
                                          onDeleted: (){
                                            newLocation.value = '';
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : const SizedBox(height: 0,),

                              const SizedBox(height: 10,),

                              userCountListener != 0
                              ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.people, color: Color(0xff888888)),

                                    Expanded(
                                      child: Wrap(
                                        spacing: 5.0,
                                        children: List.generate(
                                          users.length,
                                          (index) => Chip(
                                            labelPadding: const EdgeInsets.only(left: 8.0),
                                            label: Text(users[index].name),
                                            deleteIcon: const Icon(Icons.close, size: 18,),
                                            onDeleted: (){
                                              userCount.value--;
                                              users.removeAt(index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : const SizedBox(height: 0,),

                              const SizedBox(height: 10,),

                              SizedBox(
                                child: ((){
                                  if(slideCountListener != 0){
                                    return Container(
                                      height: 200,
                                      width: SizeConfig.screenWidth,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: SizedBox(
                                        height: 100,
                                        child: GridView.count(
                                          physics: const ClampingScrollPhysics(),
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 4,
                                          children: List.generate(slideCountListener, (index){
                                            return GestureDetector(
                                              child: lookupMimeType(slideImagesListener[index].path)?.contains('video') == true
                                              ? Stack(
                                                children: [
                                                  BetterPlayer.file(slideImagesListener[index].path,
                                                    betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                      controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                                      aspectRatio: 1,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),

                                                  Center(
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                      child: Text('${index + 1}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                    ),
                                                  ),

                                                  removeAttachmentListener == index
                                                  ? Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      child: const CircleAvatar(backgroundColor: Color(0xff000000), child: Icon(Icons.close, color: Color(0xffffffff),),),
                                                      onTap: (){
                                                        slideImages.value.removeAt(index);
                                                        slideCount.value--;
                                                      },
                                                    ),
                                                  )
                                                  : const SizedBox(height: 0),
                                                ],
                                              )
                                              : SizedBox(
                                                width: 80,
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.file(File(slideImagesListener[index].path), fit: BoxFit.cover,),
                                                    ),

                                                    Center(
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                        child: Text('${index + 1}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                      ),
                                                    ),
                                                    
                                                    removeAttachmentListener == index
                                                    ? Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        child: const CircleAvatar(backgroundColor: Color(0xff000000), child: Icon(Icons.close, color: Color(0xffffffff),),),
                                                        onTap: (){
                                                          slideImages.value.removeAt(index);
                                                          slideCount.value--;
                                                        },
                                                      ),
                                                    )
                                                    : const SizedBox(height: 0),
                                                  ],
                                                ),
                                              ),
                                              onDoubleTap: (){
                                                removeAttachment.value = index;
                                              },
                                              onTap: (){
                                                showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel: 'Dialog',
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
                                                                  child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                  onTap: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                ),
                                                              ),

                                                              const SizedBox(height: 20,),

                                                              Expanded(
                                                                child: ((){
                                                                  if(lookupMimeType(slideImagesListener[index].path)?.contains('video') == true){
                                                                    return BetterPlayer.file(slideImagesListener[index].path,
                                                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                        autoDispose: false,
                                                                        aspectRatio: 16 / 9,
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                    );
                                                                  }else{
                                                                    return Image.file(File(slideImagesListener[index].path), fit: BoxFit.contain,);
                                                                  }
                                                                }()),
                                                              ),

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
                                          }),
                                        ),
                                      ),
                                    );
                                  }else{
                                    return const SizedBox(height: 0,);
                                  }
                                }()),
                              ),

                              const Divider(color: Color(0xff2F353D), thickness: 0.2,),

                              SizedBox(
                                height: 160,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          color: Colors.transparent,
                                          child: Row(
                                            children: const [
                                              Expanded(child: Text('Add a location', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                                              Icon(Icons.place, color: Color(0xff4EC9D4),),
                                            ],
                                          ),
                                        ),
                                        onTap: () async{
                                          List<dynamic> result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeRegularCreatePostSearchLocation()));

                                          if(result[0] != ''){
                                            newLocation.value = result[0];
                                            latitude = result[1];
                                            longitude = result[2];
                                          }
                                        },
                                      ),
                                    ),

                                    const Divider(color: Color(0xff2F353D), thickness: 0.2,),

                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          color: Colors.transparent,
                                          child: Row(
                                            children: const [
                                              Expanded(child: Text('Tag a person you are with', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color:Color(0xff000000),),),),

                                              Icon(Icons.person, color: Color(0xff4EC9D4),),
                                            ],
                                          ),
                                        ),
                                        onTap: () async{
                                          RegularTaggedUsers? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePostSearchUser(taggedUsers: users,)));

                                          if(result != null){
                                            userCount.value++;
                                            users.add(result);
                                          }
                                        },
                                      ),
                                    ),

                                    const Divider(color: Color(0xff2F353D), thickness: 0.2,),

                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          color: Colors.transparent,
                                          child: Row(
                                            children: const [
                                              Expanded(child: Text('Upload a Video / Image', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                                              Icon(Icons.image, color: Color(0xff4EC9D4),),
                                            ],
                                          ),
                                        ),
                                        onTap: () async{
                                          var choice = await showDialog(context: (context), builder: (build) => const MiscUploadFromDialog(choice_1: 'Image', choice_2: 'Video',),);

                                          if(choice == null){
                                            choice = 0;
                                          }else{
                                            if(choice == 1){
                                              await getSlideFiles();
                                            }else{
                                              await getVideo();
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}