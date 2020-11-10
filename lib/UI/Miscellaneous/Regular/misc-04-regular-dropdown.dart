import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-05-bloc-regular-misc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscRegularDropDownTemplate extends StatelessWidget{

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
                await FlutterShare.share(
                  title: 'Example share',
                  text: 'Example share text',
                  linkUrl: 'https://flutter.dev/',
                  chooserTitle: 'Example Chooser Title'
                );
              }else if(dropDownList == 'Report'){
                print('Report');
              }
            },
            // onChanged: (String val) async{
            //   setState(() {
            //     dropDown = val;
            //   });
            //   if(dropDown == 'Share'){
            //     await FlutterShare.share(
            //       title: 'Example share',
            //       text: 'Example share text',
            //       linkUrl: 'https://flutter.dev/',
            //       chooserTitle: 'Example Chooser Title'
            //     );
            //   }else if(dropDown == 'Report'){
            //     Navigator.pushNamed(context, '/home/home-17-report-user');
            //   }
            // },
            
          );
        },
      ),  
    );
  }
}
