// ignore_for_file: file_names
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
  const HomeRegularUserOtherDetails({Key? key, required this.userId, required this.toggleBirthdate, required this.toggleBirthplace, required this.toggleAddress, required this.toggleEmail, required this.toggleNumber}) : super(key: key);

  @override
  HomeRegularUserOtherDetailsState createState() => HomeRegularUserOtherDetailsState();
}

class HomeRegularUserOtherDetailsState extends State<HomeRegularUserOtherDetails>{
  final GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key1 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key3 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key4 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularPhoneNumberTemplateState> _key5 = GlobalKey<MiscRegularPhoneNumberTemplateState>();
  ValueNotifier<bool> toggle1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle3 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle4 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle5 = ValueNotifier<bool>(false);
  Future<APIRegularShowOtherDetails>? otherDetails;

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
                      centerTitle: false,
                      title: const Text('Other Details', textAlign: TextAlign.left, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff)),),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back,size: 35,),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    body: SafeArea(
                      child: FutureBuilder<APIRegularShowOtherDetails>(
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
                                          displayText: details.data!.showOtherDetailsBirthdate != '' ? details.data!.showOtherDetailsBirthdate.substring(0, details.data!.showOtherDetailsBirthdate.indexOf('T'),) : details.data!.showOtherDetailsBirthdate,
                                        ),
                                      ),

                                      const SizedBox(height: 20,),

                                      IconButton(
                                        icon: toggle1Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                        color: toggle1Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                        onPressed: () async{
                                          toggle1.value = !toggle1.value;

                                          await apiRegularHideBirthdate(hide: toggle1.value);
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
                                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                                          displayText: details.data!.showOtherDetailsBirthplace,
                                          labelText: 'Birthplace',
                                        ),
                                      ),

                                      const SizedBox(height: 20,),

                                      IconButton(
                                        icon: toggle2Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                        color: toggle2Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                        onPressed: () async{
                                          toggle2.value = !toggle2.value;

                                          await apiRegularHideBirthplace(hide: toggle2.value);
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
                                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                                          displayText: details.data!.showOtherDetailsAddress,
                                          labelText: 'Home Address',
                                        ),
                                      ),

                                      const SizedBox(height: 20,),

                                      IconButton(
                                        icon: toggle3Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                        color: toggle3Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                        onPressed: () async{
                                          toggle3.value = !toggle3.value;

                                          await apiRegularHideAddress(hide: toggle3.value);
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
                                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                                          displayText: details.data!.showOtherDetailsEmail,
                                          type: TextInputType.emailAddress,
                                          labelText: 'Email',
                                        ),
                                      ),

                                      const SizedBox(height: 20,),

                                      IconButton(
                                        icon: toggle4Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                        color: toggle4Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                        onPressed: () async{
                                          toggle4.value = !toggle4.value;

                                          await apiRegularHideEmail(hide: toggle4.value);
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
                                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',color: Color(0xffBDC3C7),),
                                          displayText: details.data!.showOtherDetailsPhoneNumber,
                                          labelText: 'Contact Number',
                                          type: TextInputType.phone,
                                        ),
                                      ),

                                      const SizedBox(height: 20,),

                                      IconButton(
                                        icon: toggle5Listener ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                                        color: toggle5Listener ? const Color(0xff85DBF1) : const Color(0xff888888),
                                        onPressed: () async{
                                          toggle5.value = !toggle5.value;

                                          await apiRegularHidePhoneNumber(hide: toggle5.value);
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 80,),

                                  MiscRegularButtonTemplate(
                                    buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                                    buttonColor: const Color(0xff04ECFF),
                                    width: SizeConfig.screenWidth! / 2,
                                    buttonText: 'Update',
                                    height: 50,
                                    onPressed: () async{
                                      if(details.data!.showOtherDetailsBirthdate != _key1.currentState!.controller.text || details.data!.showOtherDetailsBirthplace != _key2.currentState!.controller.text || details.data!.showOtherDetailsAddress != _key3.currentState!.controller.text || details.data!.showOtherDetailsEmail != _key4.currentState!.controller.text || details.data!.showOtherDetailsPhoneNumber != _key5.currentState!.controller.text){
                                        bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),),);

                                        if(confirmResult){
                                          context.loaderOverlay.show();
                                          bool result = await apiRegularUpdateOtherDetails(birthdate: _key1.currentState!.controller.text, birthplace: _key2.currentState!.controller.text, address: _key3.currentState!.controller.text, email: _key4.currentState!.controller.text, phoneNumber: _key5.currentState!.controller.text,);
                                          context.loaderOverlay.hide();

                                          if(result){
                                            await showDialog(
                                              context: context,
                                              builder: (_) => AssetGiffyDialog(
                                                title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                                description: const Text('Successfully updated the other details.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                entryAnimation: EntryAnimation.DEFAULT,
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
                                                title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                                description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
      ),
    );
  }
}