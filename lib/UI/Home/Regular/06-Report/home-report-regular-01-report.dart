import 'package:facesbyplaces/API/Regular/07-Report/api-report-regular-01-report.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeRegularReport extends StatelessWidget{
  final int postId;
  final String reportType;

  HomeRegularReport({this.postId, this.reportType});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscRegularInputFieldMultiTextTemplateState>();

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

                  MiscRegularInputFieldTemplate(key: _key1, labelText: 'Subject', type: TextInputType.text,),
                  
                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  MiscRegularInputFieldMultiTextTemplate(key: _key2, labelText: 'Body',),

                  Expanded(child: Container(),),

                  MiscRegularButtonTemplate(
                    buttonText: 'Report', 
                    buttonTextStyle: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xffffffff),
                    ),
                    onPressed: () async{

                      if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == ''){
                        await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                      }else{

                        context.showLoaderOverlay();
                        bool result = await apiRegularReport(postId: postId, reportType: reportType, subject: _key1.currentState.controller.text, body: _key2.currentState.controller.text);
                        context.hideLoaderOverlay();

                        if(result){
                          await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Success', content: 'Successfully submitted a report. Your report will be reviewed by the administrator.', color: Colors.green,));
                          Navigator.pushReplacementNamed(context, '/home/regular');
                        }else{
                          await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
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