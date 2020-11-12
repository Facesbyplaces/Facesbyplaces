import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularCreateMemorial extends StatelessWidget{

  final GlobalKey<MiscRegularInputFieldDropDownState> _key1 = GlobalKey<MiscRegularInputFieldDropDownState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key3 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key4 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();

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
            title: Text('Create a Memorial Page for friends and family.', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
            centerTitle: true,
            backgroundColor: Color(0xff04ECFF),
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.popUntil(context, ModalRoute.withName('/home/regular'));}),
          ),
          body: Stack(
            children: [

              SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  height: SizeConfig.screenHeight,
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    children: [

                      MiscRegularInputFieldDropDown(key: _key1,),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace'),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      MiscRegularInputFieldTemplate(key: _key3, labelText: 'DOB'),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      MiscRegularInputFieldTemplate(key: _key4, labelText: 'RIP'),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      MiscRegularInputFieldTemplate(key: _key5, labelText: 'Cemetery'),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      MiscRegularInputFieldTemplate(key: _key6, labelText: 'Country'),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Expanded(child: Container(),),

                      MiscRegularButtonTemplate(
                        onPressed: () async{

                          if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
                          _key5.currentState.controller.text == '' || _key6.currentState.controller.text == ''){
                            await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                          }else{
                            Navigator.pushNamed(context, '/home/regular/home-04-02-regular-create-memorial');
                          }

                        }, 
                        width: SizeConfig.screenWidth, 
                        height: SizeConfig.blockSizeVertical * 7
                      ),

                      Expanded(child: Container(),),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
