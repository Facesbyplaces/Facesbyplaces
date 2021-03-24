import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-02-show-other-details.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-06-update-other-details.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-07-hide-birthdate.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-08-hide-birthplace.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-09-hide-address.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-10-hide-email.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-11-hide-phone-number.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'home-settings-user-blm-01-user-details.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeBLMUserOtherDetails extends StatefulWidget{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;

  HomeBLMUserOtherDetails({required this.userId, required this.toggleBirthdate, required this.toggleBirthplace, required this.toggleAddress, required this.toggleEmail, required this.toggleNumber});

  HomeBLMUserOtherDetailsState createState() => HomeBLMUserOtherDetailsState(userId: userId, toggleBirthdate: toggleBirthdate, toggleBirthplace: toggleBirthplace, toggleAddress: toggleAddress, toggleEmail: toggleEmail, toggleNumber: toggleNumber);
}

class HomeBLMUserOtherDetailsState extends State<HomeBLMUserOtherDetails>{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;
  HomeBLMUserOtherDetailsState({required this.userId, required this.toggleBirthdate, required this.toggleBirthplace, required this.toggleAddress, required this.toggleEmail, required this.toggleNumber});

  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key1 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberPickerTemplateState> _key5 = GlobalKey<MiscBLMPhoneNumberPickerTemplateState>();

  Future<APIBLMShowOtherDetails>? otherDetails;
  bool toggle1 = false;
  bool toggle2 = false;
  bool toggle3 = false;
  bool toggle4 = false;
  bool toggle5 = false;

  void initState(){
    super.initState();
    otherDetails = getOtherDetails(userId);
    toggle1 = toggleBirthdate;
    toggle2 = toggleBirthplace;
    toggle3 = toggleAddress;
    toggle4 = toggleEmail;
    toggle5 = toggleNumber;
  }

  Future<APIBLMShowOtherDetails> getOtherDetails(int userId) async{
    return await apiBLMShowOtherDetails(userId: userId);
  }

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
            title: Text('Other Details', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: FutureBuilder<APIBLMShowOtherDetails>(
            future: otherDetails,
            builder: (context, details){
              if(details.hasData){
                return SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          Expanded(child: MiscBLMInputFieldDateTimeTemplate(key: _key1, labelText: 'Birthdate', displayText: details.data!.blmShowOtherDetailsBirthdate,),),

                          SizedBox(width: 20,),

                          IconButton(
                            onPressed: () async{
                              setState(() {
                                toggle1 = !toggle1;
                              });

                              context.showLoaderOverlay();
                              await apiBLMHideBirthdate(hide: toggle1);
                              context.hideLoaderOverlay();
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                            color: toggle1 ? Color(0xff85DBF1) : Color(0xff888888),
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(child: MiscBLMInputFieldTemplate(key: _key2, labelText: 'Birthplace', displayText: details.data!.blmShowOtherDetailsBirthplace,),),

                          SizedBox(width: 20,),

                          IconButton(
                            onPressed: () async{
                              setState(() {
                                toggle2 = !toggle2;
                              });

                              context.showLoaderOverlay();
                              await apiBLMHideBirthplace(hide: toggle2);
                              context.hideLoaderOverlay();
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                            color: toggle2 ? Color(0xff85DBF1) : Color(0xff888888),
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(child: MiscBLMInputFieldTemplate(key: _key3, labelText: 'Home Address', displayText: details.data!.blmShowOtherDetailsAddress,),),

                          SizedBox(width: 20,),

                          IconButton(
                            onPressed: () async{
                              setState(() {
                                toggle3 = !toggle3;
                              });

                              context.showLoaderOverlay();
                              await apiBLMHideAddress(hide: toggle3);
                              context.hideLoaderOverlay();
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                            color: toggle3 ? Color(0xff85DBF1) : Color(0xff888888),
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(child: MiscBLMInputFieldTemplate(key: _key4, labelText: 'Email', displayText: details.data!.blmShowOtherDetailsEmail, type: TextInputType.emailAddress,),),

                          SizedBox(width: 20,),

                          IconButton(
                            onPressed: () async{
                              setState(() {
                                toggle4 = !toggle4;
                              });

                              context.showLoaderOverlay();
                              await apiBLMHideEmail(hide: toggle4);
                              context.hideLoaderOverlay();
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                            color: toggle4 ? Color(0xff85DBF1) : Color(0xff888888),
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(child: MiscBLMPhoneNumberPickerTemplate(key: _key5, labelText: 'Contact Number', displayText: details.data!.blmShowOtherDetailsPhoneNumber, type: TextInputType.phone),),

                          SizedBox(width: 20,),

                          IconButton(
                            onPressed: () async{
                              setState(() {
                                toggle5 = !toggle5;
                              });

                              context.showLoaderOverlay();
                              await apiBLMHidePhoneNumber(hide: toggle5);
                              context.hideLoaderOverlay();
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                            color: toggle5 ? Color(0xff85DBF1) : Color(0xff888888),
                          ),
                        ],
                      ),

                      SizedBox(height: 80,),

                      MiscBLMButtonTemplate(
                        buttonText: 'Update', 
                        buttonTextStyle: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2,
                        height: 45,
                        buttonColor: Color(0xff04ECFF),
                        onPressed: () async{
                          if(
                            details.data!.blmShowOtherDetailsBirthdate != _key1.currentState!.controller.text ||
                            details.data!.blmShowOtherDetailsBirthplace !=  _key2.currentState!.controller.text ||
                            details.data!.blmShowOtherDetailsAddress != _key3.currentState!.controller.text ||
                            details.data!.blmShowOtherDetailsEmail != _key4.currentState!.controller.text ||
                            details.data!.blmShowOtherDetailsPhoneNumber != _key5.currentState!.controller2.text
                          ){
                            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                            if(confirmResult){

                              context.showLoaderOverlay();
                              bool result = await apiBLMUpdateOtherDetails(
                                birthdate: _key1.currentState!.controller.text,
                                birthplace: _key2.currentState!.controller.text,
                                address: _key3.currentState!.controller.text,
                                email: _key4.currentState!.controller.text,
                                phoneNumber: _key5.currentState!.controller2.text,
                              );
                              context.hideLoaderOverlay();

                              if(result){
                                await showOkAlertDialog(
                                  context: context,
                                  title: 'Success',
                                  message: 'Successfully updated the other details.',
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: userId,)));
                              }else{
                                await showOkAlertDialog(
                                  context: context,
                                  title: 'Error',
                                  message: 'Something went wrong. Please try again.',
                                );
                              }
                            }
                          }
                        },
                      ),

                      SizedBox(height: 20,),

                    ],
                  ),
                );
              }else if(details.hasError){
                return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),));
              }else{
                return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
              }
            },
          ),
        ),
      ),
    );
  }
}