import 'package:facesbyplaces/API/Regular/07-Report/api-report-regular-01-report.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
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
            backgroundColor: const Color(0xff04ECFF),
            title: const Text('Report', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [

                const Align(alignment: Alignment.centerLeft, child: const Text('Inform us about what happened.', style: const TextStyle(fontSize: 16, color: Color(0xff000000),),),),

                const SizedBox(height: 25,),

                MiscRegularInputFieldTemplate(key: _key1, labelText: 'Subject', type: TextInputType.text,),
                
                const SizedBox(height: 25,),

                MiscRegularInputFieldMultiTextTemplate(key: _key2, labelText: 'Body',),

                const SizedBox(height: 50,),

                MiscRegularButtonTemplate(
                  buttonText: 'Report', 
                  buttonTextStyle: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xffffffff),
                  ),
                  width: SizeConfig.screenWidth! / 2, 
                  height: 45, 
                  buttonColor: const Color(0xff04ECFF), 
                  onPressed: () async{

                    if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: const Text('Please complete the form before submitting.',
                            textAlign: TextAlign.center,
                          ),
                          onlyOkButton: true,
                          buttonOkColor: const Color(0xffff0000),
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );
                    }else{

                      context.loaderOverlay.show();
                      bool result = await apiRegularReport(postId: postId, reportType: reportType, subject: _key1.currentState!.controller.text, body: _key2.currentState!.controller.text);
                      context.loaderOverlay.hide();

                      if(result){
                        await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: const Text('Successfully submitted a report. Your report will be reviewed by the administrator.',
                              textAlign: TextAlign.center,
                            ),
                            onlyOkButton: true,
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            },
                          )
                        );
                      }else{
                        await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: const Text('Something went wrong. Please try again.',
                              textAlign: TextAlign.center,
                            ),
                            onlyOkButton: true,
                            buttonOkColor: const Color(0xffff0000),
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                          )
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
    );
  }
}