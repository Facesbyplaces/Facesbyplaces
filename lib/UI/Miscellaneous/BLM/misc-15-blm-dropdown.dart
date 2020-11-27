import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-03-bloc-blm-misc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class BLMReportID{
  int userId;
  int postId;

  BLMReportID({this.userId, this.postId});
}

class MiscBLMDropDownTemplate extends StatelessWidget{

  final int userId;
  final int postId;

  MiscBLMDropDownTemplate({this.userId, this.postId});

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
                await FlutterShare.share(
                  title: 'Example share',
                  text: 'Example share text',
                  linkUrl: 'https://flutter.dev/',
                  chooserTitle: 'Example Chooser Title'
                );
              }else if(dropDownList == 'Report'){
                Navigator.pushNamed(context, '/home/blm/home-24-blm-report', arguments: BLMReportID(userId: userId, postId: postId));
              }
            },
            
          );
        },
      ),  
    );
  }
}
