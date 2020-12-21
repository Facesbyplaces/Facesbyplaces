import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-44-show-other-details.dart';
import 'package:facesbyplaces/API/BLM/api-45-update-other-details.dart';
import 'package:facesbyplaces/API/BLM/api-47-hide-birthdate.dart';
import 'package:facesbyplaces/API/BLM/api-48-hide-birthplace.dart';
import 'package:facesbyplaces/API/BLM/api-49-hide-email.dart';
import 'package:facesbyplaces/API/BLM/api-50-hide-address.dart';
import 'package:facesbyplaces/API/BLM/api-51-hide-phone-number.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'home-14-blm-user-details.dart';

class HomeBLMUserOtherDetails extends StatefulWidget{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;

  HomeBLMUserOtherDetails({this.userId, this.toggleBirthdate, this.toggleBirthplace, this.toggleAddress, this.toggleEmail, this.toggleNumber});

  HomeBLMUserOtherDetailsState createState() => HomeBLMUserOtherDetailsState(userId: userId, toggleBirthdate: toggleBirthdate, toggleBirthplace: toggleBirthdate, toggleAddress: toggleAddress, toggleEmail: toggleEmail, toggleNumber: toggleNumber);
}

class HomeBLMUserOtherDetailsState extends State<HomeBLMUserOtherDetails>{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;
  HomeBLMUserOtherDetailsState({this.userId, this.toggleBirthdate, this.toggleBirthplace, this.toggleAddress, this.toggleEmail, this.toggleNumber});

  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key1 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberTemplateState> _key5 = GlobalKey<MiscBLMPhoneNumberTemplateState>();

  Future otherDetails;
  bool toggle1;
  bool toggle2;
  bool toggle3;
  bool toggle4;
  bool toggle5;

  void initState(){
    super.initState();
    otherDetails = getOtherDetails(userId);
    toggle1 = toggleBirthdate;
    toggle2 = toggleBirthplace;
    toggle3 = toggleEmail;
    toggle4 = toggleAddress;
    toggle5 = toggleNumber;
  }

  Future<APIBLMShowOtherDetails> getOtherDetails(int userId) async{
    return await apiBLMShowOtherDetails(userId);
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
            title: Text('Other Details', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
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
                  child: Container(
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded(child: MiscBLMInputFieldDateTimeTemplate(key: _key1, labelText: 'Birthdate', displayText: details.data.birthdate,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle1 = !toggle1;
                                });

                                await apiBLMHideBirthdate(hide: toggle1);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle1 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscBLMInputFieldTemplate(key: _key2, labelText: 'Birthplace', displayText: details.data.birthplace,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle2 = !toggle2;
                                });

                                await apiBLMHideBirthplace(hide: toggle2);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle2 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscBLMInputFieldTemplate(key: _key3, labelText: 'Home Address', displayText: details.data.address,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle3 = !toggle3;
                                });

                                await apiBLMHideEmail(hide: toggle3);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle3 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscBLMInputFieldTemplate(key: _key4, labelText: 'Email', displayText: details.data.email, type: TextInputType.emailAddress,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle4 = !toggle4;
                                });

                                await apiBLMHideAddress(hide: toggle4);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle4 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscBLMPhoneNumberTemplate(key: _key5, labelText: 'Contact Number', displayText: details.data.phoneNumber, type: TextInputType.phone, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle5 = !toggle5;
                                });

                                await apiBLMHidePhoneNumber(hide: toggle5);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle5 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        Expanded(child: Container(),),

                        MiscBLMButtonTemplate(
                          buttonText: 'Update', 
                          buttonTextStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xffffffff),
                          ),
                          onPressed: () async{

                            if(
                              details.data.birthdate != _key1.currentState.controller.text ||
                              details.data.birthplace !=  _key2.currentState.controller.text ||
                              details.data.email != _key3.currentState.controller.text ||
                              details.data.address != _key4.currentState.controller.text ||
                              details.data.phoneNumber != _key5.currentState.controller.text
                            ){
                              bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                              if(confirmResult){
                                context.showLoaderOverlay();

                                bool result = await apiBLMUpdateOtherDetails(
                                  birthdate: _key1.currentState.controller.text,
                                  birthplace: _key2.currentState.controller.text,
                                  email: _key3.currentState.controller.text,
                                  address: _key4.currentState.controller.text,
                                  phoneNumber: _key5.currentState.controller.text,
                                );

                                print('The result is $result');

                                context.hideLoaderOverlay();

                                if(result){

                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: userId,), settings: RouteSettings(name: 'newRoute')),
                                  // );

                                  // Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                                  
                                  Route route = MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: userId), settings: RouteSettings(name: '/profile-settings'));
                                  Navigator.popAndPushNamed(context, route.settings.name);
                                }else{
                                  await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                }
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
                );
              }else if(details.hasError){
                return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
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