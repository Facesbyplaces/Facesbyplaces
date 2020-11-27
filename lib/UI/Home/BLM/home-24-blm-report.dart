// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-dropdown.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-19-blm-report.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-15-blm-dropdown.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeBLMReport extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscBLMInputFieldMultiTextTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final BLMReportID newValue = ModalRoute.of(context).settings.arguments;
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
            title: Text('Report', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {Navigator.pop(context);},
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(20.0),
              height: SizeConfig.screenHeight,
              child: Column(
                children: [

                  Align(alignment: Alignment.centerLeft, child: Text('Inform us about what happened.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  MiscBLMInputFieldTemplate(key: _key1, labelText: 'Subject', type: TextInputType.text,),
                  
                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  MiscBLMInputFieldMultiTextTemplate(key: _key2, labelText: 'Body',),

                  Expanded(child: Container(),),

                  MiscBLMButtonTemplate(
                    buttonText: 'Report', 
                    buttonTextStyle: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xffffffff),
                    ),
                    onPressed: () async{

                      if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == ''){
                        await showDialog(context: context, builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                      }else{

                        context.showLoaderOverlay();
                        bool result = await apiBLMReport(newValue.userId, newValue.postId ,_key1.currentState.controller.text, _key2.currentState.controller.text);
                        context.hideLoaderOverlay();

                        print('The report result is $result');

                        if(result){
                          Navigator.pushReplacementNamed(context, '/home/blm');
                        }else{
                          await showDialog(context: context, builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                        }
                      }

                    }, 
                    width: SizeConfig.screenWidth / 2, 
                    height: SizeConfig.blockSizeVertical * 7, 
                    buttonColor: Color(0xff04ECFF),
                  ),

                  Expanded(child: Container(),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}