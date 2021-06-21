import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-06-update-other-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-02-show-other-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-07-hide-birthdate.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-08-hide-birthplace.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-10-hide-email.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-09-hide-address.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-11-hide-phone-number.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularUserOtherDetails extends StatefulWidget{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;
  const HomeRegularUserOtherDetails({required this.userId, required this.toggleBirthdate, required this.toggleBirthplace, required this.toggleAddress, required this.toggleEmail, required this.toggleNumber});

  HomeRegularUserOtherDetailsState createState() => HomeRegularUserOtherDetailsState();
}

class HomeRegularUserOtherDetailsState extends State<HomeRegularUserOtherDetails>{
  final GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key1 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key3 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key4 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularPhoneNumberTemplateState> _key5 = GlobalKey<MiscRegularPhoneNumberTemplateState>();

  Future<APIRegularShowOtherDetails>? otherDetails;
  bool toggle1 = false;
  bool toggle2 = false;
  bool toggle3 = false;
  bool toggle4 = false;
  bool toggle5 = false;

  void initState() {
    super.initState();
    otherDetails = getOtherDetails(widget.userId);
    toggle1 = widget.toggleBirthdate;
    toggle2 = widget.toggleBirthplace;
    toggle3 = widget.toggleAddress;
    toggle4 = widget.toggleEmail;
    toggle5 = widget.toggleNumber;
  }

  Future<APIRegularShowOtherDetails> getOtherDetails(int userId) async{
    return await apiRegularShowOtherDetails(userId: userId);
  }

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
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            centerTitle: true,
            title: Row(
              children: [
                Text('Other Details', textAlign: TextAlign.left, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff)),),

                Spacer(),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back,size: SizeConfig.blockSizeVertical! * 3.65,),
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
                  padding: const EdgeInsets.all(20.0),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MiscRegularInputFieldDateTimeTemplate(
                              key: _key1,
                              labelText: 'Birthdate',
                              displayText: details.data!.showOtherDetailsBirthdate,
                            ),
                          ),

                          const SizedBox(height: 20,),

                          IconButton(
                            icon: toggle1 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle1 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle1 = !toggle1;
                              });

                              await apiRegularHideBirthdate(hide: toggle1);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: MiscRegularInputFieldTemplate(
                              key: _key2,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                              displayText: details.data!.showOtherDetailsBirthplace,
                              labelText: 'Birthplace',
                            ),
                          ),

                          const SizedBox(height: 20,),

                          IconButton(
                            icon: toggle2 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle2 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle2 = !toggle2;
                              });

                              await apiRegularHideBirthplace(hide: toggle2);
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20,),
                      
                      Row(
                        children: [
                          Expanded(
                            child: MiscRegularInputFieldTemplate(
                              key: _key3,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                              displayText: details.data!.showOtherDetailsAddress,
                              labelText: 'Home Address',
                            ),
                          ),

                          const SizedBox(height: 20,),

                          IconButton(
                            icon: toggle3 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle3 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle3 = !toggle3;
                              });

                              await apiRegularHideAddress(hide: toggle3);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: MiscRegularInputFieldTemplate(
                              key: _key4,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                              displayText: details.data!.showOtherDetailsEmail,
                              type: TextInputType.emailAddress,
                              labelText: 'Email',
                            ),
                          ),

                          const SizedBox(height: 20,),

                          IconButton(
                            icon: toggle4 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle4 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle4 = !toggle4;
                              });

                              await apiRegularHideEmail(hide: toggle4);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: MiscRegularPhoneNumberTemplate(
                              key: _key5,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular',color: const Color(0xffBDC3C7),),
                              displayText: details.data!.showOtherDetailsPhoneNumber,
                              labelText: 'Contact Number',
                              type: TextInputType.phone,
                            ),
                          ),

                          const SizedBox(height: 20,),

                          IconButton(
                            icon: toggle5 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle5 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle5 = !toggle5;
                              });

                              await apiRegularHidePhoneNumber(hide: toggle5);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 80,),

                      MiscRegularButtonTemplate(
                        buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                        buttonColor: const Color(0xff04ECFF),
                        width: SizeConfig.screenWidth! / 2,
                        buttonText: 'Update',
                        height: 45,
                        onPressed: () async{
                          if(details.data!.showOtherDetailsBirthdate != _key1.currentState!.controller.text || details.data!.showOtherDetailsBirthplace != _key2.currentState!.controller.text || details.data!.showOtherDetailsAddress != _key3.currentState!.controller.text || details.data!.showOtherDetailsEmail != _key4.currentState!.controller.text || details.data!.showOtherDetailsPhoneNumber != _key5.currentState!.controller.text){
                            bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: const Color(0xff04ECFF), confirmColor_2: const Color(0xffFF0000),),);

                            if(confirmResult){
                              context.loaderOverlay.show();
                              bool result = await apiRegularUpdateOtherDetails(birthdate: _key1.currentState!.controller.text, birthplace: _key2.currentState!.controller.text, address: _key3.currentState!.controller.text, email: _key4.currentState!.controller.text, phoneNumber: _key5.currentState!.controller.text,);
                              context.loaderOverlay.hide();

                              if(result){
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Successfully updated the other details.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                    onlyOkButton: true,
                                    onOkButtonPressed: (){
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );

                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: widget.userId,)));
                              }else{
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                    onlyOkButton: true,
                                    buttonOkColor: const Color(0xffff0000),
                                    onOkButtonPressed: (){
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),

                      const SizedBox(height: 20,),
                    ],
                  ),
                );
              }else if(details.hasError){
                return Container(
                  height: SizeConfig.screenHeight,
                  child: const Center(child: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),),
                );
              }else{
                return Container(
                  height: SizeConfig.screenHeight,
                  child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}