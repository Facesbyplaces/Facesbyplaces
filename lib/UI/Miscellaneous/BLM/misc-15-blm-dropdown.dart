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

  MiscBLMDropDownTemplateState createState() => MiscBLMDropDownTemplateState();
}

class MiscBLMDropDownTemplateState extends State<MiscBLMDropDownTemplate>{

  // final int postId;
  // final String reportType;

  // MiscBLMDropDownTemplate({this.postId, this.reportType});

  final int postId;
  final bool likePost;
  final int likesCount;
  final String reportType;

  MiscBLMDropDownTemplateState({this.postId, this.likePost, this.likesCount, this.reportType});

  final snackBar = SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2),);

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
                // await FlutterShare.share(
                //   title: 'Share',
                //   text: 'Share the link',
                //   linkUrl: 'https://flutter.dev/',
                //   chooserTitle: 'Share link'
                // );
              }else if(dropDownList == 'Report'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: postId, reportType: reportType,)));
              }else{
                // https://29cft.test-app.link/suCwfzCi6bb
                FlutterClipboard.copy('https://29cft.test-app.link/suCwfzCi6bb').then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));
              }
            },
            
          );
        },
      ),  
    );
  }
}
