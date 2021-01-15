// import 'package:clipboard/clipboard.dart';
import 'package:clipboard/clipboard.dart';
import 'package:facesbyplaces/UI/Home/Regular/06-Report/home-report-regular-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-05-bloc-regular-misc.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscRegularDropDownTemplate extends StatelessWidget{

  final int postId;
  final String reportType;

  MiscRegularDropDownTemplate({this.postId, this.reportType});

  final snackBar = SnackBar(content: Text('Link copied!'), backgroundColor: Color(0xff4EC9D4), duration: Duration(seconds: 2),);

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: postId, reportType: reportType,)));
              }else{
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                FlutterClipboard.copy('https://29cft.test-app.link/suCwfzCi6bb').then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));
              }
            },
          );
        },
      ),  
    );
  }
}
