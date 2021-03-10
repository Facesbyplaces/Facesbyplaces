import 'package:facesbyplaces/UI/Home/BLM/06-Report/home-report-blm-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc-blm-misc.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// import 'package:full_screen_menu/full_screen_menu.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:clipboard/clipboard.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
// import 'package:share/share.dart';
// import 'misc-06-blm-button.dart';
// import 'dart:typed_data';
// import 'dart:io';
import 'dart:ui';

class MiscBLMDropDownTemplate extends StatefulWidget{
  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;
  final String pageType;

  MiscBLMDropDownTemplate({required this.postId, required this.likePost, required this.likesCount, required this.reportType, required this.pageType});

  MiscBLMDropDownTemplateState createState() => MiscBLMDropDownTemplateState(postId: postId, likePost: likePost, likesCount: likesCount, reportType: reportType, pageType: pageType);
}

class MiscBLMDropDownTemplateState extends State<MiscBLMDropDownTemplate>{

  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;
  final String pageType;

  MiscBLMDropDownTemplateState({required this.postId, required this.likePost, required this.likesCount, required this.reportType, required this.pageType});

  // BranchUniversalObject? buo;
  // BranchLinkProperties? lp;
  GlobalKey qrKey = new GlobalKey();

  void initBranchShare(){
    // buo = BranchUniversalObject(
    //   canonicalIdentifier: 'FacesbyPlaces',
    //   title: 'FacesbyPlaces Link',
    //   imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
    //   contentDescription: 'FacesbyPlaces link to the app',
    //   keywords: ['FacesbyPlaces', 'Share', 'Link'],
    //   publiclyIndex: true,
    //   locallyIndex: true,
    //   contentMetadata: BranchContentMetaData()
    //     ..addCustomMetadata('link-category', 'Post')
    //     ..addCustomMetadata('link-post-id', postId)
    //     ..addCustomMetadata('link-like-status', likePost)
    //     ..addCustomMetadata('link-number-of-likes', likesCount)
    //     ..addCustomMetadata('link-type-of-account', 'Blm')
    // );

    // lp = BranchLinkProperties(
    //     feature: 'sharing',
    //     stage: 'new share',
    //   tags: ['one', 'two', 'three']
    // );
    // lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<void> shareQRCode() async {
    try {
      // RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();
      // var image = await boundary.toImage();
      // ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      // Uint8List pngBytes = byteData.buffer.asUint8List();

      // final tempDir = await getTemporaryDirectory();
      // final file = await new File('${tempDir.path}/qr-image.png').create();
      // await file.writeAsBytes(pngBytes);

      // print(pngBytes);

      // Share.shareFiles(['${tempDir.path}/qr-image.png'], text: 'Scan this QR Code to check the post from FacesbyPlaces');

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
            icon: Center(child: Icon(Icons.more_vert, color: Color(0xffaaaaaa)),),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Color(0xff888888)
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
                // initBranchShare();

                // FlutterBranchSdk.setIdentity('blm-share-link');

                // BranchResponse response = await FlutterBranchSdk.showShareSheet(
                //   buo: buo!,
                //   linkProperties: lp!,
                //   messageText: 'FacesbyPlaces App',
                //   androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                //   androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                // );

                // if (response.success) {
                //   print('Link generated: ${response.result}');
                // } else {
                //   FlutterBranchSdk.logout();
                //   print('Error : ${response.errorCode} - ${response.errorMessage}');
                // }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: postId, reportType: reportType,)));
              }else if(dropDownList == 'QR Code'){
                // String qrData = 'Post-$postId-${likePost == true ? 1 : 0}-$likesCount-$pageType'; // 'link-category' - 'post-id' - 'fase/true = 0/1' - 'number-of-likes' - 'account-type'

                // FullScreenMenu.show(
                //   context,
                //   backgroundColor: Color(0xffffffff),
                //   items: [
                //     Center(
                //       child: Container(
                //         height: SizeConfig.screenHeight - 400,
                //         child: RepaintBoundary(
                //           key: qrKey,
                //           child: QrImage(
                //             data: qrData,
                //             version: QrVersions.auto,
                //             size: 320,
                //             gapless: false,
                //           ),
                //         ),
                //       ),
                //     ),

                //     Column(
                //       children: [
                //         Text('FacesbyPlaces Post',
                //           style: TextStyle(
                //             fontSize: 20, 
                //             fontWeight: FontWeight.bold, 
                //             color: Color(0xff000000),
                //           ), 
                //         ),

                //         Text('QR Code',
                //           style: TextStyle(
                //             fontSize: 20, 
                //             fontWeight: FontWeight.bold, 
                //             color: Color(0xff000000),
                //           ), 
                //         ),

                //       ],
                //     ),

                //     MiscBLMButtonTemplate(
                //       buttonText: 'Share',
                //       buttonTextStyle: TextStyle(
                //         fontSize: 16, 
                //         fontWeight: FontWeight.bold, 
                //         color: Color(0xffffffff),
                //       ),
                //       width: SizeConfig.screenWidth / 2,
                //       height: 45,
                //       buttonColor: Color(0xff04ECFF), 
                //       onPressed: () async{
                //         await shareQRCode();
                //       },
                //     ),
                //   ],
                // );
              }else{
                // initBranchShare();
                // FlutterBranchSdk.setIdentity('blm-share-copied-link');

                // BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
                // if (response.success) {
                //   print('Link generated: ${response.result}');
                // } else {
                //   FlutterBranchSdk.logout();
                //   print('Error : ${response.errorCode} - ${response.errorMessage}');
                // }


                // // FlutterClipboard.copy(response.result).then((value) => Scaffold.of(context).showSnackBar(snackBar));
                // FlutterClipboard.copy(response.result).then((value) => ScaffoldMessenger(child: Text('Link copied!'),));

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

  MiscBLMDropDownMemorialTemplate({required this.memorialName, required this.memorialId, required this.pageType, required this.reportType});

  MiscBLMDropDownMemorialTemplateState createState() => MiscBLMDropDownMemorialTemplateState(memorialName: memorialName, memorialId: memorialId, pageType: pageType, reportType: reportType);
}

class MiscBLMDropDownMemorialTemplateState extends State<MiscBLMDropDownMemorialTemplate>{
  final String memorialName;
  final int memorialId;
  final String pageType;
  final String reportType;

  MiscBLMDropDownMemorialTemplateState({required this.memorialName, required this.memorialId, required this.pageType, required this.reportType});

  final snackBar = SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating,);

  // BranchUniversalObject? buo;
  // BranchLinkProperties? lp;
  GlobalKey qrKey = new GlobalKey();

  void initBranchShare(){
    // buo = BranchUniversalObject(
    //   canonicalIdentifier: 'FacesbyPlaces',
    //   title: 'FacesbyPlaces Link',
    //   imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
    //   contentDescription: 'FacesbyPlaces link to the app',
    //   keywords: ['FacesbyPlaces', 'Share', 'Link'],
    //   publiclyIndex: true,
    //   locallyIndex: true,
    //   contentMetadata: BranchContentMetaData()
    //     ..addCustomMetadata('link-category', 'Memorial')
    //     ..addCustomMetadata('link-memorial-id', memorialId)
    //     ..addCustomMetadata('link-type-of-account', pageType)
    // );

    // lp = BranchLinkProperties(
    //     feature: 'sharing',
    //     stage: 'new share',
    //   tags: ['one', 'two', 'three']
    // );
    // lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<void> shareQRCode() async {
    try {
      // RenderRepaintBoundary boundary = qrKey.currentContext.findRenderObject();
      // var image = await boundary.toImage();
      // ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      // Uint8List pngBytes = byteData.buffer.asUint8List();

      // final tempDir = await getTemporaryDirectory();
      // final file = await new File('${tempDir.path}/qr-image.png').create();
      // await file.writeAsBytes(pngBytes);

      // print(pngBytes);

      // Share.shareFiles(['${tempDir.path}/qr-image.png'], text: 'Scan this QR Code to check the memorial of $memorialName');

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
            icon: Center(child: Icon(Icons.more_vert, color: Color(0xffaaaaaa)),),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Color(0xff888888)
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
                // initBranchShare();

                // FlutterBranchSdk.setIdentity('blm-share-link');

                // BranchResponse response = await FlutterBranchSdk.showShareSheet(
                //   buo: buo!,
                //   linkProperties: lp!,
                //   messageText: 'FacesbyPlaces App',
                //   androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                //   androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                // );
                // if (response.success) {
                //   print('Link generated: ${response.result}');
                // } else {
                //   FlutterBranchSdk.logout();
                //   print('Error : ${response.errorCode} - ${response.errorMessage}');
                // }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: memorialId, reportType: reportType,)));
              }else if(dropDownList == 'QR Code'){
                // String qrData = 'Memorial-$memorialId-$pageType'; // 'link-category' - 'link-type-of-account' - 'link-type-of-account'

                // FullScreenMenu.show(
                //   context,
                //   backgroundColor: Color(0xffffffff),
                //   items: [
                //     Center(
                //       child: Container(
                //         height: SizeConfig.screenHeight - 400,
                //         child: RepaintBoundary(
                //           key: qrKey,
                //           child: QrImage(
                //             data: qrData,
                //             version: QrVersions.auto,
                //             size: 320,
                //             gapless: false,
                //           ),
                //         ),
                //       ),
                //     ),

                //     Column(
                //       children: [
                //         Text('$memorialName',
                //           style: TextStyle(
                //             fontSize: 20, 
                //             fontWeight: FontWeight.bold, 
                //             color: Color(0xff000000),
                //           ), 
                //         ),

                //         Text('QR Code',
                //           style: TextStyle(
                //             fontSize: 20, 
                //             fontWeight: FontWeight.bold, 
                //             color: Color(0xff000000),
                //           ), 
                //         ),

                //       ],
                //     ),

                //     MiscBLMButtonTemplate(
                //       buttonText: 'Share',
                //       buttonTextStyle: TextStyle(
                //         fontSize: 16, 
                //         fontWeight: FontWeight.bold, 
                //         color: Color(0xffffffff),
                //       ),
                //       width: SizeConfig.screenWidth / 2,
                //       height: 45,
                //       buttonColor: Color(0xff04ECFF),
                //       onPressed: () async{
                //         await shareQRCode();
                //       },
                //     ),
                //   ],
                // );
              }else{
                // initBranchShare();
                // FlutterBranchSdk.setIdentity('blm-share-copied-link');

                // BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
                // if (response.success) {
                //   print('Link generated: ${response.result}');
                // } else {
                //   FlutterBranchSdk.logout();
                //   print('Error : ${response.errorCode} - ${response.errorMessage}');
                // }

                // FlutterClipboard.copy(response.result).then((value) => ScaffoldMessenger(child: Text('Link copied!'),));
              }
            },
          );
        },
      ),  
    );
  }
}