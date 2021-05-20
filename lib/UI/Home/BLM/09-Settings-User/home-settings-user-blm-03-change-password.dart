import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-05-change-password.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-blm-01-user-details.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMUserChangePassword extends StatefulWidget {
  final int userId;
  const HomeBLMUserChangePassword({required this.userId});

  HomeBLMUserChangePasswordState createState() => HomeBLMUserChangePasswordState();
}

class HomeBLMUserChangePasswordState extends State<HomeBLMUserChangePassword> {

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
                  'Change Password',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16,
                      fontFamily: 'NexaRegular', color: const Color(0xffffffff)),
                ),
                Spacer()
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xffffffff),
                size: SizeConfig.blockSizeVertical! * 3.65,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                MiscBLMInputFieldTemplate(
                  key: _key1,
                  labelText: 'Current Password',
                  obscureText: true,
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
                  labelText: 'New Password',
                  obscureText: true,
                  labelTextStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 2.11,
                    fontFamily: 'NexaRegular',
                    color: const Color(0xffBDC3C7),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                MiscBLMButtonTemplate(
                  buttonText: 'Update',
                  buttonTextStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 2.64,
                    fontFamily: 'NexaBold',
                    color: const Color(0xffffffff),
                  ),
                  width: SizeConfig.screenWidth! / 2,
                  height: 45,
                  buttonColor: const Color(0xff04ECFF),
                  onPressed: () async {
                    context.loaderOverlay.show();
                    bool result = await apiBLMChangePassword(
                        currentPassword: _key1.currentState!.controller.text,
                        newPassword: _key2.currentState!.controller.text);
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
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text(
                              'Successfully updated the password.',
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                  fontFamily: 'NexaRegular'
                              ),
                            ),
                                onlyOkButton: true,
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeBLMUserProfileDetails(
                                    userId: widget.userId,
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
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text(
                              'Something went wrong. Please try again.',
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                  fontFamily: 'NexaRegular'
                              ),
                            ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ));
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}