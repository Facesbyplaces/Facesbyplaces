import 'package:facesbyplaces/API/BLM/05-Create-Post/api-create-post-blm-01-create-post.dart';
import 'package:facesbyplaces/API/BLM/05-Create-Post/api-create-post-blm-02-list-of-managed-pages.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/services.dart';
import 'home-create-post-blm-02-01-create-post-location.dart';
import 'home-create-post-blm-02-02-create-post-user.dart';
import 'package:location/location.dart' as Location;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:io';

class BLMTaggedUsers {
  final String name;
  final int userId;
  final int accountType;

  const BLMTaggedUsers(
      {required this.name, required this.userId, required this.accountType});
}

class BLMManagedPages {
  final String name;
  final int pageId;
  final String image;

  const BLMManagedPages(
      {required this.name, required this.pageId, required this.image});
}

class HomeBLMCreatePost extends StatefulWidget {
  final String name;
  final int memorialId;
  const HomeBLMCreatePost({required this.name, required this.memorialId});

  @override
  HomeBLMCreatePostState createState() => HomeBLMCreatePostState();
}

class HomeBLMCreatePostState extends State<HomeBLMCreatePost>{
  List<BLMManagedPages> managedPages = [];
  String currentSelection = '';
  int currentIdSelected = 0;
  List<BLMTaggedUsers> users = [];
  List<File> slideImages = [];
  TextEditingController controller = TextEditingController();
  int maxLines = 5;

  final picker = ImagePicker();
  String newLocation = '';
  String person = '';
  int removeAttachment = 0;

  void initState() {
    super.initState();
    currentSelection = widget.name;
    currentIdSelected = widget.memorialId;
    getManagedPages();
  }

  void getManagedPages() async {
    context.loaderOverlay.show();
    var newValue =
        await apiBLMShowListOfManagedPages().onError((error, stackTrace) async {
      context.loaderOverlay.hide();
      await showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
                image: Image.asset(
                  'assets/icons/cover-icon.png',
                  fit: BoxFit.cover,
                ),
            title: Text(
              'Error',
              textAlign: TextAlign.center,
              style:  TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 3.87,
                  fontFamily: 'NexaRegular'),
            ),
            entryAnimation: EntryAnimation.DEFAULT,
            description: Text(
              'Something went wrong. Please try again.',
              textAlign: TextAlign.center,
              style:  TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.87,
                  fontFamily: 'NexaRegular'
              ),
            ),
                onlyOkButton: true,
                buttonOkColor: const Color(0xffff0000),
                onOkButtonPressed: () {
                  Navigator.pop(context, true);
                },
              ));
      return Future.error('Error occurred in list of managed pages: $error');
    });
    context.loaderOverlay.hide();

    for (int i = 0; i < newValue.blmPagesList.length; i++) {
      managedPages.add(BLMManagedPages(
        name: newValue.blmPagesList[i].blmManagedPagesName,
        pageId: newValue.blmPagesList[i].blmManagedPagesId,
        image: newValue.blmPagesList[i].blmManagedPagesProfileImage,
      ));
    }
    setState(() {});
  }

  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        slideImages.add(File(pickedFile.path));
      });
    }
  }

  Future getSlideFiles() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        slideImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  'Create Post',
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 3.16,
                    fontFamily: 'NexaRegular',
                    color: const Color(0xffffffff),
                  ),
                ),
                Spacer()
              ],
            ),
            centerTitle: true,
            backgroundColor: const Color(0xff04ECFF),
            leading: IconButton(
              icon:  Icon(
                Icons.arrow_back,
                color: const Color(0xffffffff),
                size: SizeConfig.blockSizeVertical! * 3.52,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  Location.Location location = new Location.Location();

                  bool serviceEnabled = await location.serviceEnabled();
                  if (!serviceEnabled) {
                    serviceEnabled = await location.requestService();
                    if (!serviceEnabled) {
                      return;
                    }
                  }

                  Location.PermissionStatus permissionGranted =
                      await location.hasPermission();
                  if (permissionGranted == Location.PermissionStatus.denied) {
                    permissionGranted = await location.requestPermission();
                    if (permissionGranted !=
                        Location.PermissionStatus.granted) {
                      return;
                    }
                  }

                  context.loaderOverlay.show();

                  Location.LocationData locationData =
                      await location.getLocation();
                  List<BLMTaggedPeople> userIds = [];

                  if (users.length != 0) {
                    for (int i = 0; i < users.length; i++) {
                      userIds.add(
                        BLMTaggedPeople(
                          userId: users[i].userId,
                          accountType: users[i].accountType,
                        ),
                      );
                    }
                  }

                  List<File> newFiles = [];
                  newFiles.addAll(slideImages);

                  APIBLMCreatePost post = APIBLMCreatePost(
                    blmPostPageType: 'Blm',
                    blmPostPostBody: controller.text,
                    blmPostPageId: currentIdSelected,
                    blmPostLocation: newLocation,
                    blmPostImagesOrVideos: newFiles,
                    blmPostLatitude: locationData.latitude!,
                    blmPostLongitude: locationData.longitude!,
                    blmPostTagPeople: userIds,
                  );

                  bool result = await apiBLMHomeCreatePost(post: post);
                  context.loaderOverlay.hide();

                  if (result) {
                    Navigator.popAndPushNamed(context, '/home/blm');
                  } else {
                    await showDialog(
                        context: context,
                        builder: (_) => AssetGiffyDialog(
                              image: Image.asset(
                                'assets/icons/cover-icon.png',
                                fit: BoxFit.cover,
                              ),
                          title: Text(
                            'Error',
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                fontFamily: 'NexaRegular'),
                          ),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text(
                            'Something went wrong. Please try again.',
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                fontFamily: 'NexaRegular'
                            ),
                          ),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Center(
                    child: Text(
                      'Post',
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
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff888888)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: currentIdSelected,
                          isDense: true,
                          onChanged: (int? newValue) {
                            setState(() {
                              currentIdSelected = newValue!;
                            });
                          },
                          items: managedPages.map((BLMManagedPages value) {
                            return DropdownMenuItem<int>(
                              value: value.pageId,
                              child: Row(
                                children: [
                                  value.image != ''
                                      ? CircleAvatar(
                                          backgroundColor:
                                              const Color(0xff888888),
                                          foregroundImage:
                                              NetworkImage(value.image),
                                          backgroundImage: const AssetImage(
                                              'assets/icons/app-icon.png'),
                                        )
                                      : const CircleAvatar(
                                          backgroundColor:
                                              const Color(0xff888888),
                                          foregroundImage: const AssetImage(
                                              'assets/icons/app-icon.png'),
                                        ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(value.name,
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                      fontFamily: 'NexaBold',
                                      color: const Color(0xff000000),
                                    ),),
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
                            offset: const Offset(0, 0)),
                      ],
                    ),
                  ),
                  FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        if (focus) {
                          setState(() {
                            maxLines = 10;
                          });
                        } else {
                          setState(() {
                            maxLines = 5;
                          });
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
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.64,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xfF000000)),
                          decoration: InputDecoration(
                            fillColor: const Color(0xffffffff),
                            alignLabelWithHint: true,
                            labelText: 'Speak out...',
                            labelStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.64,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xffB1B1B1),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: const Color(0xff000000),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  newLocation != ''
                      ? Container(
                          child: Chip(
                            labelPadding: const EdgeInsets.only(left: 8.0),
                            label: Text(newLocation),
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 18,
                            ),
                            onDeleted: () {
                              setState(() {
                                newLocation = '';
                              });
                            },
                          ),
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          alignment: Alignment.centerLeft,
                        )
                      : Container(
                          height: 0,
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Wrap(
                      spacing: 5.0,
                      children: List.generate(
                        users.length,
                        (index) => Chip(
                          labelPadding: const EdgeInsets.only(left: 8.0),
                          label: Text(users[index].name),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 18,
                          ),
                          onDeleted: () {
                            setState(() {
                              users.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: (() {
                      if (slideImages.length != 0) {
                        return Container(
                          height: 200,
                          width: SizeConfig.screenWidth,
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                            height: 100,
                            child: GridView.count(
                              physics: const ClampingScrollPhysics(),
                              crossAxisCount: 4,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              children:
                                  List.generate(slideImages.length, (index) {
                                return GestureDetector(
                                  onDoubleTap: () {
                                    setState(() {
                                      removeAttachment = index;
                                    });
                                  },
                                  onTap: () {
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: 'Dialog',
                                      transitionDuration:
                                          Duration(milliseconds: 0),
                                      pageBuilder: (_, __, ___) {
                                        return Scaffold(
                                          backgroundColor:
                                              Colors.black12.withOpacity(0.7),
                                          body: SizedBox.expand(
                                            child: SafeArea(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor:
                                                            const Color(
                                                                    0xff000000)
                                                                .withOpacity(
                                                                    0.8),
                                                        child: const Icon(
                                                          Icons.close_rounded,
                                                          color: const Color(
                                                              0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Expanded(
                                                    child: (() {
                                                      if (lookupMimeType(
                                                                  slideImages[
                                                                          index]
                                                                      .path)
                                                              ?.contains(
                                                                  'video') ==
                                                          true) {
                                                        return BetterPlayer
                                                            .file(
                                                          '${slideImages[index].path}',
                                                          betterPlayerConfiguration:
                                                              const BetterPlayerConfiguration(
                                                            deviceOrientationsAfterFullScreen: [
                                                              DeviceOrientation
                                                                  .portraitUp
                                                            ],
                                                            autoDispose: false,
                                                            aspectRatio: 16 / 9,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        );
                                                      } else {
                                                        return Image.asset(
                                                          slideImages[index]
                                                              .path,
                                                          fit: BoxFit.contain,
                                                          scale: 1.0,
                                                        );
                                                      }
                                                    }()),
                                                  ),
                                                  const SizedBox(
                                                    height: 80,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: lookupMimeType(slideImages[index].path)
                                              ?.contains('video') ==
                                          true
                                      ? Stack(
                                          children: [
                                            BetterPlayer.file(
                                              '${slideImages[index].path}',
                                              betterPlayerConfiguration:
                                                  const BetterPlayerConfiguration(
                                                controlsConfiguration:
                                                    const BetterPlayerControlsConfiguration(
                                                  showControls: false,
                                                ),
                                                aspectRatio: 1,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Center(
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor:
                                                    const Color(0xffffffff)
                                                        .withOpacity(.5),
                                                child: Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            removeAttachment == index
                                                ? Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          slideImages
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: const CircleAvatar(
                                                        backgroundColor:
                                                            const Color(
                                                                0xff000000),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: const Color(
                                                              0xffffffff),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(height: 0),
                                          ],
                                        )
                                      : Container(
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xffcccccc),
                                            border: Border.all(
                                              color: const Color(0xff000000),
                                            ),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  slideImages[index].path),
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Color(0xffffffff)
                                                          .withOpacity(.5),
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                          0xffffffff),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              removeAttachment == index
                                                  ? Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            slideImages
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xff000000),
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: const Color(
                                                                0xffffffff),
                                                          ),
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
                      } else {
                        return Container(
                          height: 0,
                        );
                      }
                    }()),
                  ),
                  Divider(
                    color: const Color(0xff2F353D),
                    thickness: 0.2,
                  ),
                  Container(
                    height: 160,
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              String result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeBLMCreatePostSearchLocation()));

                              setState(() {
                                newLocation = result;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('Add a location',
                                      style:  TextStyle(
                                        fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                        fontFamily: 'NexaRegular',
                                        color: const Color(0xff000000),
                                      ),),
                                  ),
                                  const Icon(
                                    Icons.place,
                                    color: const Color(0xff4EC9D4),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: const Color(0xff2F353D),
                          thickness: 0.2,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              BLMTaggedUsers? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeBLMCreatePostSearchUser()));

                              if (result != null) {
                                setState(() {
                                  users.add(result);
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child:
                                    Text('Tag a person you are with',
                                          style:  TextStyle(
                                            fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                            fontFamily: 'NexaRegular',
                                            color: const Color(0xff000000),
                                          ),),
                                  ),
                                  const Icon(
                                    Icons.person,
                                    color: const Color(0xff4EC9D4),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: const Color(0xff2F353D),
                          thickness: 0.2,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              var choice = await showDialog(
                                  context: (context),
                                  builder: (build) => MiscBLMUploadFromDialog(
                                        choice_1: 'Image',
                                        choice_2: 'Video',
                                      ));

                              if (choice == null) {
                                choice = 0;
                              } else {
                                if (choice == 1) {
                                  await getSlideFiles();
                                } else {
                                  await getVideo();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('Upload a Video / Image',
                                      style:  TextStyle(
                                        fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                        fontFamily: 'NexaRegular',
                                        color: const Color(0xff000000),
                                      ),),
                                  ),
                                  const Icon(
                                    Icons.image,
                                    color: const Color(0xff4EC9D4),
                                  )
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
    );
  }
}
