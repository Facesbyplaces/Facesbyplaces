import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-05-change-password.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularUserChangePassword extends StatefulWidget {
  final int userId;
  const HomeRegularUserChangePassword({required this.userId});

  HomeRegularUserChangePasswordState createState() =>
      HomeRegularUserChangePasswordState(userId: userId);
}

class HomeRegularUserChangePasswordState
    extends State<HomeRegularUserChangePassword> {
  final int userId;
  HomeRegularUserChangePasswordState({required this.userId});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 =
      GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 =
      GlobalKey<MiscRegularInputFieldTemplateState>();

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
          body: Container(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  MiscRegularInputFieldTemplate(
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
                  MiscRegularInputFieldTemplate(
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
                  MiscRegularButtonTemplate(
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
                      bool result = await apiRegularChangePassword(
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
                                builder: (context) =>
                                    HomeRegularUserProfileDetails(
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
                  SizedBox(
                    height: 160,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
