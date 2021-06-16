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
import 'home-settings-user-blm-01-user-details.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMUserOtherDetails extends StatefulWidget{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;

  const HomeBLMUserOtherDetails({required this.userId, required this.toggleBirthdate, required this.toggleBirthplace, required this.toggleAddress, required this.toggleEmail, required this.toggleNumber});

  HomeBLMUserOtherDetailsState createState() => HomeBLMUserOtherDetailsState();
}

class HomeBLMUserOtherDetailsState extends State<HomeBLMUserOtherDetails>{
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key1 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberTemplateState> _key5 = GlobalKey<MiscBLMPhoneNumberTemplateState>();

  Future<APIBLMShowOtherDetails>? otherDetails;
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

  Future<APIBLMShowOtherDetails> getOtherDetails(int userId) async{
    return await apiBLMShowOtherDetails(userId: userId);
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
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            title: Row(
              children: [
                Text('Other Details', textAlign: TextAlign.left, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff)),),
                Spacer(),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,size: SizeConfig.blockSizeVertical! * 3.65,),
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
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MiscBLMInputFieldDateTimeTemplate(
                              key: _key1,
                              labelText: 'Birthdate',
                              displayText: details.data!.blmShowOtherDetailsBirthdate.substring(0, details.data!.blmShowOtherDetailsBirthdate.indexOf('T'),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20,),

                          IconButton(
                            icon: toggle1 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle1 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle1 = !toggle1;
                              });

                              await apiBLMHideBirthdate(hide: toggle1);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: MiscBLMInputFieldTemplate(
                              key: _key2,
                              labelText: 'Birthplace',
                              displayText: details.data!.blmShowOtherDetailsBirthplace,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                            ),
                          ),

                          const SizedBox(width: 20,),

                          IconButton(
                            icon: toggle2 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle2 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle2 = !toggle2;
                              });

                              await apiBLMHideBirthplace(hide: toggle2);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),
                      
                      Row(
                        children: [
                          Expanded(
                            child: MiscBLMInputFieldTemplate(
                              key: _key3,
                              labelText: 'Home Address',
                              displayText: details.data!.blmShowOtherDetailsAddress,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20,),

                          IconButton(
                            icon: toggle3 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle3 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle3 = !toggle3;
                              });

                              await apiBLMHideAddress(hide: toggle3);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: MiscBLMInputFieldTemplate(
                              key: _key4,
                              labelText: 'Email',
                              displayText: details.data!.blmShowOtherDetailsEmail,
                              type: TextInputType.emailAddress,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                            ),
                          ),

                          const SizedBox(width: 20,),

                          IconButton(
                            icon: toggle4 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle4 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle4 = !toggle4;
                              });

                              await apiBLMHideEmail(hide: toggle4);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: MiscBLMPhoneNumberTemplate(
                              key: _key5,
                              labelText: 'Contact Number',
                              displayText: details.data!.blmShowOtherDetailsPhoneNumber,
                              type: TextInputType.phone,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                            ),
                          ),

                          const SizedBox(width: 20,),

                          IconButton(
                            icon: toggle5 ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                            color: toggle5 ? const Color(0xff85DBF1) : const Color(0xff888888),
                            onPressed: () async{
                              setState((){
                                toggle5 = !toggle5;
                              });

                              await apiBLMHidePhoneNumber(hide: toggle5);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 80,),

                      MiscBLMButtonTemplate(
                        buttonText: 'Update',
                        buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                        width: SizeConfig.screenWidth! / 2,
                        height: 45,
                        buttonColor: const Color(0xff04ECFF),
                        onPressed: () async {
                          if(details.data!.blmShowOtherDetailsBirthdate != _key1.currentState!.controller.text || details.data!.blmShowOtherDetailsBirthplace != _key2.currentState!.controller.text || details.data!.blmShowOtherDetailsAddress != _key3.currentState!.controller.text || details.data!.blmShowOtherDetailsEmail != _key4.currentState!.controller.text || details.data!.blmShowOtherDetailsPhoneNumber != _key5.currentState!.controller.text){
                            bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: const Color(0xff04ECFF), confirmColor_2: const Color(0xffFF0000),),);

                            if(confirmResult){
                              context.loaderOverlay.show();
                              bool result = await apiBLMUpdateOtherDetails(birthdate: _key1.currentState!.controller.text, birthplace: _key2.currentState!.controller.text, address: _key3.currentState!.controller.text, email: _key4.currentState!.controller.text, phoneNumber: _key5.currentState!.controller.text,);
                              context.loaderOverlay.hide();

                              if(result){
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Successfully updated the other details.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                    onlyOkButton: true,
                                    onOkButtonPressed: (){
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: widget.userId,)));
                              }else{
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
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

                      SizedBox(height: 20,),
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