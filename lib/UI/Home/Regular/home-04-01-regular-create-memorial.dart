import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegularCreateMemorialValues{
  String blmName;
  String description;
  String birthplace;
  String dob;
  String rip;
  String cemetery;
  String country;
  String relationship;
  List<File> imagesOrVideos;
  double longitude;
  double latitude;

  RegularCreateMemorialValues({
    this.blmName, 
    this.description, 
    this.birthplace, 
    this.dob, 
    this.rip, 
    this.cemetery, 
    this.country,  
    this.relationship, 
    this.imagesOrVideos, 
    this.latitude, 
    this.longitude,
  });
}


class HomeRegularCreateMemorial1 extends StatefulWidget{

  HomeRegularCreateMemorial1State createState() => HomeRegularCreateMemorial1State();
}

class HomeRegularCreateMemorial1State extends State<HomeRegularCreateMemorial1>{

  GlobalKey<MiscRegularInputFieldDropDownState> _key1 = GlobalKey<MiscRegularInputFieldDropDownState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key3 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key4 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
        centerTitle: true,
        backgroundColor: Color(0xff04ECFF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [

          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                MiscRegularInputFieldDropDown(key: _key1,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldDateTimeTemplate(key: _key3, labelText: 'DOB'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldDateTimeTemplate(key: _key4, labelText: 'RIP'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldTemplate(key: _key5, labelText: 'Cemetery'),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscRegularInputFieldTemplate(key: _key6, labelText: 'Country'),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                MiscRegularButtonTemplate(
                  onPressed: () async{

                    if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
                    _key5.currentState.controller.text == '' || _key6.currentState.controller.text == ''){
                      await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                    }else{
                      Navigator.pushNamed(context, '/home/regular/home-04-02-regular-create-memorial', 
                        arguments: RegularCreateMemorialValues(
                          relationship: _key1.currentState.currentSelection,
                          birthplace: _key2.currentState.controller.text,
                          dob: _key4.currentState.controller.text,
                          rip: _key5.currentState.controller.text,
                          cemetery: _key5.currentState.controller.text,
                          country: _key6.currentState.controller.text,
                        ),
                      );
                    }

                  }, 
                  width: SizeConfig.screenWidth, 
                  height: SizeConfig.blockSizeVertical * 7
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
