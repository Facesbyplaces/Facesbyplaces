import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-06-update-other-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-02-show-other-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-07-hide-birthdate.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-08-hide-birthplace.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-10-hide-email.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-09-hide-address.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-11-hide-phone-number.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularUserOtherDetails extends StatefulWidget{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;

  HomeRegularUserOtherDetails({this.userId, this.toggleBirthdate, this.toggleBirthplace, this.toggleAddress, this.toggleEmail, this.toggleNumber});

  HomeRegularUserOtherDetailsState createState() => HomeRegularUserOtherDetailsState(userId: userId, toggleBirthdate: toggleBirthdate, toggleBirthplace: toggleBirthplace, toggleAddress: toggleAddress, toggleEmail: toggleEmail, toggleNumber: toggleNumber);
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
    toggle3 = toggleAddress;
    toggle4 = toggleEmail;
    toggle5 = toggleNumber;
  }

  Future<APIRegularShowOtherDetails> getOtherDetails(int userId) async{
    return await apiRegularShowOtherDetails(userId: userId);
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
                            Expanded(child: MiscRegularInputFieldDateTimeTemplate(key: _key1, labelText: 'Birthdate', displayText: details.data.showOtherDetailsBirthdate,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle1 = !toggle1;
                                });

                                context.showLoaderOverlay();
                                await apiRegularHideBirthdate(hide: toggle1);
                                context.hideLoaderOverlay();
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle1 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace', displayText: details.data.showOtherDetailsBirthplace,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle2 = !toggle2;
                                });

                                context.showLoaderOverlay();
                                await apiRegularHideBirthplace(hide: toggle2);
                                context.hideLoaderOverlay();
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle2 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularInputFieldTemplate(key: _key3, labelText: 'Home Address', displayText: details.data.showOtherDetailsAddress,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle3 = !toggle3;
                                });
                                context.showLoaderOverlay();
                                await apiRegularHideAddress(hide: toggle3);
                                context.hideLoaderOverlay();
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle3 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularInputFieldTemplate(key: _key4, labelText: 'Email', displayText: details.data.showOtherDetailsEmail, type: TextInputType.emailAddress,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle4 = !toggle4;
                                });

                                context.showLoaderOverlay();
                                await apiRegularHideEmail(hide: toggle4);
                                context.hideLoaderOverlay();
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              color: toggle4 ? Color(0xff85DBF1) : Color(0xff888888),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(child: MiscRegularPhoneNumberTemplate(key: _key5, labelText: 'Contact Number', displayText: details.data.showOtherDetailsPhoneNumber, type: TextInputType.phone, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            IconButton(
                              onPressed: () async{
                                setState(() {
                                  toggle5 = !toggle5;
                                });

                                context.showLoaderOverlay();
                                await apiRegularHidePhoneNumber(hide: toggle5);
                                context.hideLoaderOverlay();
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
                              details.data.showOtherDetailsBirthdate != _key1.currentState.controller.text ||
                              details.data.showOtherDetailsBirthplace !=  _key2.currentState.controller.text ||
                              details.data.showOtherDetailsAddress != _key3.currentState.controller.text ||
                              details.data.showOtherDetailsEmail != _key4.currentState.controller.text ||
                              details.data.showOtherDetailsPhoneNumber != _key5.currentState.controller.text
                            ){
                              bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                              if(confirmResult){
                                context.showLoaderOverlay();

                                bool result = await apiRegularUpdateOtherDetails(
                                  birthdate: _key1.currentState.controller.text,
                                  birthplace: _key2.currentState.controller.text,
                                  address: _key3.currentState.controller.text,
                                  email: _key4.currentState.controller.text,
                                  phoneNumber: _key5.currentState.controller.text,
                                );

                                context.hideLoaderOverlay();

                                if(result){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Successfully updated the other details.',
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId,)));
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