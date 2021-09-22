// ignore_for_file: file_names
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-04-update-account-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-01-show-account-details.dart';
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

class HomeRegularUserUpdateDetails extends StatefulWidget{
  final int userId;
  const HomeRegularUserUpdateDetails({Key? key, required this.userId}) : super(key: key);

  @override
  HomeRegularUserUpdateDetailsState createState() => HomeRegularUserUpdateDetailsState();
}

class HomeRegularUserUpdateDetailsState extends State<HomeRegularUserUpdateDetails>{
  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key3 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularPhoneNumberTemplateState> _key4 = GlobalKey<MiscRegularPhoneNumberTemplateState>();
  final GlobalKey<MiscRegularInputFieldSecurityQuestionsState> _key5 = GlobalKey<MiscRegularInputFieldSecurityQuestionsState>();
  Future<APIRegularShowAccountDetails>? accountDetails;

  @override
  void initState(){
    super.initState();
    accountDetails = getAccountDetails(widget.userId);
  }

  Future<APIRegularShowAccountDetails> getAccountDetails(int userId) async{
    return await apiRegularShowAccountDetails(userId: userId);
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
            title: const Text('Account Details', textAlign: TextAlign.left, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff)),),
            centerTitle: false,
            leading: Builder(
              builder: (BuildContext context){
                return IconButton(
                  icon: const Icon(Icons.arrow_back,size: 35,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          body: SafeArea(
            child: FutureBuilder<APIRegularShowAccountDetails>(
              future: accountDetails,
              builder: (context, details) {
                if (details.hasData) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        MiscRegularInputFieldTemplate(
                          key: _key1,
                          labelText: 'First Name',
                          displayText: details.data!.showAccountDetailsFirstName,
                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                        ),

                        const SizedBox(height: 20,),

                        MiscRegularInputFieldTemplate(
                          key: _key2,
                          labelText: 'Last Name',
                          displayText: details.data!.showAccountDetailsLastName,
                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                        ),

                        const SizedBox(height: 20,),

                        MiscRegularInputFieldTemplate(
                          key: _key3,
                          labelText: 'Email Address',
                          displayText: details.data!.showAccountDetailsEmail,
                          type: TextInputType.emailAddress,
                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                        ),

                        const SizedBox(height: 20,),

                        MiscRegularPhoneNumberTemplate(
                          key: _key4,
                          labelText: 'Phone Number',
                          displayText: details.data!.showAccountDetailsPhoneNumber,
                          labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                        ),

                        const SizedBox(height: 20,),

                        MiscRegularInputFieldSecurityQuestions(
                          key: _key5,
                          displayText: details.data!.showAccountDetailsQuestion != '' ? details.data!.showAccountDetailsQuestion : 'What\'s the name of your first dog?',
                        ),

                        const SizedBox(height: 80,),

                        MiscRegularButtonTemplate(
                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                          buttonColor: const Color(0xff04ECFF),
                          width: SizeConfig.screenWidth! / 2,
                          buttonText: 'Update',
                          height: 50,
                          onPressed: () async{
                            if(details.data!.showAccountDetailsFirstName != _key1.currentState!.controller.text || details.data!.showAccountDetailsLastName != _key2.currentState!.controller.text || details.data!.showAccountDetailsEmail != _key3.currentState!.controller.text || details.data!.showAccountDetailsPhoneNumber != _key4.currentState!.controller.text || details.data!.showAccountDetailsQuestion != _key5.currentState!.currentSelection){
                              bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000), ),);

                              if(confirmResult){
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateAccountDetails(firstName: _key1.currentState!.controller.text, lastName: _key2.currentState!.controller.text, email: _key3.currentState!.controller.text, phoneNumber: _key4.currentState!.controller.text, question: _key5.currentState!.currentSelection,);
                                context.loaderOverlay.hide();

                                if(result){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                      description: const Text('Successfully updated the profile picture.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                }else if (details.hasError){
                  return SizedBox(height: SizeConfig.screenHeight, child: const Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),);
                }else{
                  return SizedBox(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}