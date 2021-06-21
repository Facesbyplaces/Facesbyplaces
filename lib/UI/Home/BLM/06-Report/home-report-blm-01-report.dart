import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/API/BLM/07-Report/api-report-blm-01-report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMReport extends StatelessWidget{
  final int postId;
  final String reportType;
  HomeBLMReport({required this.postId, required this.reportType});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscBLMInputFieldMultiTextTemplateState>();

  @override
  Widget build(BuildContext context){
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
            backgroundColor: const Color(0xff04ECFF),
            title: Row(
              children: [
                Text('Report', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
                
                Spacer(),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(20.0),
            height: SizeConfig.screenHeight,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Inform us about what happened.', style: TextStyle( fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xfF000000),),),
                  ),

                  const SizedBox(height: 25,),

                  MiscBLMInputFieldTemplate(
                    key: _key1,
                    labelText: 'Subject',
                    type: TextInputType.text,
                    labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xfFB1B1B1),),
                  ),

                  const SizedBox(height: 25,),

                  MiscBLMInputFieldMultiTextTemplate(
                    key: _key2,
                    labelText: 'Body',
                    labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xfFB1B1B1),),
                  ),

                  const SizedBox(height: 50,),

                  MiscBLMButtonTemplate(
                    buttonText: 'Report',
                    buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, color: const Color(0xffffffff), fontFamily: 'NexaBold'),
                    width: SizeConfig.screenWidth! / 2,
                    height: 45,
                    buttonColor: const Color(0xff04ECFF),
                    onPressed: () async{
                      if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error',textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                            onlyOkButton: true,
                            buttonOkColor: const Color(0xffff0000),
                            onOkButtonPressed: (){
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }else{
                        context.loaderOverlay.show();
                        bool result = await apiBLMReport(postId: postId, reportType: reportType, subject: _key1.currentState!.controller.text, body: _key2.currentState!.controller.text);
                        context.loaderOverlay.hide();

                        if(result){
                          await showDialog(
                            context: context,
                            builder: (_) => AssetGiffyDialog(image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Successfully submitted a report. Your report will be reviewed by the administrator.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                              onlyOkButton: true,
                              onOkButtonPressed: (){
                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                        }else{
                          await showDialog(
                            context: context,
                            builder: (_) => AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: (){
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 25,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}