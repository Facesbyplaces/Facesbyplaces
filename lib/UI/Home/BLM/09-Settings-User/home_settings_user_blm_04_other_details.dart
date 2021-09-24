import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_02_show_other_details.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_06_update_other_details.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_07_hide_birthdate.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_08_hide_birthplace.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_09_hide_address.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_10_hide_email.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_11_hide_phone_number.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_01_blm_input_field.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'home_settings_use_blm_01_user_details.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:misc/misc.dart';

class HomeBLMUserOtherDetails extends StatefulWidget{
  final int userId;
  final bool toggleBirthdate;
  final bool toggleBirthplace;
  final bool toggleAddress;
  final bool toggleEmail;
  final bool toggleNumber;
  const HomeBLMUserOtherDetails({Key? key, required this.userId, required this.toggleBirthdate, required this.toggleBirthplace, required this.toggleAddress, required this.toggleEmail, required this.toggleNumber}) : super(key: key);

  @override
  HomeBLMUserOtherDetailsState createState() => HomeBLMUserOtherDetailsState();
}

class HomeBLMUserOtherDetailsState extends State<HomeBLMUserOtherDetails>{
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key1 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberTemplateState> _key5 = GlobalKey<MiscBLMPhoneNumberTemplateState>();
  ValueNotifier<bool> toggle1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle3 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle4 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle5 = ValueNotifier<bool>(false);
  Future<APIBLMShowOtherDetails>? otherDetails;

  @override
  void initState(){
    super.initState();
    otherDetails = getOtherDetails(widget.userId);
    toggle1.value = widget.toggleBirthdate;
    toggle2.value = widget.toggleBirthplace;
    toggle3.value = widget.toggleAddress;
    toggle4.value = widget.toggleEmail;
    toggle5.value = widget.toggleNumber;
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
        child: ValueListenableBuilder(
          valueListenable: toggle1,
          builder: (_, bool toggle1Listener, __) => ValueListenableBuilder(
            valueListenable: toggle2,
            builder: (_, bool toggle2Listener, __) => ValueListenableBuilder(
              valueListenable: toggle3,
              builder: (_, bool toggle3Listener, __) => ValueListenableBuilder(
                valueListenable: toggle4,
                builder: (_, bool toggle4Listener, __) => ValueListenableBuilder(
                  valueListenable: toggle5,
                  builder: (_, bool toggle5Listener, __) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: const Color(0xff04ECFF),
                      title: const Text('Other Details', textAlign: TextAlign.left, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff)),),
                      centerTitle: false,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back,size: 35,),
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
                                        displayText: details.data!.blmShowOtherDetailsBirthdate != '' ? details.data!.blmShowOtherDetailsBirthdate.substring(0, details.data!.blmShowOtherDetailsBirthdate.indexOf('T'),) : details.data!.blmShowOtherDetailsBirthdate,
                                      ),
                                    ),

                                    const SizedBox(width: 20,),

                                    IconButton(
                                      icon: toggle1Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                      color: toggle1Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                      onPressed: () async{
                                        toggle1.value = !toggle1.value;

                                        await apiBLMHideBirthdate(hide: toggle1.value);
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
                                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                                      ),
                                    ),

                                    const SizedBox(width: 20,),

                                    IconButton(
                                      icon: toggle2Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                      color: toggle2Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                      onPressed: () async{
                                        toggle2.value = !toggle2.value;

                                        await apiBLMHideBirthplace(hide: toggle2.value);
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
                                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 20,),

                                    IconButton(
                                      icon: toggle3Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                      color: toggle3Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                      onPressed: () async{
                                        toggle3.value = !toggle3.value;

                                        await apiBLMHideAddress(hide: toggle3.value);
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
                                        type: TextInputType.emailAddress,
                                        displayText: details.data!.blmShowOtherDetailsEmail,
                                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                                      ),
                                    ),

                                    const SizedBox(width: 20,),

                                    IconButton(
                                      icon: toggle4Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                      color: toggle4Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                      onPressed: () async{
                                        toggle4.value = !toggle4.value;

                                        await apiBLMHideEmail(hide: toggle4.value);
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
                                        type: TextInputType.phone,
                                        displayText: details.data!.blmShowOtherDetailsPhoneNumber,
                                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                                      ),
                                    ),

                                    const SizedBox(width: 20,),

                                    IconButton(
                                      icon: toggle5Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                      color: toggle5Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                      onPressed: () async{
                                        toggle5.value = !toggle5.value;

                                        await apiBLMHidePhoneNumber(hide: toggle5.value);
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 80,),

                                MiscButtonTemplate(
                                  buttonText: 'Update',
                                  buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                                  buttonColor: const Color(0xff04ECFF),
                                  width: SizeConfig.screenWidth! / 2,
                                  height: 50,
                                  onPressed: () async{
                                    if(details.data!.blmShowOtherDetailsBirthdate != _key1.currentState!.controller.text || details.data!.blmShowOtherDetailsBirthplace != _key2.currentState!.controller.text || details.data!.blmShowOtherDetailsAddress != _key3.currentState!.controller.text || details.data!.blmShowOtherDetailsEmail != _key4.currentState!.controller.text || details.data!.blmShowOtherDetailsPhoneNumber != _key5.currentState!.controller.text){
                                      bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),),);

                                      if(confirmResult){
                                        context.loaderOverlay.show();
                                        bool result = await apiBLMUpdateOtherDetails(birthdate: _key1.currentState!.controller.text, birthplace: _key2.currentState!.controller.text, address: _key3.currentState!.controller.text, email: _key4.currentState!.controller.text, phoneNumber: _key5.currentState!.controller.text,);
                                        context.loaderOverlay.hide();

                                        if(result){
                                          await showDialog(
                                            context: context,
                                            builder: (_) => AssetGiffyDialog(
                                              description: const Text('Successfully updated the other details.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                              title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                              entryAnimation: EntryAnimation.DEFAULT,
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
                                              description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                              title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                              entryAnimation: EntryAnimation.DEFAULT,
                                              buttonOkColor: const Color(0xffff0000),
                                              onlyOkButton: true,
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
                          return SizedBox(height: SizeConfig.screenHeight, child: const Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),);
                        }else{
                          return SizedBox(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}