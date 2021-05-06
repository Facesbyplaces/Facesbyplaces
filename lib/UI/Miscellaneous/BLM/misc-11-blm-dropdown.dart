import 'package:facesbyplaces/UI/Home/BLM/06-Report/home-report-blm-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc-blm-misc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'misc-06-blm-button.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';

class MiscBLMDropDownTemplate extends StatefulWidget{
  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;
  final String pageType;

  const MiscBLMDropDownTemplate({required this.postId, required this.likePost, required this.likesCount, required this.reportType, required this.pageType});

  MiscBLMDropDownTemplateState createState() => MiscBLMDropDownTemplateState(postId: postId, likePost: likePost, likesCount: likesCount, reportType: reportType, pageType: pageType);
}

class MiscBLMDropDownTemplateState extends State<MiscBLMDropDownTemplate>{

  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;
  final String pageType;

  MiscBLMDropDownTemplateState({required this.postId, required this.likePost, required this.likesCount, required this.reportType, required this.pageType});

  BranchUniversalObject? buo;
  BranchLinkProperties? lp;
  GlobalKey qrKey = new GlobalKey();

  void initBranchShare(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('link-category', 'Post')
        ..addCustomMetadata('link-post-id', postId)
        ..addCustomMetadata('link-like-status', likePost)
        ..addCustomMetadata('link-number-of-likes', likesCount)
        ..addCustomMetadata('link-type-of-account', 'Blm')
    );

    lp = BranchLinkProperties(
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<void> shareQRCode(String qrData) async {
    try {
      QrValidationResult qrValidationResult = QrValidator.validate(
        data: qrData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if(qrValidationResult.status == QrValidationStatus.valid){
        QrCode? qrCode = qrValidationResult.qrCode;

        final painter = QrPainter.withQr(
          qr: qrCode!,
          color: const Color(0xff000000),
          gapless: true,
        );

        final ByteData bytes = (await painter.toImageData(320))!;
        final Uint8List list = bytes.buffer.asUint8List();

        final tempDir = await getTemporaryDirectory();
        final file = await new File('${tempDir.path}/qr-code.png').create();
        file.writeAsBytesSync(list);

        Share.shareFiles(['${file.path}'], text: 'QR Code');
      }else{
        await showDialog(
          context: context,
          builder: (_) => 
            AssetGiffyDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: const Text('Invalid QR Code.',
              textAlign: TextAlign.center,
            ),
            onlyOkButton: true,
            buttonOkColor: const Color(0xffff0000),
            onOkButtonPressed: () {
              Navigator.pop(context, true);
            },
          )
        );
      }
    } catch(e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscBLMDropDown(),
      child: BlocBuilder<BlocMiscBLMDropDown, String>(
        builder: (context, dropDownList){
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: const Center(child: const Icon(Icons.more_vert, color: const Color(0xffaaaaaa)),),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: const Color(0xff888888)
            ),
              items: <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: (String? listValue) async{
              dropDownList = listValue!;
              if(dropDownList == 'Share'){
                initBranchShare();

                FlutterBranchSdk.setIdentity('blm-share-link');

                BranchResponse response = await FlutterBranchSdk.showShareSheet(
                  buo: buo!,
                  linkProperties: lp!,
                  messageText: 'FacesbyPlaces App',
                  androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                  androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                );

                if (response.success) {
                  await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Successfully shared the link.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: postId, reportType: reportType,)));
              }else if(dropDownList == 'QR Code'){
                String qrData = 'Post-$postId-${likePost == true ? 1 : 0}-$likesCount-$pageType'; // 'link-category' - 'post-id' - 'fase/true = 0/1' - 'number-of-likes' - 'account-type'

                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black12.withOpacity(0.7),
                  barrierDismissible: true,
                  barrierLabel: 'Dialog',
                  transitionDuration: Duration(milliseconds: 0),
                  pageBuilder: (_, __, ___) {
                    return SizedBox.expand(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(right: 20.0),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close_rounded, color: const Color(0xffffffff), size: 30,),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: SizeConfig.screenHeight! - 400,
                                color: const Color(0xffffffff),
                                child: Center(
                                  child: RepaintBoundary(
                                    key: qrKey,
                                    child: QrImage(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      size: 320,
                                      gapless: false,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMButtonTemplate(
                              buttonText: 'Share',
                              buttonTextStyle: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, 
                                color: const Color(0xffffffff),
                              ),
                              width: SizeConfig.screenWidth! / 2,
                              height: 45,
                              buttonColor: const Color(0xff04ECFF), 
                              onPressed: () async{
                                await shareQRCode(qrData);
                              },
                            ),

                            const SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    );
                  },
                );
              }else{
                initBranchShare();
                FlutterBranchSdk.setIdentity('blm-share-copied-link');

                BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
                if (response.success) {
                  await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Successfully copied the link.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }

                FlutterClipboard.copy(response.result).then((value) => const ScaffoldMessenger(child: const Text('Link copied!'),));

              }
            },
            
          );
        },
      ),  
    );
  }
}

class MiscBLMDropDownMemorialTemplate extends StatefulWidget{
  final String memorialName;
  final int memorialId;
  final String pageType;
  final String reportType;

  const MiscBLMDropDownMemorialTemplate({required this.memorialName, required this.memorialId, required this.pageType, required this.reportType});

  MiscBLMDropDownMemorialTemplateState createState() => MiscBLMDropDownMemorialTemplateState(memorialName: memorialName, memorialId: memorialId, pageType: pageType, reportType: reportType);
}

class MiscBLMDropDownMemorialTemplateState extends State<MiscBLMDropDownMemorialTemplate>{
  final String memorialName;
  final int memorialId;
  final String pageType;
  final String reportType;

  MiscBLMDropDownMemorialTemplateState({required this.memorialName, required this.memorialId, required this.pageType, required this.reportType});

  final snackBar = const SnackBar(content: const Text('Link copied!'), backgroundColor: const Color(0xff4EC9D4), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating,);

  BranchUniversalObject? buo;
  BranchLinkProperties? lp;
  GlobalKey qrKey = new GlobalKey();

  void initBranchShare(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('link-category', 'Memorial')
        ..addCustomMetadata('link-memorial-id', memorialId)
        ..addCustomMetadata('link-type-of-account', pageType)
    );

    lp = BranchLinkProperties(
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<void> shareQRCode(String qrData) async {
    try {
      QrValidationResult qrValidationResult = QrValidator.validate(
        data: qrData,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if(qrValidationResult.status == QrValidationStatus.valid){
        QrCode? qrCode = qrValidationResult.qrCode;

        final painter = QrPainter.withQr(
          qr: qrCode!,
          color: const Color(0xff000000),
          gapless: true,
          embeddedImageStyle: null,
          embeddedImage: null,
        );

        final ByteData bytes = (await painter.toImageData(320))!;
        final Uint8List list = bytes.buffer.asUint8List();

        final tempDir = await getTemporaryDirectory();
        final file = await new File('${tempDir.path}/qr-code.png').create();
        file.writeAsBytesSync(list);

        Share.shareFiles(['${file.path}'], text: 'QR Code');
      }else{
        await showDialog(
          context: context,
          builder: (_) => 
            AssetGiffyDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: const Text('Invalid QR Code.',
              textAlign: TextAlign.center,
            ),
            onlyOkButton: true,
            buttonOkColor: const Color(0xffff0000),
            onOkButtonPressed: () {
              Navigator.pop(context, true);
            },
          )
        );
      }
    } catch(e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscBLMDropDown(),
      child: BlocBuilder<BlocMiscBLMDropDown, String>(
        builder: (context, dropDownList){
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: const Center(child: const Icon(Icons.more_vert, color: const Color(0xffffffff)),),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: const Color(0xff888888)
            ),
              items: const <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: (String? listValue) async{
              dropDownList = listValue!;
              if(dropDownList == 'Share'){
                initBranchShare();

                FlutterBranchSdk.setIdentity('blm-share-link');

                BranchResponse response = await FlutterBranchSdk.showShareSheet(
                  buo: buo!,
                  linkProperties: lp!,
                  messageText: 'FacesbyPlaces App',
                  androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                  androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                );
                if (response.success) {
                  await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Successfully shared the link.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: memorialId, reportType: reportType,)));
              }else if(dropDownList == 'QR Code'){
                String qrData = 'Memorial-$memorialId-$pageType'; // 'link-category' - 'link-type-of-account' - 'link-type-of-account'

                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black12.withOpacity(0.7),
                  barrierDismissible: true,
                  barrierLabel: 'Dialog',
                  transitionDuration: Duration(milliseconds: 0),
                  pageBuilder: (_, __, ___) {
                    return SizedBox.expand(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(right: 20.0),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close_rounded, color: const Color(0xffffffff), size: 30,),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: SizeConfig.screenHeight! - 400,
                                color: const Color(0xffffffff),
                                child: Center(
                                  child: RepaintBoundary(
                                    key: qrKey,
                                    child: QrImage(
                                      data: qrData,
                                      version: QrVersions.auto,
                                      size: 320,
                                      gapless: false,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMButtonTemplate(
                              buttonText: 'Share',
                              buttonTextStyle: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, 
                                color: const Color(0xffffffff),
                              ),
                              width: SizeConfig.screenWidth! / 2,
                              height: 45,
                              buttonColor: const Color(0xff04ECFF), 
                              onPressed: () async{
                                await shareQRCode(qrData);
                              },
                            ),

                            const SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    );
                  },
                );
              }else{
                initBranchShare();
                FlutterBranchSdk.setIdentity('blm-share-copied-link');

                BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
                if (response.success) {
                  await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Successfully copied the link.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }

                FlutterClipboard.copy(response.result).then((value) => const ScaffoldMessenger(child: const Text('Link copied!'),));
              }
            },
          );
        },
      ),  
    );
  }
}