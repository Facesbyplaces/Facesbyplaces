import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMCreateMemorialValues{
  String blmName;
  String description;
  String location;
  String dob;
  String rip;
  String state;
  String country;
  String precinct;
  String relationship;
  List<File> imagesOrVideos;
  double longitude;
  double latitude;

  BLMCreateMemorialValues({
    this.blmName, 
    this.description, 
    this.location, 
    this.dob, 
    this.rip, 
    this.state, 
    this.country, 
    this.precinct, 
    this.relationship, 
    this.imagesOrVideos, 
    this.latitude, 
    this.longitude,
  });
}


class HomeBLMCreateMemorial1 extends StatefulWidget{

  HomeBLMCreateMemorial1State createState() => HomeBLMCreateMemorial1State();
}

class HomeBLMCreateMemorial1State extends State<HomeBLMCreateMemorial1>{

  final GlobalKey<MiscBLMInputFieldDropDownState> _key1 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key4 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key5 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
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
            child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                MiscBLMInputFieldDropDown(key: _key1,),

                SizedBox(height: 20,),

                MiscBLMInputFieldTemplate(key: _key2, labelText: 'Location of the incident'),

                SizedBox(height: 20,),

                MiscBLMInputFieldTemplate(key: _key3, labelText: 'Precinct / Station House (Optional)'),

                SizedBox(height: 20,),

                MiscBLMInputFieldDateTimeTemplate(key: _key4, labelText: 'DOB'),

                SizedBox(height: 20,),

                MiscBLMInputFieldDateTimeTemplate(key: _key5, labelText: 'RIP'),

                SizedBox(height: 20,),

                MiscBLMInputFieldTemplate(key: _key6, labelText: 'Country'),

                SizedBox(height: 20,),

                MiscBLMInputFieldTemplate(key: _key7, labelText: 'State'),

                SizedBox(height: 40,),

                MiscBLMButtonTemplate(
                  onPressed: () async{

                    if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || _key5.currentState.controller.text == '' || _key6.currentState.controller.text == '' || _key7.currentState.controller.text == ''){
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Please complete the form before submitting.',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          onlyOkButton: true,
                          buttonOkColor: Colors.red,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );
                    }else{
                      Navigator.pushNamed(
                        context, '/home/blm/create-memorial-2',
                        arguments: BLMCreateMemorialValues(
                          relationship: _key1.currentState.currentSelection,
                          location: _key2.currentState.controller.text,
                          precinct: _key3.currentState.controller.text,
                          dob: _key4.currentState.controller.text,
                          rip: _key5.currentState.controller.text,
                          country: _key6.currentState.controller.text,
                          state: _key7.currentState.controller.text,
                        ),
                      );
                    }

                  }, 
                  width: SizeConfig.screenWidth / 2,
                  height: 45,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

}
