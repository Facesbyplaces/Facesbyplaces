import 'package:facesbyplaces/API/Regular/05-Create-Post/api-create-post-regular-01-create-post.dart';
import 'package:facesbyplaces/API/Regular/05-Create-Post/api-create-post-regular-02-list-of-managed-pages.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-post-regular-02-01-create-post-location.dart';
import 'home-create-post-regular-02-02-create-post-user.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart' as Location;
import 'package:better_player/better_player.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:io';

class RegularTaggedUsers {
  final String name;
  final int userId;
  final int accountType;
  const RegularTaggedUsers({required this.name, required this.userId, required this.accountType});
}

class RegularManagedPages {
  final String name;
  final int pageId;
  final String image;
  const RegularManagedPages({required this.name, required this.pageId, required this.image});
}

class HomeRegularCreatePost extends StatefulWidget {
  final String name;
  final int memorialId;
  const HomeRegularCreatePost({required this.name, required this.memorialId});

  @override
  HomeRegularCreatePostState createState() => HomeRegularCreatePostState();
}

class HomeRegularCreatePostState extends State<HomeRegularCreatePost> {
  ValueNotifier<List<File>> slideImages = ValueNotifier<List<File>>([]);
  ValueNotifier<String> newLocation = ValueNotifier<String>('');
  ValueNotifier<int> removeAttachment = ValueNotifier<int>(0);
  TextEditingController controller = TextEditingController();
  ValueNotifier<int> slideCount = ValueNotifier<int>(0);
  ValueNotifier<int> userCount = ValueNotifier<int>(0);
  List<RegularManagedPages> managedPages = [];
  List<RegularTaggedUsers> users = [];
  String currentSelection = '';
  final picker = ImagePicker();
  int currentIdSelected = 1;
  int maxLines = 5;

  void initState(){
    super.initState();
    currentSelection = widget.name;
    currentIdSelected = widget.memorialId;
    getManagedPages();
  }

  void getManagedPages() async{
    context.loaderOverlay.show();
    var newValue = await apiRegularShowListOfManagedPages();
    context.loaderOverlay.hide();

    for(int i = 0; i < newValue.almPagesList.length; i++){
      managedPages.add(
        RegularManagedPages(
          name: newValue.almPagesList[i].showListOfManagedPagesName,
          pageId: newValue.almPagesList[i].showListOfManagedPagesId,
          image: newValue.almPagesList[i].showListOfManagedPagesProfileImage,
        ),
      );
    }
    setState(() {});
  }

  Future getVideo() async{
    try{
      final pickedFile = await picker.getVideo(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        slideImages.value.add(File(pickedFile.path));
        slideCount.value++;
      }
    }catch (error){
      print('Error: ${error.toString()}');
    }
  }

  Future getSlideFiles() async {
    try{
      final pickedFile = await picker.getImage(source: ImageSource.gallery).then((picture){
        return picture;
      });

      if(pickedFile != null){
        slideImages.value.add(File(pickedFile.path));
        slideCount.value++;
      }
    }catch (error){
      print('Error: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    print('Regular create post screen rebuild!');
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
                  builder: (_, String newLocationListener, __) => Scaffold(
                    appBar: AppBar(
                      title: Row(
                        children: [
                          Text('Create Post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
                          Spacer(),
                        ],
                      ),
                      centerTitle: true,
                      backgroundColor: const Color(0xff04ECFF),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52,),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () async{
                            Location.Location location = new Location.Location();

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
                                return;
                              }
                            }

                            context.loaderOverlay.show();

                            Location.LocationData locationData = await location.getLocation();
                            List<RegularTaggedPeople> userIds = [];

                            if(users.length != 0){
                              for(int i = 0; i < users.length; i++){
                                userIds.add(RegularTaggedPeople(userId: users[i].userId, accountType: users[i].accountType,),);
                              }
                            }

                            List<File> newFiles = [];
                            newFiles.addAll(slideImages.value);

                            APIRegularCreatePost post = APIRegularCreatePost(
                              almPageType: 'Memorial',
                              almPostBody: controller.text,
                              almPageId: currentIdSelected,
                              almLocation: newLocation.value,
                              almImagesOrVideos: newFiles,
                              almLatitude: locationData.latitude!,
                              almLongitude: locationData.longitude!,
                              almTagPeople: userIds,
                            );

                            bool result = await apiRegularHomeCreatePost(post: post);
                            context.loaderOverlay.hide();

                            if(result){
                              Navigator.popAndPushNamed(context, '/home/regular');
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                  onlyOkButton: true,
                                  buttonOkColor: const Color(0xffff0000),
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Center(
                              child: Text('Post',
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                  fontFamily: 'NexaRegular',
                                  color: const Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
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
                                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888),),
                                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none,),
                                  border: const UnderlineInputBorder(borderSide: BorderSide.none,),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: currentIdSelected,
                                    onChanged: (int? newValue){
                                      currentIdSelected = newValue!;
                                    },
                                    items: managedPages.map((RegularManagedPages value){
                                      return DropdownMenuItem<int>(
                                        value: value.pageId,
                                        child: Row(
                                          children: [
                                            value.image != ''
                                            ? CircleAvatar(
                                              backgroundColor: const Color(0xff888888),
                                              foregroundImage: NetworkImage(value.image),
                                              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                            )
                                            : const CircleAvatar(
                                              backgroundColor: const Color(0xff888888),
                                              foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                                            ),

                                            Text(value.name, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
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
                                onFocusChange: (focus){
                                  if(focus){
                                    maxLines = 10;
                                  }else{
                                    maxLines = 5;
                                  }
                                },
                                child: Container(
                                  height: SizeConfig.blockSizeVertical! * 50,
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: controller,
                                    cursorColor: const Color(0xff000000),
                                    maxLines: maxLines,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xfF000000),),
                                    decoration: InputDecoration(
                                      fillColor: const Color(0xffffffff),
                                      alignLabelWithHint: true,
                                      labelText: 'Speak out...',
                                      labelStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
                                      border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xff000000),), borderRadius: const BorderRadius.all(Radius.circular(10)),),
                                      focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent,),),
                                      enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent,),),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10,),

                            newLocationListener != ''
                            ? Container(
                              child: Chip(
                                labelPadding: const EdgeInsets.only(left: 8.0),
                                label: Text(newLocationListener),
                                deleteIcon: const Icon(Icons.close, size: 18,),
                                onDeleted: (){
                                  newLocation.value = '';
                                },
                              ),
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                              alignment: Alignment.centerLeft,
                            )
                            : Container(height: 0,),

                            const SizedBox(height: 10,),

                            Container(
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
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                              alignment: Alignment.centerLeft,
                            ),

                            const SizedBox(height: 10,),

                            Container(
                              child: ((){
                                if(slideCountListener != 0){
                                  return Container(
                                    height: 200,
                                    width: SizeConfig.screenWidth,
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: Container(
                                      height: 100,
                                      child: GridView.count(
                                        physics: const ClampingScrollPhysics(),
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 4,
                                        children: List.generate(slideCountListener, (index){
                                          return GestureDetector(
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
                                                                child: CircleAvatar(
                                                                  radius: 20,
                                                                  backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                  child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                ),
                                                                onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                            ),

                                                            const SizedBox(height: 20,),

                                                            Expanded(
                                                              child: ((){
                                                                if(lookupMimeType(slideImagesListener[index].path)?.contains('video') == true){
                                                                  return BetterPlayer.file('${slideImagesListener[index].path}',
                                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                      deviceOrientationsAfterFullScreen: [
                                                                        DeviceOrientation.portraitUp
                                                                      ],
                                                                      autoDispose: false,
                                                                      aspectRatio: 16 / 9,
                                                                      fit: BoxFit.contain,
                                                                    ),
                                                                  );
                                                                }else{
                                                                  return Image.file(slideImagesListener[index], fit: BoxFit.contain,);
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
                                            child: lookupMimeType(slideImagesListener[index].path)?.contains('video') == true
                                            ? Stack(
                                              children: [
                                                BetterPlayer.file('${slideImagesListener[index].path}',
                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                    placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                    controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                    aspectRatio: 1,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),

                                                Center(
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                    child: Text('${index + 1}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),
                                                  ),
                                                ),

                                                removeAttachmentListener == index
                                                ? Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    child: const CircleAvatar(
                                                      backgroundColor: const Color(0xff000000),
                                                      child: const Icon(Icons.close, color: const Color(0xffffffff),),
                                                    ),
                                                    onTap: (){
                                                      slideImages.value.removeAt(index);
                                                      slideCount.value--;
                                                    },
                                                  ),
                                                )
                                                : Container(height: 0),
                                              ],
                                            )
                                            : Container(
                                              width: 80,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.file(slideImagesListener[index], fit: BoxFit.cover,),
                                                  ),

                                                  Center(
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                      child: Text('${index + 1}',
                                                        style: const TextStyle(
                                                          fontSize: 40,
                                                          fontWeight: FontWeight.bold,
                                                          color: const Color(0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                  removeAttachmentListener == index
                                                  ? Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        slideImages.value.removeAt(index);
                                                        slideCount.value--;
                                                      },
                                                      child: const CircleAvatar(
                                                        backgroundColor: const Color(0xff000000),
                                                        child: const Icon(Icons.close, color: const Color(0xffffffff),),
                                                      ),
                                                    ),
                                                  )
                                                  : Container(height: 0),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  );
                                }else{
                                  return Container(height: 0,);
                                }
                              }()),
                            ),

                            Divider(color: const Color(0xff2F353D), thickness: 0.2,),

                            Container(
                              height: 160,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        String result = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePostSearchLocation()));
                                        newLocation.value = result;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Expanded(child: Text('Add a location', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),),

                                            const Icon(Icons.place, color: const Color(0xff4EC9D4),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Divider(color: const Color(0xff2F353D), thickness: 0.2,),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async{
                                        RegularTaggedUsers? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePostSearchUser()));

                                        if(result != null){
                                          userCount.value++;
                                          users.add(result);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Expanded(child: Text('Tag a person you are with', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color:const Color(0xff000000),),),),

                                            const Icon(Icons.person, color: const Color(0xff4EC9D4),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Divider(color: const Color(0xff2F353D), thickness: 0.2,),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async{
                                        var choice = await showDialog(context: (context), builder: (build) => const MiscRegularUploadFromDialog(choice_1: 'Image', choice_2: 'Video',),);

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
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Expanded(child: Text('Upload a Video / Image', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),),

                                            const Icon(Icons.image, color: const Color(0xff4EC9D4),),
                                          ],
                                        ),
                                      ),
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
    );
  }
}