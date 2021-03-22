import 'package:facesbyplaces/API/Regular/07-Report/api-report-regular-01-report.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeRegularReport extends StatelessWidget{
  final int postId;
  final String reportType;

  HomeRegularReport({required this.postId, required this.reportType});

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
            title: Text('Report', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [

                Align(alignment: Alignment.centerLeft, child: Text('Inform us about what happened.', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),

                SizedBox(height: 25,),

                MiscRegularInputFieldTemplate(key: _key1, labelText: 'Subject', type: TextInputType.text,),
                
                SizedBox(height: 25,),

                MiscRegularInputFieldMultiTextTemplate(key: _key2, labelText: 'Body',),

                SizedBox(height: 50,),

                MiscRegularButtonTemplate(
                  buttonText: 'Report', 
                  buttonTextStyle: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xffffffff),
                  ),
                  width: SizeConfig.screenWidth! / 2, 
                  height: 45, 
                  buttonColor: Color(0xff04ECFF), 
                  onPressed: () async{

                    if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                      await showOkAlertDialog(
                        context: context,
                        title: 'Error',
                        message: 'Please complete the form before submitting.',
                      );
                    }else{

                      context.showLoaderOverlay();
                      bool result = await apiRegularReport(postId: postId, reportType: reportType, subject: _key1.currentState!.controller.text, body: _key2.currentState!.controller.text);
                      context.hideLoaderOverlay();

                      if(result){
                        await showOkAlertDialog(
                          context: context,
                          title: 'Success',
                          message: 'Successfully submitted a report. Your report will be reviewed by the administrator.',
                        );
                        Navigator.pushReplacementNamed(context, '/home/regular');
                      }else{
                        await showOkAlertDialog(
                          context: context,
                          title: 'Error',
                          message: 'Something went wrong. Please try again.',
                        );
                      }
                    }
                  }, 
                ),

                SizedBox(height: 25,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}