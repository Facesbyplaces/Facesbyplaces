import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-blm-03-create-memorial.dart';
import 'package:better_player/better_player.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomeBLMCreateMemorial2 extends StatefulWidget {
  final String relationship;
  final String locationOfIncident;
  final String precinct;
  final String dob;
  final String rip;
  final String country;
  final String state;

  const HomeBLMCreateMemorial2(
      {required this.relationship,
      required this.locationOfIncident,
      required this.precinct,
      required this.dob,
      required this.rip,
      required this.country,
      required this.state});

  HomeBLMCreateMemorial2State createState() => HomeBLMCreateMemorial2State(
      relationship: relationship,
      locationOfIncident: locationOfIncident,
      precinct: precinct,
      dob: dob,
      rip: rip,
      country: country,
      state: state);
}

class HomeBLMCreateMemorial2State extends State<HomeBLMCreateMemorial2> {
  final String relationship;
  final String locationOfIncident;
  final String precinct;
  final String dob;
  final String rip;
  final String country;
  final String state;

  HomeBLMCreateMemorial2State(
      {required this.relationship,
      required this.locationOfIncident,
      required this.precinct,
      required this.dob,
      required this.rip,
      required this.country,
      required this.state});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 =
      GlobalKey<MiscBLMInputFieldTemplateState>();
  TextEditingController controllerStory = TextEditingController();
  List<File> slideImages = [];
  int toggle = 0;
  File videoFile = File('');
  File imageFile = File('');
  File newFile = File('');
  final picker = ImagePicker();

  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        videoFile = File(pickedFile.path);
      });
    }
  }

  Future getSlideImage() async {
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
            title: Text('Cry out for the Victims',
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
                  child: const MiscBLMBackgroundTemplate(
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
                    MiscBLMInputFieldTemplate(
                        key: _key1, labelText: 'Name of your Memorial Page',
                      labelTextStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.11,
                        fontFamily: 'NexaRegular',
                        color: const Color(0xff000000),
                      ),),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text(
                          'Share your Story',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.11,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
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
                                setState(() {
                                  toggle = number;
                                });
                              },
                              tabs: [
                                Center(
                                  child: Text(
                                    'Text',
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.0,
                                      fontFamily: 'NexaRegular',
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Video',
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.0,
                                      fontFamily: 'NexaRegular',
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Slide',
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.0,
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
                        switch (toggle) {
                          case 0:
                            return shareStory1();
                          case 1:
                            return shareStory2();
                          case 2:
                            return shareStory3();
                        }
                      }()),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Describe the events that happened to your love one.',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.11,
                        fontFamily: 'NexaRegular',
                        color: const Color(0xff2F353D),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical! * 16.02),
                    MiscBLMButtonTemplate(
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
                                      fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                      fontFamily: 'NexaRegular'),
                                ),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text(
                                  'Please complete the form before submitting.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: SizeConfig
                                          .blockSizeVertical! *
                                          2.87,
                                      fontFamily: 'NexaRegular'),
                                ),
                                    onlyOkButton: true,
                                    buttonOkColor: const Color(0xffff0000),
                                    onOkButtonPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  ));
                        } else {
                          List<File> newFiles = [];

                          if (videoFile.path != '') {
                            newFiles.add(videoFile);
                          }

                          if (slideImages != []) {
                            newFiles.addAll(slideImages);
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeBLMCreateMemorial3(
                                  relationship: relationship,
                                  locationOfIncident: locationOfIncident,
                                  precinct: precinct,
                                  dob: dob,
                                  rip: rip,
                                  country: country,
                                  state: state,
                                  description: controllerStory.text,
                                  memorialName:
                                      _key1.currentState!.controller.text,
                                  imagesOrVideos: newFiles,
                                ),
                              ));
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
    );
  }

  shareStory1() {
    return TextFormField(
      controller: controllerStory,
      cursorColor: Color(0xff000000),
      maxLines: 10,
      keyboardType: TextInputType.text,
      readOnly: false,
      decoration: InputDecoration(
        fillColor: Color(0xffffffff),
        filled: true,
        alignLabelWithHint: true,
        labelText: '',
        labelStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  shareStory2() {
    return Container(
      width: SizeConfig.screenWidth,
      child: GestureDetector(
        onTap: () async {
          await getVideo();
        },
        child: videoFile.path != ''
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
                                        videoFile.path,
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
                      videoFile.path,
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
                        setState(() {
                          videoFile = File('');
                        });
                      },
                      icon: CircleAvatar(
                        backgroundColor: Color(0xff000000),
                        child: Icon(
                          Icons.close,
                          color: Color(0xffffffff),
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
                  color: Color(0xffcccccc),
                  border: Border.all(
                    color: Color(0xff000000),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
      ),
    );
  }

  shareStory3() {
    return Column(
      children: [
        Container(
          height: 260,
          width: SizeConfig.screenWidth,
          child: Container(
            height: 100,
            child: GridView.count(
              physics: ClampingScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: List.generate(slideImages.length + 1, (index) {
                return (() {
                  if (index == slideImages.length) {
                    return GestureDetector(
                      onTap: () async {
                        await getSlideImage();
                      },
                      child: Container(
                        width: 80,
                        child: Icon(
                          Icons.add_rounded,
                          color: Color(0xff000000),
                          size: 60,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffcccccc),
                          border: Border.all(
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          slideImages.removeAt(index);
                        });
                      },
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Dialog',
                          transitionDuration: Duration(milliseconds: 0),
                          pageBuilder: (_, __, ___) {
                            return Scaffold(
                              backgroundColor: Colors.black12.withOpacity(0.7),
                              body: SizedBox.expand(
                                child: SafeArea(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Color(0xff000000)
                                                .withOpacity(0.8),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: Image.asset(
                                          slideImages[index].path,
                                          fit: BoxFit.cover,
                                          scale: 1.0,
                                        ),
                                      ),
                                      SizedBox(
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffcccccc),
                          border: Border.all(
                            color: Color(0xff000000),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(slideImages[index].path),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Color(0xffffffff).withOpacity(.5),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }());
              }),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Double tap to remove images.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color(0xff000000),
            ),
          ),
        ),
      ],
    );
  }
}
