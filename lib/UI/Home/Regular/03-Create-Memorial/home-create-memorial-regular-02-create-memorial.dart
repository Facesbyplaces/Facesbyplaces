import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-03-create-memorial.dart';
import 'package:better_player/better_player.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomeRegularCreateMemorial2 extends StatefulWidget {
  final String relationship;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;
  const HomeRegularCreateMemorial2(
      {required this.relationship,
      required this.birthplace,
      required this.dob,
      required this.rip,
      required this.cemetery,
      required this.country});

  HomeRegularCreateMemorial2State createState() =>
      HomeRegularCreateMemorial2State();
}

class HomeRegularCreateMemorial2State
    extends State<HomeRegularCreateMemorial2> {
  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 =
      GlobalKey<MiscRegularInputFieldTemplateState>();
  ValueNotifier<List<File>> slideImages = ValueNotifier<List<File>>([]);
  TextEditingController controllerStory = TextEditingController();
  ValueNotifier<File> videoFile = ValueNotifier<File>(File(''));
  ValueNotifier<int> slideCount = ValueNotifier<int>(0);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  final picker = ImagePicker();

  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      videoFile.value = File(pickedFile.path);
    }
  }

  Future getSlideImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      slideImages.value.add(File(pickedFile.path));
      slideCount.value++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('Regular create memorial screen 2 rebuild!');
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
        child: ValueListenableBuilder(
          valueListenable: toggle,
          builder: (_, int toggleListener, __) => Scaffold(
            appBar: AppBar(
              title: Text('Create a Memorial Page for Friends and family.',
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical! * 3.16,
                      fontFamily: 'NexaRegular',
                      color: const Color(0xffffffff))),
              centerTitle: true,
              backgroundColor: const Color(0xff04ECFF),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xffffffff),
                  size: SizeConfig.blockSizeVertical! * 3.52,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    height: SizeConfig.screenHeight,
                    child: const MiscRegularBackgroundTemplate(
                      image: const AssetImage('assets/icons/background2.png'),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      MiscRegularInputFieldTemplate(
                        key: _key1,
                        labelText: 'Name of your Memorial Page',
                        labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          'Name should be at least related to the person that perished. Or the family that will cherish the person in this memorial page.',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.11,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            'Share your Memories',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xff000000),
                            ),
                          ),
                          Expanded(
                            child: DefaultTabController(
                              length: 3,
                              child: TabBar(
                                isScrollable: false,
                                labelColor: const Color(0xff04ECFF),
                                unselectedLabelColor: const Color(0xff000000),
                                indicatorColor: Colors.transparent,
                                onTap: (int number) {
                                  toggle.value = number;
                                },
                                tabs: [
                                  Center(
                                    child: Text(
                                      'Text',
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeVertical! * 2.0,
                                        fontFamily: 'NexaRegular',
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Video',
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeVertical! * 2.0,
                                        fontFamily: 'NexaRegular',
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Slide',
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeVertical! * 2.0,
                                        fontFamily: 'NexaRegular',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: (() {
                          switch (toggleListener) {
                            case 0:
                              return shareStory1();
                            case 1:
                              return shareStory2();
                            case 2:
                              return shareStory3();
                          }
                        }()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Share your Memories',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.11,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff2F353D),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      MiscRegularButtonTemplate(
                        width: 150,
                        height: 45,
                        buttonTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.64,
                          fontFamily: 'NexaBold',
                          color: const Color(0xffFFFFFF),
                        ),
                        onPressed: () async {
                          if (_key1.currentState!.controller.text == '') {
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
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical! * 3.16,
                                      fontFamily: 'NexaRegular'),
                                ),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text(
                                  'Please complete the form before submitting.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical! * 2.87,
                                      fontFamily: 'NexaRegular'),
                                ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          } else {
                            List<File> newFiles = [];

                            if (videoFile.value.path != '') {
                              newFiles.add(videoFile.value);
                            }

                            if (slideImages.value != []) {
                              newFiles.addAll(slideImages.value);
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomeRegularCreateMemorial3(
                                  relationship: widget.relationship,
                                  birthplace: widget.birthplace,
                                  dob: widget.dob,
                                  rip: widget.rip,
                                  cemetery: widget.cemetery,
                                  country: widget.country,
                                  description: controllerStory.text,
                                  memorialName:
                                      _key1.currentState!.controller.text,
                                  imagesOrVideos: newFiles,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  shareStory1() {
    return TextFormField(
      controller: controllerStory,
      cursorColor: const Color(0xff000000),
      maxLines: 10,
      keyboardType: TextInputType.text,
      readOnly: false,
      decoration: const InputDecoration(
        fillColor: const Color(0xffffffff),
        filled: true,
        alignLabelWithHint: true,
        labelText: '',
        labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xff888888)),
        border: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  shareStory2() {
    return ValueListenableBuilder(
      valueListenable: videoFile,
      builder: (_, File videoFileListener, __) => Container(
        width: SizeConfig.screenWidth,
        child: GestureDetector(
          onTap: () async {
            await getVideo();
          },
          child: videoFileListener.path != ''
              ? Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Dialog',
                          transitionDuration: const Duration(milliseconds: 0),
                          pageBuilder: (_, __, ___) {
                            return Scaffold(
                              backgroundColor: Colors.black12.withOpacity(0.7),
                              body: SizedBox.expand(
                                child: SafeArea(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                const Color(0xff000000)
                                                    .withOpacity(0.8),
                                            child: const Icon(
                                              Icons.close_rounded,
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: BetterPlayer.file(
                                          videoFileListener.path,
                                          betterPlayerConfiguration:
                                              BetterPlayerConfiguration(
                                            deviceOrientationsAfterFullScreen: [
                                              DeviceOrientation.portraitUp
                                            ],
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 85,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: BetterPlayer.file(
                        videoFileListener.path,
                        betterPlayerConfiguration: BetterPlayerConfiguration(
                          deviceOrientationsAfterFullScreen: [
                            DeviceOrientation.portraitUp
                          ],
                          controlsConfiguration:
                              const BetterPlayerControlsConfiguration(
                            showControls: false,
                          ),
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        iconSize: 25,
                        onPressed: () {
                          videoFile.value = File('');
                        },
                        icon: const CircleAvatar(
                          backgroundColor: const Color(0xff000000),
                          child: const Icon(
                            Icons.close,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 260,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xffcccccc),
                    border: Border.all(
                      color: const Color(0xff000000),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
        ),
      ),
    );
  }

  shareStory3() {
    return ValueListenableBuilder(
      valueListenable: slideImages,
      builder: (_, List<File> slideImagesListener, __) =>
          ValueListenableBuilder(
        valueListenable: slideCount,
        builder: (_, int slideCountListener, __) => Column(
          children: [
            Container(
              height: 260,
              width: SizeConfig.screenWidth,
              child: Container(
                height: 100,
                child: GridView.count(
                  physics: const ClampingScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: List.generate(slideCountListener + 1, (index) {
                    return (() {
                      if (index == slideCountListener) {
                        return GestureDetector(
                          onTap: () async {
                            await getSlideImage();
                          },
                          child: Container(
                            width: 80,
                            child: const Icon(Icons.add_rounded,
                                color: const Color(0xff000000), size: 60),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffcccccc),
                              border: Border.all(
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onDoubleTap: () {
                            slideImages.value.removeAt(index);
                            slideCount.value--;
                          },
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: 'Dialog',
                              transitionDuration:
                                  const Duration(milliseconds: 0),
                              pageBuilder: (_, __, ___) {
                                return Scaffold(
                                  backgroundColor:
                                      Colors.black12.withOpacity(0.7),
                                  body: SizedBox.expand(
                                    child: SafeArea(
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(
                                                right: 20.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    const Color(0xff000000)
                                                        .withOpacity(0.8),
                                                child: const Icon(
                                                  Icons.close_rounded,
                                                  color:
                                                      const Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Expanded(
                                            // child: Image.asset(
                                            //   slideImagesListener[index].path,
                                            //   fit: BoxFit.cover,
                                            //   scale: 1.0,
                                            // ),
                                            child: Image.file(
                                              slideImagesListener[index],
                                              fit: BoxFit.contain,
                                            ),
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
                          child: Container(
                            width: 80,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    slideImagesListener[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: const Color(0xffffffff)
                                            .withOpacity(.5),
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // child: Container(
                          //   width: 80,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     color: const Color(0xffcccccc),
                          //     border: Border.all(color: const Color(0xff000000),),
                          //     image: DecorationImage(
                          //       fit: BoxFit.cover,
                          //       image: AssetImage(slideImagesListener[index].path),
                          //     ),
                          //   ),
                          //   child: Stack(
                          //     children: [
                          //       Center(
                          //         child: CircleAvatar(
                          //           radius: 25,
                          //           backgroundColor: const Color(0xffffffff).withOpacity(.5),
                          //           child: Text('${index + 1}',
                          //             style: const TextStyle(
                          //               fontSize: 40,
                          //               fontWeight: FontWeight.bold,
                          //               color: const Color(0xffffffff),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        );
                      }
                    }());
                  }),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Double tap to remove images.',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
