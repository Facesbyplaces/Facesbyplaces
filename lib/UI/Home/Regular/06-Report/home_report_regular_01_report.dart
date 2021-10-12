import 'package:facesbyplaces/API/Regular/07-Report/api_report_regular_01_report.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeRegularReport extends StatelessWidget{
  final int postId;
  final String reportType;
  HomeRegularReport({Key? key, required this.postId, required this.reportType}) : super(key: key);

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscInputFieldMultiTextTemplateState>();

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
            centerTitle: false,
            title: const Text('Report', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Inform us about what happened.', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xfF000000),),),
                ),

                const SizedBox(height: 25,),

                MiscInputFieldTemplate(
                  key: _key1,
                  labelText: 'Subject',
                  type: TextInputType.text,
                  labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xfFB1B1B1),),
                ),

                const SizedBox(height: 25,),

                MiscInputFieldMultiTextTemplate(
                  key: _key2,
                  labelText: 'Body',
                  labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xfFB1B1B1),),
                ),

                const SizedBox(height: 50,),

                MiscButtonTemplate(
                  buttonTextStyle: const TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold',),
                  buttonColor: const Color(0xff04ECFF),
                  width: SizeConfig.screenWidth! / 2,
                  buttonText: 'Report',
                  height: 50,
                  onPressed: () async{
                    if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                      await showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: 'Error',
                          description: 'Please complete the form before submitting.',
                          okButtonColor: const Color(0xfff44336), // RED
                          includeOkButton: true,
                        ),
                      );
                    }else{
                      context.loaderOverlay.show();
                      bool result = await apiRegularReport(postId: postId, reportType: reportType, subject: _key1.currentState!.controller.text, body: _key2.currentState!.controller.text);
                      context.loaderOverlay.hide();

                      if(result){
                        await showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: 'Success',
                            description: 'Successfully submitted a report. Your report will be reviewed by the administrator.',
                            okButtonColor: const Color(0xff4caf50), // GREEN
                            includeOkButton: true,
                            okButton: (){
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }else{
                        await showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: 'Error',
                            description: 'Please complete the form before submitting.',
                            okButtonColor: const Color(0xfff44336), // RED
                            includeOkButton: true,
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
    );
  }
}