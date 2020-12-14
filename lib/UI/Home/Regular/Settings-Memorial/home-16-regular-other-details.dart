import 'package:facesbyplaces/API/Regular/api-34-regular-show-other-details.dart';
import 'package:facesbyplaces/API/Regular/api-35-regular-hide-birthdate.dart';
import 'package:facesbyplaces/API/Regular/api-36-regular-hide-birthplace.dart';
import 'package:facesbyplaces/API/Regular/api-37-regular-hide-email.dart';
import 'package:facesbyplaces/API/Regular/api-38-regular-hide-address.dart';
import 'package:facesbyplaces/API/Regular/api-39-regular-hide-phone-number.dart';
import 'package:facesbyplaces/API/Regular/api-51-regular-update-other-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-14-regular-user-details.dart';
import 'package:flutter/material.dart';

class HomeRegularUserOtherDetails extends StatefulWidget{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;

  HomeRegularUserOtherDetails({this.userId, this.toggleBirthdate, this.toggleBirthplace, this.toggleAddress, this.toggleEmail, this.toggleNumber});

  HomeRegularUserOtherDetailsState createState() => HomeRegularUserOtherDetailsState(userId: userId, toggleBirthdate: toggleBirthdate, toggleBirthplace: toggleBirthdate, toggleAddress: toggleAddress, toggleEmail: toggleEmail, toggleNumber: toggleNumber);
}

class HomeRegularUserOtherDetailsState extends State<HomeRegularUserOtherDetails>{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;
  HomeRegularUserOtherDetailsState({this.userId, this.toggleBirthdate, this.toggleBirthplace, this.toggleAddress, this.toggleEmail, this.toggleNumber});

  final GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key1 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key3 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key4 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularPhoneNumberTemplateState> _key5 = GlobalKey<MiscRegularPhoneNumberTemplateState>();

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

  Future<APIRegularShowOtherDetails> getOtherDetails(int userId) async{
    return await apiRegularShowOtherDetails(userId);
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
          body: FutureBuilder<APIRegularShowOtherDetails>(
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
                            Expanded(child: MiscRegularInputFieldDateTimeTemplate(key: _key1, labelText: 'Birthdate', displayText: details.data.birthdate,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle1 = !toggle1;
                                });

                                await apiRegularHideBirthdate(hide: toggle1);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle1 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace', displayText: details.data.birthplace,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle2 = !toggle2;
                                });

                                await apiRegularHideBirthplace(hide: toggle2);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle2 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularInputFieldTemplate(key: _key3, labelText: 'Home Address', displayText: details.data.address,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle3 = !toggle3;
                                });

                                await apiRegularHideEmail(hide: toggle3);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle3 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularInputFieldTemplate(key: _key4, labelText: 'Email', displayText: details.data.email, type: TextInputType.emailAddress,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle4 = !toggle4;
                                });

                                await apiRegularHideAddress(hide: toggle4);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle4 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularPhoneNumberTemplate(key: _key5, labelText: 'Contact Number', displayText: details.data.phoneNumber, type: TextInputType.phone, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle5 = !toggle5;
                                });

                                await apiRegularHidePhoneNumber(hide: toggle5);
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle5 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        Expanded(child: Container(),),

                        MiscRegularButtonTemplate(
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
                              bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                              if(confirmResult){
                                context.showLoaderOverlay();

                                bool result = await apiRegularUpdateOtherDetails(
                                  birthdate: _key1.currentState.controller.text,
                                  birthplace: _key2.currentState.controller.text,
                                  email: _key3.currentState.controller.text,
                                  address: _key4.currentState.controller.text,
                                  phoneNumber: _key5.currentState.controller.text,
                                );

                                context.hideLoaderOverlay();

                                if(result){

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId,), settings: RouteSettings(name: 'newRoute')),
                                  );

                                  Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                                }else{
                                  await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
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