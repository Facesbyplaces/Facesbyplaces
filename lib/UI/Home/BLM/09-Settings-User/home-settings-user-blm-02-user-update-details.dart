import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-01-show-account-details.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-04-update-account-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-settings-user-blm-01-user-details.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMUserUpdateDetails extends StatefulWidget {
  final int userId;
  const HomeBLMUserUpdateDetails({required this.userId});

  HomeBLMUserUpdateDetailsState createState() =>
      HomeBLMUserUpdateDetailsState(userId: userId);
}

class HomeBLMUserUpdateDetailsState extends State<HomeBLMUserUpdateDetails> {
  final int userId;
  HomeBLMUserUpdateDetailsState({required this.userId});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 =
      GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 =
      GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 =
      GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberTemplateState> _key4 =
      GlobalKey<MiscBLMPhoneNumberTemplateState>();
  final GlobalKey<MiscBLMInputFieldSecurityQuestionsState> _key5 =
      GlobalKey<MiscBLMInputFieldSecurityQuestionsState>();

  Future<APIBLMShowAccountDetails>? accountDetails;

  void initState() {
    super.initState();
    accountDetails = getAccountDetails(userId);
  }

  Future<APIBLMShowAccountDetails> getAccountDetails(int userId) async {
    return await apiBLMShowAccountDetails(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            title: Row(
              children: [
                Text(
                  'Account Details',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16,
                      fontFamily: 'NexaRegular', color: const Color(0xffffffff)),
                ),
                Spacer()
              ],
            ),
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back,size: SizeConfig.blockSizeVertical! * 3.65,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          body: FutureBuilder<APIBLMShowAccountDetails>(
            future: accountDetails,
            builder: (context, details) {
              if (details.hasData) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      MiscBLMInputFieldTemplate(
                        key: _key1,
                        labelText: 'First Name',
                        displayText: details.data!.showAccountDetailsFirstName,
                        labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xffBDC3C7),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MiscBLMInputFieldTemplate(
                        key: _key2,
                        labelText: 'Last Name',
                        displayText: details.data!.showAccountDetailsLastName,
                        labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xffBDC3C7),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MiscBLMInputFieldTemplate(
                        key: _key3,
                        labelText: 'Email Address',
                        displayText: details.data!.showAccountDetailsEmail,
                        type: TextInputType.emailAddress,
                        labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xffBDC3C7),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MiscBLMPhoneNumberTemplate(
                          key: _key4,
                          labelText: 'Mobile Number',
                          displayText:
                              details.data!.showAccountDetailsPhoneNumber,
                          type: TextInputType.phone,
                        labelTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                          fontFamily: 'NexaRegular',
                          color: const Color(0xffBDC3C7),
                        ),),
                      const SizedBox(
                        height: 20,
                      ),
                      MiscBLMInputFieldSecurityQuestions(
                          key: _key5,
                          displayText:
                              details.data!.showAccountDetailsQuestion != ''
                                  ? details.data!.showAccountDetailsQuestion
                                  : 'What\'s the name of your first dog?'),
                      const SizedBox(
                        height: 80,
                      ),
                      MiscBLMButtonTemplate(
                        buttonText: 'Update',
                        buttonTextStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 2.74,
                          fontFamily: 'NexaBold',
                          color: const Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2,
                        height: 45,
                        buttonColor: const Color(0xff04ECFF),
                        onPressed: () async {
                          if (details.data!.showAccountDetailsFirstName !=
                                  _key1.currentState!.controller.text ||
                              details.data!.showAccountDetailsLastName !=
                                  _key2.currentState!.controller.text ||
                              details.data!.showAccountDetailsEmail !=
                                  _key3.currentState!.controller.text ||
                              details.data!.showAccountDetailsPhoneNumber !=
                                  _key4.currentState!.controller.text ||
                              details.data!.showAccountDetailsQuestion !=
                                  _key5.currentState!.currentSelection) {
                            bool confirmResult = await showDialog(
                                context: (context),
                                builder: (build) => const MiscBLMConfirmDialog(
                                      title: 'Confirm',
                                      content:
                                          'Do you want to save the changes?',
                                      confirmColor_1: const Color(0xff04ECFF),
                                      confirmColor_2: const Color(0xffFF0000),
                                    ));

                            if (confirmResult) {
                              context.loaderOverlay.show();
                              bool result = await apiBLMUpdateAccountDetails(
                                firstName: _key1.currentState!.controller.text,
                                lastName: _key2.currentState!.controller.text,
                                email: _key3.currentState!.controller.text,
                                phoneNumber:
                                    _key4.currentState!.controller.text,
                                question: _key5.currentState!.currentSelection,
                              );
                              context.loaderOverlay.hide();

                              if (result) {
                                await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                          image: Image.asset(
                                            'assets/icons/cover-icon.png',
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(
                                            'Success',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                                fontFamily: 'NexaRegular'),
                                          ),
                                          entryAnimation:
                                              EntryAnimation.DEFAULT,
                                          description: Text(
                                            'Successfully updated the account details.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                    .blockSizeVertical! *
                                                    2.87,
                                                fontFamily: 'NexaRegular'),
                                          ),
                                          onlyOkButton: true,
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeBLMUserProfileDetails(
                                              userId: userId,
                                            )));
                              } else {
                                await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                          image: Image.asset(
                                            'assets/icons/cover-icon.png',
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(
                                            'Error',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                                fontFamily: 'NexaRegular'),
                                          ),
                                          entryAnimation:
                                              EntryAnimation.DEFAULT,
                                          description: Text(
                                            'Something went wrong. Please try again.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                    .blockSizeVertical! *
                                                    2.87,
                                                fontFamily: 'NexaRegular'),
                                          ),
                                          onlyOkButton: true,
                                          buttonOkColor:
                                              const Color(0xffff0000),
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ));
                              }
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              } else if (details.hasError) {
                return Container(
                    height: SizeConfig.screenHeight,
                    child: const Center(
                      child: const Text(
                        'Something went wrong. Please try again.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ));
              } else {
                return Container(
                  height: SizeConfig.screenHeight,
                  child: Center(
                    child: Container(
                      child: const SpinKitThreeBounce(
                        color: const Color(0xff000000),
                        size: 50.0,
                      ),
                      color: const Color(0xffffffff),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
