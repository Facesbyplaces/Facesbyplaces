import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class MiscBLMDropDownTemplate extends StatefulWidget{

  @override
  MiscBLMDropDownTemplateState createState() => MiscBLMDropDownTemplateState();
}

class MiscBLMDropDownTemplateState extends State<MiscBLMDropDownTemplate>{

  String dropDown = 'Copy Link';

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
      onChanged: (String val) async{
        setState(() {
          dropDown = val;
        });
        if(dropDown == 'Share'){
          await FlutterShare.share(
            title: 'Example share',
            text: 'Example share text',
            linkUrl: 'https://flutter.dev/',
            chooserTitle: 'Example Chooser Title'
          );
        }else if(dropDown == 'Report'){
          Navigator.pushNamed(context, '/home/home-17-report-user');
        }
      },
    );
  }
}
