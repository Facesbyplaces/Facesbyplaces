import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeBLMCreateMemorial extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff04ECFF),
            title: Text('Cry out for the Victims', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/home/blm'),);
              }
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

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key2, labelText: 'Location of the incident'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key3, labelText: 'Precinct / Station House (Optional)'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key4, labelText: 'DOB'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key5, labelText: 'RIP'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key6, labelText: 'Country'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key7, labelText: 'State'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                    MiscBLMButtonTemplate(
                      onPressed: () async{

                        if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
                        _key5.currentState.controller.text == '' || _key6.currentState.controller.text == '' || _key7.currentState.controller.text == ''){
                          await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                        }else{
                          Navigator.pushNamed(context, '/home/blm/home-07-02-blm-create-memorial');
                        }

                      }, 
                      width: SizeConfig.screenWidth / 2, 
                      height: SizeConfig.blockSizeVertical * 7
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
