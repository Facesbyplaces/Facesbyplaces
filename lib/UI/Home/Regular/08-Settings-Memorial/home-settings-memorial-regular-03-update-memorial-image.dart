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

class HomeRegularMemorialPageImage extends StatefulWidget {
  final int memorialId;
  const HomeRegularMemorialPageImage({required this.memorialId});

  HomeRegularMemorialPageImageState createState() =>
      HomeRegularMemorialPageImageState(memorialId: memorialId);
}

class HomeRegularMemorialPageImageState
    extends State<HomeRegularMemorialPageImage> {
  final int memorialId;
  HomeRegularMemorialPageImageState({required this.memorialId});

  List<String> backgroundImages = [
    'assets/icons/alm-background1.png',
    'assets/icons/alm-background3.png',
    'assets/icons/alm-background4.png',
    'assets/icons/alm-background5.png'
  ];
  int backgroundImageToggle = 0;
  final picker = ImagePicker();
  File backgroundImage = File('');
  File profileImage = File('');
  Future<APIRegularShowPageImagesMain>? futureMemorialSettings;

  Future getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future getBackgroundImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        backgroundImage = File(pickedFile.path);
      });
      print('Success');
    }
  }

  Future<APIRegularShowPageImagesMain> getMemorialSettings(
      int memorialId) async {
    return await apiRegularShowPageImages(memorialId: memorialId);
  }

  void initState() {
    super.initState();
    futureMemorialSettings = getMemorialSettings(memorialId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff04ECFF),
        title: Row(
          children: [
            Text(
              'Page Image',
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
        leading: IconButton(
          icon:  Icon(
            Icons.arrow_back,
            color: const Color(0xffffffff),
            size: SizeConfig.blockSizeVertical! * 3.52,
          ),
          onPressed: () async {
            if (profileImage.path != '' ||
                (backgroundImage.path != '' && backgroundImageToggle != 0)) {
              bool confirmResult = await showDialog(
                  context: (context),
                  builder: (build) => const MiscRegularConfirmDialog(
                        title: 'Confirm',
                        content: 'Do you want to discard the changes?',
                        confirmColor_1: const Color(0xff04ECFF),
                        confirmColor_2: const Color(0xffFF0000),
                      ));
              if (confirmResult) {
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: FutureBuilder<APIRegularShowPageImagesMain>(
          future: futureMemorialSettings,
          builder: (context, memorialImageSettings) {
            if (memorialImageSettings.hasData) {
              return Stack(
                children: [
                  const MiscRegularBackgroundTemplate(
                    image: const AssetImage('assets/icons/background2.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                         Text(
                          'Upload or Select an Image',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.65,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: backgroundImage.path != ''
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage('${backgroundImage.path}'),
                                    )
                                  : DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          '${memorialImageSettings.data!.almMemorial.showPageImagesBackgroundImage}'))),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await getProfileImage();
                                },
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: const Color(0xffffffff),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: profileImage.path != ''
                                          ? CircleAvatar(
                                              radius: 120,
                                              backgroundColor:
                                                  const Color(0xff888888),
                                              foregroundImage:
                                                  AssetImage(profileImage.path),
                                              backgroundImage: const AssetImage(
                                                  'assets/icons/app-icon.png'),
                                            )
                                          : CircleAvatar(
                                              radius: 120,
                                              backgroundColor:
                                                  const Color(0xff888888),
                                              foregroundImage: NetworkImage(
                                                  memorialImageSettings
                                                      .data!
                                                      .almMemorial
                                                      .showPageImagesProfileImage),
                                              backgroundImage: const AssetImage(
                                                  'assets/icons/app-icon.png'),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 40,
                                left: SizeConfig.screenWidth! / 2,
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: const Color(0xffffffff),
                                  child: const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    child: const Icon(
                                      Icons.camera,
                                      color: const Color(0xffaaaaaa),
                                      size: 45,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: 10,
                                right: 10,
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: const Color(0xffffffff),
                                  child: const Icon(
                                    Icons.camera,
                                    color: const Color(0xffaaaaaa),
                                    size: 45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Upload the best photo of the person in the memorial page.',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 1.76,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff2F353D),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Choose Background',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.65,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff000000),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          child: ListView.separated(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return (() {
                                if (index == 4) {
                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        backgroundImageToggle = index;
                                      });

                                      await getBackgroundImage();
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: const Icon(
                                        Icons.add_rounded,
                                        color: const Color(0xff000000),
                                        size: 60,
                                      ),
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
                                    onTap: () async {
                                      final ByteData bytes = await rootBundle
                                          .load(backgroundImages[index]);
                                      final Uint8List list =
                                          bytes.buffer.asUint8List();

                                      final tempDir =
                                          await getTemporaryDirectory();
                                      final file = await new File(
                                              '${tempDir.path}/regular-background-image-$index.png')
                                          .create();
                                      file.writeAsBytesSync(list);

                                      setState(() {
                                        backgroundImageToggle = index;
                                        backgroundImage = file;
                                      });
                                    },
                                    child: backgroundImageToggle == index
                                        ? Container(
                                            padding: const EdgeInsets.all(5),
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff04ECFF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      backgroundImages[index]),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(5),
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      backgroundImages[index]),
                                                ),
                                              ),
                                            ),
                                          ),
                                  );
                                }
                              }());
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 25,
                              );
                            },
                            itemCount: 5,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Upload your own or select from the pre-mades.',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 1.76,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xff2F353D),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        MiscRegularButtonTemplate(
                          buttonText: 'Speak Out',
                          buttonTextStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.64,
                            fontFamily: 'NexaRegular',
                            color: const Color(0xffFFFFFF),
                          ),
                          width: 150,
                          height: 45,
                          buttonColor: const Color(0xff000000),
                          onPressed: () async {
                            if (profileImage.path != '' ||
                                backgroundImage.path != '') {
                              context.loaderOverlay.show();
                              bool result = await apiRegularUpdatePageImages(
                                  memorialId: memorialId,
                                  backgroundImage: backgroundImage,
                                  profileImage: profileImage);
                              context.loaderOverlay.hide();

                              if (result) {
                                await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                          image: Image.asset(
                                            'assets/icons/cover-icon.png',
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(
                                            'Success',
                                            textAlign: TextAlign.center,
                                            style:  TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                                fontFamily: 'NexaRegular'),
                                          ),
                                          entryAnimation:
                                              EntryAnimation.DEFAULT,
                                          description: Text(
                                            'Successfully updated the memorial image.',
                                            textAlign: TextAlign.center,
                                            style:  TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                                fontFamily: 'NexaRegular'
                                            ),
                                          ),
                                          onlyOkButton: true,
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ));
                                Route route = MaterialPageRoute(
                                    builder: (context) => HomeRegularProfile(
                                        memorialId: memorialId,
                                        managed: true,
                                        newlyCreated: false,
                                        relationship: memorialImageSettings
                                            .data!
                                            .almMemorial
                                            .showPageImagesRelationship));
                                Navigator.of(context).pushAndRemoveUntil(route,
                                    ModalRoute.withName('/home/regular'));
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
                                          entryAnimation:
                                              EntryAnimation.DEFAULT,
                                          description: Text(
                                            'Something went wrong. Please try again.',
                                            textAlign: TextAlign.center,
                                            style:  TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                                fontFamily: 'NexaRegular'
                                            ),
                                          ),
                                          onlyOkButton: true,
                                          buttonOkColor:
                                              const Color(0xffff0000),
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (memorialImageSettings.hasError) {
              return Container(
                  height: SizeConfig.screenHeight,
                  child: const Center(
                    child: const Text(
                      'Something went wrong. Please try again.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ));
            } else {
              return Container(
                height: SizeConfig.screenHeight,
                child: Center(
                  child: Container(
                    child: const SpinKitThreeBounce(
                      color: const Color(0xff000000),
                      size: 50.0,
                    ),
                    color: const Color(0xffffffff),
                  ),
                ),
              );
            }
          }),
    );
  }
}
