// ignore_for_file: file_names
import 'package:facesbyplaces/UI/Home/BLM/06-Report/home-report-blm-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-misc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:path_provider/path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
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
  final String pageName;
  const MiscBLMDropDownTemplate({required this.postId, required this.likePost, required this.likesCount, required this.reportType, required this.pageType, required this.pageName});

  MiscBLMDropDownTemplateState createState() => MiscBLMDropDownTemplateState();
}

class MiscBLMDropDownTemplateState extends State<MiscBLMDropDownTemplate>{
  GlobalKey qrKey = new GlobalKey();
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;

  void initBranchShare(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
      ..addCustomMetadata('link-category', 'Post')
      ..addCustomMetadata('link-post-id', widget.postId)
      ..addCustomMetadata('link-like-status', widget.likePost)
      ..addCustomMetadata('link-number-of-likes', widget.likesCount)
      ..addCustomMetadata('link-type-of-account', 'Blm'),
    );

    lp = BranchLinkProperties(feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three']);
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<void> shareQRCode(String qrData) async{
    try{
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
        final file = await new File('${tempDir.path}/blm-qr-code.png').create();
        file.writeAsBytesSync(list);

        print('The file is ${file.path}');

        Share.shareFiles(['${file.path}'], text: 'QR Code');
      }else{
        await showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            description: Text('Invalid QR Code.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            entryAnimation: EntryAnimation.DEFAULT,
            buttonOkColor: const Color(0xffff0000),
            onlyOkButton: true,
            onOkButtonPressed: (){
              Navigator.pop(context, true);
            },
          ),
        );
      }
    }catch (e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscBLMDropDown(),
      child: BlocBuilder<BlocMiscBLMDropDown, String>(
        builder: (context, dropDownList) {
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: const Center(child: const Icon(Icons.more_vert, color: const Color(0xffaaaaaa)),),
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: const Color(0xff888888)),
            items: <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(child: Text(value),),
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
                  androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                );

                if(response.success){
                  await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                      description: Text('Successfully shared the link.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      entryAnimation: EntryAnimation.DEFAULT,
                      onlyOkButton: true,
                      onOkButtonPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }else{
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: widget.postId, reportType: widget.reportType,)));
              }else if(dropDownList == 'QR Code'){
                String qrData = 'Post-${widget.postId}-${widget.likePost == true ? 1 : 0}-${widget.likesCount}-${widget.pageType}'; // 'link-category' - 'post-id' - 'fase/true = 0/1' - 'number-of-likes' - 'account-type'
                print('The qrData on click is $qrData');

                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black12.withOpacity(0.7),
                  transitionDuration: Duration(milliseconds: 0),
                  barrierDismissible: true,
                  barrierLabel: 'Dialog',
                  pageBuilder: (_, __, ___){
                    return SizedBox.expand(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(right: 20.0),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: const Icon(Icons.close_rounded, color: const Color(0xffffffff), size: 30,),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: SizeConfig.screenHeight! - 400,
                                color: Colors.black26,
                                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 10, right: SizeConfig.blockSizeHorizontal! * 10, top: SizeConfig.blockSizeHorizontal! * 20, bottom: SizeConfig.blockSizeHorizontal! * 25),
                                child: Material(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      border: Border.all(color: const Color(0xffffffff),),
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal! * 2),
                                    ),
                                    child: Column(
                                      children: [
                                        const Spacer(),

                                        Center(child: RepaintBoundary(key: qrKey, child: QrImage(data: qrData, version: QrVersions.auto, size: 320, gapless: false,),),),

                                        const Spacer(),

                                        Text('${widget.pageName}', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),

                                        Text('QR Code', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),

                                        const Spacer(),

                                        MiscBLMButtonTemplate(
                                          buttonText: 'Share',
                                          buttonTextStyle: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                                          buttonColor: const Color(0xff04ECFF),
                                          width: SizeConfig.screenWidth! / 2,
                                          height: 50,
                                          onPressed: () async{
                                            await shareQRCode(qrData);
                                          },
                                        ),

                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                if(response.success){
                  await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                      description: Text('Successfully copied the link.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      entryAnimation: EntryAnimation.DEFAULT,
                      onlyOkButton: true,
                      onOkButtonPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }else{
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

class MiscBLMDropDownMemorialTemplate extends StatefulWidget {
  final String memorialName;
  final int memorialId;
  final String pageType;
  final String reportType;
  const MiscBLMDropDownMemorialTemplate({required this.memorialName, required this.memorialId, required this.pageType, required this.reportType});

  MiscBLMDropDownMemorialTemplateState createState() => MiscBLMDropDownMemorialTemplateState();
}

class MiscBLMDropDownMemorialTemplateState extends State<MiscBLMDropDownMemorialTemplate>{
  final snackBar = const SnackBar(content: const Text('Link copied!'), backgroundColor: const Color(0xff4EC9D4), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating,);
  GlobalKey qrKey = new GlobalKey();
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;

  void initBranchShare() {
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('link-category', 'Memorial')
        ..addCustomMetadata('link-memorial-id', widget.memorialId)
        ..addCustomMetadata('link-type-of-account', widget.pageType,
      ),
    );

    lp = BranchLinkProperties(feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three']);
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<void> shareQRCode(String qrData) async{
    try{
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
          builder: (_) => AssetGiffyDialog(
            description: Text('Invalid QR Code.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            entryAnimation: EntryAnimation.DEFAULT,
            buttonOkColor: const Color(0xffff0000),
            onlyOkButton: true,
            onOkButtonPressed: (){
              Navigator.pop(context, true);
            },
          ),
        );
      }
    }catch (e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscBLMDropDown(),
      child: BlocBuilder<BlocMiscBLMDropDown, String>(
        builder: (context, dropDownList){
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: const Center(child: const Icon(Icons.more_vert, color: const Color(0xffffffff)),),
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: const Color(0xff888888)),
            items: const <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(child: Text(value),),
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
                  androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                );

                if(response.success){
                  await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                      description: Text('Successfully copied the link.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',)),
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      entryAnimation: EntryAnimation.DEFAULT,
                      onlyOkButton: true,
                      onOkButtonPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }else{
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: widget.memorialId, reportType: widget.reportType,)));
              }else if(dropDownList == 'QR Code'){
                String qrData = 'Memorial-${widget.memorialId}-${widget.pageType}'; // 'link-category' - 'link-type-of-account' - 'link-type-of-account'

                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black12.withOpacity(0.7),
                  transitionDuration: const Duration(milliseconds: 0),
                  barrierDismissible: true,
                  barrierLabel: 'Dialog',
                  pageBuilder: (_, __, ___){
                    return SizedBox.expand(
                      child: SafeArea(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(right: 20.0),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: const Icon(Icons.close_rounded, color: const Color(0xffffffff), size: 30,),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),

                            Expanded(
                              child: Container(
                                height: SizeConfig.screenHeight! - 400,
                                color: Colors.black26,
                                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 10, right: SizeConfig.blockSizeHorizontal! * 10, top: SizeConfig.blockSizeHorizontal! * 20, bottom: SizeConfig.blockSizeHorizontal! * 25),
                                child: Material(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      border: Border.all(color: const Color(0xffffffff),),
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal! * 2),
                                    ),
                                    child: Column(
                                      children: [
                                        const Spacer(),

                                        Center(child: RepaintBoundary(key: qrKey, child: QrImage(data: qrData, version: QrVersions.auto, size: 320, gapless: false,),),),

                                        const Spacer(),

                                        Text('${widget.memorialName}', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),

                                        Text('QR Code', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),

                                        const Spacer(),

                                        MiscBLMButtonTemplate(
                                          buttonText: 'Share',
                                          buttonTextStyle: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                                          buttonColor: const Color(0xff04ECFF),
                                          width: SizeConfig.screenWidth! / 2,
                                          height: 50,
                                          onPressed: () async{
                                            await shareQRCode(qrData);
                                          },
                                        ),

                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                if(response.success){
                  await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                      description: Text('Successfully copied the link.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      entryAnimation: EntryAnimation.DEFAULT,
                      onlyOkButton: true,
                      onOkButtonPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }else{
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