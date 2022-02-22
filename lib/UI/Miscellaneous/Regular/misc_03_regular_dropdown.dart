import 'package:facesbyplaces/API/Regular/15-Delete-Post/api_delete_post_regular_01_delete_post.dart';
import 'package:facesbyplaces/UI/Home/Regular/01-Main/home_main_regular_02_home_extended.dart';
import 'package:facesbyplaces/UI/Home/Regular/06-Report/home_report_regular_01_report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc_03_bloc_regular_misc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:share/share.dart';
import 'package:misc/misc.dart';
import 'dart:typed_data';
import 'dart:io';

class MiscRegularDropDownTemplate extends StatefulWidget{
  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;
  final String pageType;
  final String pageName;
  final bool deletable;
  const MiscRegularDropDownTemplate({Key? key, required this.postId, required this.likePost, required this.likesCount, required this.reportType, required this.pageType, required this.pageName, required this.deletable}) : super(key: key);

  @override
  MiscRegularDropDownTemplateState createState() => MiscRegularDropDownTemplateState();
}

class MiscRegularDropDownTemplateState extends State<MiscRegularDropDownTemplate>{
  GlobalKey qrKey = GlobalKey();
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
        ..addCustomMetadata('link-type-of-account', 'Memorial'),
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
        final file = await File('${tempDir.path}/alm-qr-code.png').create();
        file.writeAsBytesSync(list);

        Share.shareFiles([file.path], text: 'QR Code');
      }else{
        await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Invalid QR Code.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
          ),
        );
      }
    }catch (e){
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscRegularDropDown(),
      child: BlocBuilder<BlocMiscRegularDropDown, String>(
        builder: (context, dropDownList){
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: const Center(child: Icon(Icons.more_vert, color: Color(0xffaaaaaa)),),
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Color(0xff888888)),
            items: widget.deletable
            ? const <String>['Copy Link', 'Share', 'QR Code', 'Report', 'Delete Post'].map((String value){
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList()
            : const <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value){
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (String? listValue) async{
              dropDownList = listValue!;
              if(dropDownList == 'Share'){
                initBranchShare();
                FlutterBranchSdk.setIdentity('alm-share-link');

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
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Success',
                      description: 'Successfully shared the link.',
                      okButtonColor: const Color(0xff4caf50), // GREEN
                      includeOkButton: true,
                    ),
                  );
                }else{
                  FlutterBranchSdk.logout();
                  throw Exception('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: widget.reportType,)));
              }else if(dropDownList == 'QR Code'){
                // String qrData = 'Post-${widget.postId}-${widget.likePost == true ? 1 : 0}-${widget.likesCount}-${widget.pageType == 'Blm' ? 'Blm' : 'Alm'}'; // 'link-category' - 'post-id' - 'fase/true = 0/1' - 'number-of-likes' - 'account-type'
                String qrData = 'www.facesbyplaces.com/?q=Post-${widget.postId}-${widget.likePost == true ? 1 : 0}-${widget.likesCount}-${widget.pageType == 'Blm' ? 'Blm' : 'Alm'}'; // 'link-category' - 'post-id' - 'fase/true = 0/1' - 'number-of-likes' - 'account-type'

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
                              padding: const EdgeInsets.only(right: 20.0),
                              alignment: Alignment.centerRight,
                              height: 50,
                              child: GestureDetector(
                                child: const Icon(Icons.close_rounded, color: Color(0xffffffff), size: 30,),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),

                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 10, right: SizeConfig.blockSizeHorizontal! * 10, top: SizeConfig.blockSizeHorizontal! * 20, bottom: SizeConfig.blockSizeHorizontal! * 25),
                                height: SizeConfig.screenHeight! - 400,
                                color: Colors.black26,
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

                                        Text(widget.pageName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),

                                        const Text('QR Code', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),

                                        const Spacer(),

                                        MiscButtonTemplate(
                                          buttonText: 'Share',
                                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                                          width: SizeConfig.screenWidth! / 2,
                                          buttonColor: const Color(0xff04ECFF),
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
              }else if(dropDownList == 'Copy Link'){
                initBranchShare();
                FlutterBranchSdk.setIdentity('alm-share-copied-link');

                BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
                if(response.success){
                  await showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Success',
                      description: 'Successfully copied the link.',
                      okButtonColor: const Color(0xff4caf50), // GREEN
                      includeOkButton: true,
                    ),
                  );
                }else{
                  FlutterBranchSdk.logout();
                  throw Exception('Error : ${response.errorCode} - ${response.errorMessage}');
                }

                FlutterClipboard.copy(response.result).then((value) => const ScaffoldMessenger(child: Text('Link copied!'),));
              }else{
                bool confirmation = await showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: 'Confirm',
                    description: 'Are you sure you want to delete this post?',
                    includeOkButton: true,
                    includeCancelButton: true,
                  ),
                );

                if(confirmation){
                  context.loaderOverlay.show();
                  bool result = await apiRegularDeletePost(postId: widget.postId);
                  context.loaderOverlay.hide();

                  if(result){
                    Route newRoute = MaterialPageRoute(builder: (context) => const HomeRegularScreenExtended(newToggleBottom: 1,),);
                    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
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
  const MiscRegularDropDownMemorialTemplate({Key? key, required this.memorialName, required this.memorialId, required this.pageType, required this.reportType}) : super(key: key);

  @override
  MiscRegularDropDownMemorialTemplateState createState() => MiscRegularDropDownMemorialTemplateState();
}

class MiscRegularDropDownMemorialTemplateState extends State<MiscRegularDropDownMemorialTemplate>{
  final snackBar = const SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating,);
  GlobalKey qrKey = GlobalKey();
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;
  File? shareImage;

  void initBranchShare(){
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
      ..addCustomMetadata('link-type-of-account', widget.pageType),
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
        final file = await File('${tempDir.path}/qr-code.png').create();
        file.writeAsBytesSync(list);

        Share.shareFiles([file.path], text: 'QR Code');
      }else{
        await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Invalid QR Code.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
          ),
        );
      }
    }catch (e){
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscRegularDropDown(),
      child: BlocBuilder<BlocMiscRegularDropDown, String>(
        builder: (context, dropDownList) {
          return DropdownButton<String>(
            underline: Container(height: 0),
            icon: const Center(child: Icon(Icons.more_vert, color: Color(0xffffffff)),),
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Color(0xff888888)),
            items: const <String>['Copy Link', 'Share', 'QR Code', 'Report'].map((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (String? listValue) async{
              dropDownList = listValue!;
              if(dropDownList == 'Share'){
                initBranchShare();
                FlutterBranchSdk.setIdentity('alm-share-link');

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
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Success',
                      description: 'Successfully copied the link.',
                      okButtonColor: const Color(0xff4caf50), // GREEN
                      includeOkButton: true,
                    ),
                  );
                }else{
                  FlutterBranchSdk.logout();
                  throw Exception('Error : ${response.errorCode} - ${response.errorMessage}');
                }
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.memorialId, reportType: widget.reportType,)));
              }else if(dropDownList == 'QR Code'){
                // String qrData = 'Memorial-${widget.memorialId}-${widget.pageType == 'Blm' ? 'Blm' : 'Alm'}'; // 'link-category' - 'link-type-of-account' - 'link-type-of-account'
                String qrData = 'www.facesbyplaces.com/?q=Memorial-${widget.memorialId}-${widget.pageType == 'Blm' ? 'Blm' : 'Alm'}'; // 'link-category' - 'link-type-of-account' - 'link-type-of-account'

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
                                child: const Icon(Icons.close_rounded, color: Color(0xffffffff), size: 30,),
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

                                        Text(widget.memorialName, textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),

                                        Text('QR Code', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),

                                        const Spacer(),

                                        MiscButtonTemplate(
                                          buttonText: 'Share',
                                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
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
                FlutterBranchSdk.setIdentity('alm-share-copied-link');

                BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp!);
                if(response.success){
                  await showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Success',
                      description: 'Successfully copied the link.',
                      okButtonColor: const Color(0xff4caf50), // GREEN
                      includeOkButton: true,
                    ),
                  );
                }else{
                  FlutterBranchSdk.logout();
                  throw Exception('Error : ${response.errorCode} - ${response.errorMessage}');
                }

                FlutterClipboard.copy(response.result).then((value) => const ScaffoldMessenger(child: Text('Link copied!')));
              }
            },
          );
        },
      ),
    );
  }
}