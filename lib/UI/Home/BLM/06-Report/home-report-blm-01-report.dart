import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/API/BLM/07-Report/api-report-blm-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMReport extends StatelessWidget{
  final int postId;
  final String reportType;

  HomeBLMReport({required this.postId, required this.reportType});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscBLMInputFieldMultiTextTemplateState>();

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
          body: Container(
            padding: EdgeInsets.all(20.0),
            height: SizeConfig.screenHeight,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [

                  Align(alignment: Alignment.centerLeft, child: Text('Inform us about what happened.', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),

                  SizedBox(height: 25,),

                  MiscBLMInputFieldTemplate(key: _key1, labelText: 'Subject', type: TextInputType.text,),
                  
                  SizedBox(height: 25,),

                  MiscBLMInputFieldMultiTextTemplate(key: _key2, labelText: 'Body',),

                  SizedBox(height: 50,),

                  MiscBLMButtonTemplate(
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

                        context.showLoaderOverlay();
                        bool result = await apiBLMReport(postId: postId, reportType: reportType, subject: _key1.currentState!.controller.text, body: _key2.currentState!.controller.text);
                        context.hideLoaderOverlay();

                        if(result){
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Successfully submitted a report. Your report will be reviewed by the administrator.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: Colors.green,
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
                          );
                          Navigator.pushReplacementNamed(context, '/home/blm');
                        }else{
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Something went wrong. Please try again.',
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
      ),
    );
  }
}