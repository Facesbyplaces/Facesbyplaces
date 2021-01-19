import 'package:clipboard/clipboard.dart';
import 'package:facesbyplaces/UI/Home/BLM/06-Report/home-report-blm-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-03-bloc-blm-misc.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

// class MiscBLMDropDownTemplate extends StatelessWidget{
class MiscBLMDropDownTemplate extends StatefulWidget{
  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;

  MiscBLMDropDownTemplate({this.postId, this.likePost, this.likesCount, this.reportType});

  MiscBLMDropDownTemplateState createState() => MiscBLMDropDownTemplateState(postId: postId, likePost: likePost, likesCount: likesCount, reportType: reportType);
}

class MiscBLMDropDownTemplateState extends State<MiscBLMDropDownTemplate>{

  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;

  MiscBLMDropDownTemplateState({this.postId, this.likePost, this.likesCount, this.reportType});

  final snackBar = SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2),);

  BranchUniversalObject buo;
  BranchLinkProperties lp;

  void initBranchShare(){
    print('The post id for initBranchShare is $postId');

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
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
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
              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
              color: Color(0xff888888)
            ),
            items: <String>['Copy Link', 'Share', 'Report'].map((String value){
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

                FlutterBranchSdk.setIdentity('blm-share-link');

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: postId, reportType: reportType,)));
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

                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                FlutterClipboard.copy(response.result).then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));
              }
            },
            
          );
        },
      ),  
    );
  }
}
