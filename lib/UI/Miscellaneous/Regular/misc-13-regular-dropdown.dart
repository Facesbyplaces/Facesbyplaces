import 'package:facesbyplaces/UI/Home/Regular/06-Report/home-report-regular-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-05-bloc-regular-misc.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'misc-07-regular-button.dart';
import 'package:share/share.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';


class MiscRegularDropDownTemplate extends StatefulWidget{
  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;
  final String pageType;

  MiscRegularDropDownTemplate({this.postId, this.likePost, this.likesCount, this.reportType, this.pageType});

  MiscRegularDropDownTemplateState createState() => MiscRegularDropDownTemplateState(postId: postId, likePost: likePost, likesCount: likesCount, reportType: reportType, pageType: pageType);
}

class MiscRegularDropDownTemplateState extends State<MiscRegularDropDownTemplate>{

  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;
  final String pageType;

  MiscRegularDropDownTemplateState({this.postId, this.likePost, this.likesCount, this.reportType, this.pageType});

  // final snackBar = SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2),);
  final snackBar = SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating,);

  GlobalKey qrKey = new GlobalKey();

  BranchUniversalObject buo;
  BranchLinkProperties lp;

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
        ..addCustomMetadata('link-type-of-account', 'Memorial')
    );

    lp = BranchLinkProperties(
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<void> shareQRCode() async {
    try {
      RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/qr-image.png').create();
      await file.writeAsBytes(pngBytes);

      print(pngBytes);

      Share.shareFiles(['${tempDir.path}/qr-image.png'], text: 'Scan this QR Code to check the post from FacesbyPlaces');

    } catch(e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscRegularDropDown(),
      child: BlocBuilder<BlocMiscRegularDropDown, String>(
        builder: (context, dropDownList){
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: Center(child: Icon(Icons.more_vert, color: Color(0xffaaaaaa)),),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
              color: Color(0xff888888)
            ),
            // items: <String>['Copy Link', 'Share', 'Report'].map((String value){
            items: <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: (String listValue) async{
              dropDownList = listValue;
              if(dropDownList == 'Share'){
                initBranchShare();

                FlutterBranchSdk.setIdentity('alm-share-link');

                BranchResponse response = await FlutterBranchSdk.showShareSheet(
                  buo: buo,
                  linkProperties: lp,
                  messageText: 'FacesbyPlaces App',
                  androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                  androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                );

                if (response.success) {
                  print('Link generated: ${response.result}');
                  print('showShareSheet Sucess');
                  print('The post id is $postId');
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: postId, reportType: reportType,)));
              }else if(dropDownList == 'QR Code'){
                // String qrData = 'Post-$postId-${likePost == true ? 1 : 0}-$likesCount-Memorial'; // 'link-category' - 'post-id' - 'fase/true = 0/1' - 'number-of-likes' - 'account-type'
                String qrData = 'Post-$postId-${likePost == true ? 1 : 0}-$likesCount-$pageType'; // 'link-category' - 'post-id' - 'fase/true = 0/1' - 'number-of-likes' - 'account-type'

                FullScreenMenu.show(
                  context,
                  backgroundColor: Color(0xffffffff),
                  items: [
                    Center(
                      child: Container(
                        height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 50,
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

                    Column(
                      children: [
                        Text('FacesbyPlaces Post',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xff000000),
                          ), 
                        ),

                        Text('QR Code',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xff000000),
                          ), 
                        ),

                      ],
                    ),

                    MiscRegularButtonTemplate(
                      buttonText: 'Share',
                      buttonTextStyle: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xffffffff),
                      ), 
                      onPressed: () async{
                        await shareQRCode();
                      }, 
                      width: SizeConfig.screenWidth / 2, 
                      height: SizeConfig.blockSizeVertical * 7, 
                      buttonColor: Color(0xff04ECFF),
                    ),
                  ],
                );
              }else{
                initBranchShare();
                FlutterBranchSdk.setIdentity('alm-share-copied-link');

                BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
                if (response.success) {
                  print('Link generated: ${response.result}');
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
                // FlutterClipboard.copy(response.result).then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));

                FlutterClipboard.copy(response.result).then((value) => Scaffold.of(context).showSnackBar(snackBar));
              }
            },
          );
        },
      ),  
    );
  }
}


class MiscRegularDropDownMemorialTemplate extends StatefulWidget{
  final String memorialName;
  final int memorialId;
  final String pageType;
  final String reportType;

  MiscRegularDropDownMemorialTemplate({this.memorialName, this.memorialId, this.pageType, this.reportType});

  MiscRegularDropDownMemorialTemplateState createState() => MiscRegularDropDownMemorialTemplateState(memorialName: memorialName, memorialId: memorialId, pageType: pageType, reportType: reportType);
}

class MiscRegularDropDownMemorialTemplateState extends State<MiscRegularDropDownMemorialTemplate>{
  final String memorialName;
  final int memorialId;
  final String pageType;
  final String reportType;

  MiscRegularDropDownMemorialTemplateState({this.memorialName, this.memorialId, this.pageType, this.reportType});

  final snackBar = SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating,);

  BranchUniversalObject buo;
  BranchLinkProperties lp;

  File shareImage;

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
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  // Future<void> shareQRCode() async { 
  //   try {
  //     // _RenderLayoutBuilder
      
  //       RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject(); 
  //       // RenderRepaintBoundary boundary = qrKey.currentContext.findAncestorRenderObjectOfType();
  //       var image = await boundary.toImage();
  //       // var image = await boundary.showOnScreen();
  //       ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  //       Uint8List pngBytes = byteData.buffer.asUint8List();       
  //       final tempDir = await getTemporaryDirectory();
  //       final file = await new File('${tempDir.path}/image.png').create();
  //       await file.writeAsBytes(pngBytes);
  //       // final channel = const MethodChannel('channel:me.alfian.share/share');
  //       // channel.invokeMethod('shareFile', 'image.png');
  //     } catch(e) {
  //       print(e.toString());
  //   }
  // }

  Future<void> shareQRCode() async {
    try {
      RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/qr-image.png').create();
      await file.writeAsBytes(pngBytes);

      print(pngBytes);

      // Future.delayed(const Duration(milliseconds: 20), () async {
      //   RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();
      //   ui.Image image = await boundary.toImage();
      //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      //   Uint8List pngBytes = byteData.buffer.asUint8List();
      //   print(pngBytes);
      // });

      Share.shareFiles(['${tempDir.path}/qr-image.png'], text: 'Scan this QR Code to check the memorial of $memorialName');

      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');



    } catch(e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscRegularDropDown(),
      child: BlocBuilder<BlocMiscRegularDropDown, String>(
        builder: (context, dropDownList){
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: Center(child: Icon(Icons.more_vert, color: Color(0xffaaaaaa)),),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
              color: Color(0xff888888)
            ),
            // items: <String>['Copy Link', 'Share', 'Report'].map((String value){
              items: <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: (String listValue) async{
              dropDownList = listValue;
              if(dropDownList == 'Share'){
                initBranchShare();

                FlutterBranchSdk.setIdentity('alm-share-link');

                BranchResponse response = await FlutterBranchSdk.showShareSheet(
                  buo: buo,
                  linkProperties: lp,
                  messageText: 'FacesbyPlaces App',
                  androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                  androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                );

                if (response.success) {
                  print('Link generated: ${response.result}');
                  print('showShareSheet Sucess');
                  print('The post id is $memorialId');
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: memorialId, reportType: reportType,)));
              }else if(dropDownList == 'QR Code'){
                String qrData = 'Memorial-$memorialId-$pageType'; // 'link-category' - 'link-type-of-account' - 'link-type-of-account'

                FullScreenMenu.show(
                  context,
                  backgroundColor: Color(0xffffffff),
                  items: [
                    Center(
                      child: Container(
                        height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 50,
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

                    Column(
                      children: [
                        Text('$memorialName',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xff000000),
                          ), 
                        ),

                        Text('QR Code',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xff000000),
                          ), 
                        ),

                      ],
                    ),

                    MiscRegularButtonTemplate(
                      buttonText: 'Share',
                      buttonTextStyle: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xffffffff),
                      ), 
                      onPressed: () async{
                        await shareQRCode();
                      }, 
                      width: SizeConfig.screenWidth / 2, 
                      height: SizeConfig.blockSizeVertical * 7, 
                      buttonColor: Color(0xff04ECFF),
                    ),
                  ],
                );
              }else{
                initBranchShare();
                FlutterBranchSdk.setIdentity('alm-share-copied-link');

                BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
                if (response.success) {
                  print('Link generated: ${response.result}');
                } else {
                  FlutterBranchSdk.logout();
                  print('Error : ${response.errorCode} - ${response.errorMessage}');
                }
                // FlutterClipboard.copy(response.result).then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));

                FlutterClipboard.copy(response.result).then((value) => Scaffold.of(context).showSnackBar(snackBar));
              }
            },
          );
        },
      ),  
    );
  }
}