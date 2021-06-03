import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-01-logout.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-03-show-other-details-status.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-12-update-user-profile-picture.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-14-check-account.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home-settings-user-blm-02-user-update-details.dart';
import 'home-settings-user-blm-03-change-password.dart';
import 'home-settings-user-blm-04-other-details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import '../../../ui-01-get-started.dart';
import 'package:we_slide/we_slide.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomeBLMUserProfileDetails extends StatefulWidget {
  final int userId;
  HomeBLMUserProfileDetails({required this.userId});

  HomeBLMUserProfileDetailsState createState() => HomeBLMUserProfileDetailsState();
}

class HomeBLMUserProfileDetailsState extends State<HomeBLMUserProfileDetails> {
  Future<APIBLMShowProfileInformation>? showProfile;
  WeSlideController controller = WeSlideController();
  final picker = ImagePicker();
  File profileImage = File('');

  Future<APIBLMShowProfileInformation> getProfileInformation() async {
    return await apiBLMShowProfileInformation();
  }

  Future<bool> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
      return true;
    } else {
      return false;
    }
  }

  void initState() {
    super.initState();
    showProfile = getProfileInformation();
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      body: FutureBuilder<APIBLMShowProfileInformation>(
        future: showProfile,
        builder: (context, profile){
          if(profile.hasData){
            return WeSlide(
              controller: controller,
              panelMaxSize: SizeConfig.screenHeight! / 1.5,
              backgroundColor: const Color(0xffECF0F1),
              panel: Container(
                height: SizeConfig.screenHeight! / 1.5,
                padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                decoration: const BoxDecoration(color: const Color(0xffffffff), borderRadius: const BorderRadius.only(topLeft: const Radius.circular(50.0),),),
                child: Column(
                  children: [
                    Expanded(child: Container(),),

                    ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserUpdateDetails(userId: widget.userId,)));
                      },
                      title: Text('Update Details', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
                      subtitle: Text('Update your account details', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    ListTile(
                      onTap: () async{
                        final sharedPrefs = await SharedPreferences.getInstance();
                        bool socialAppSession = sharedPrefs.getBool('blm-social-app-session') ?? false;
                        context.loaderOverlay.show();
                        bool checkAccount = await apiBLMCheckAccount(email: profile.data!.showProfileInformationEmail).onError((error, stackTrace){
                          context.loaderOverlay.hide();
                          showDialog(
                            context: context,
                            builder: (_) => AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Error: $error.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                  fontFamily: 'NexaRegular'
                                ),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                          throw Exception('$error');
                        });
                        context.loaderOverlay.hide();

                        print('The value of socialAppSession is $socialAppSession');
                        print('The value of checkAccount is $checkAccount');

                        if(socialAppSession == true && checkAccount == false){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: widget.userId, isAddPassword: true,)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: widget.userId, isAddPassword: false,)));
                        }
                      },
                      title: Text('Password', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
                      subtitle: Text('Change your login password', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    ListTile(
                      onTap: () async{
                        context.loaderOverlay.show();
                        APIBLMShowOtherDetailsStatus result = await apiBLMShowOtherDetailsStatus(userId: widget.userId);
                        context.loaderOverlay.hide();

                        Navigator.push(context, MaterialPageRoute(builder: (context) => 
                          HomeBLMUserOtherDetails(
                              userId: widget.userId,
                              toggleBirthdate: result.showOtherDetailsStatusHideBirthdate,
                              toggleBirthplace: result.showOtherDetailsStatusHideBirthplace,
                              toggleAddress: result.showOtherDetailsStatusHideAddress,
                              toggleEmail: result.showOtherDetailsStatusHideEmail,
                              toggleNumber: result.showOtherDetailsStatusHidePhoneNumber,
                            ),
                          ),
                        );
                      },
                      title: Text('Other info', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
                      subtitle: Text('Optional informations you can share', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    ListTile(
                      onTap: () => {},
                      title: Text('Privacy Settings', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
                      subtitle: Text('Control what others see', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    const SizedBox(height: 20,),

                    MiscBLMButtonTemplate(
                      buttonText: 'Logout',
                      buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                      width: SizeConfig.screenWidth! / 2,
                      height: 45,
                      buttonColor: const Color(0xff04ECFF),
                      onPressed: () async{
                        bool logoutResult = await showDialog(
                          context: (context),
                          builder: (build) => MiscBLMConfirmDialog(
                            title: 'Log out',
                            content: 'Are you sure you want to log out from this account?',
                            confirmColor_1: Color(0xff000000),
                            confirmColor_2: Color(0xff888888),
                          ),
                        );

                        print('The logoutResult is $logoutResult');

                        if(logoutResult){
                          context.loaderOverlay.show();
                          bool result = await apiBLMLogout();
                          context.loaderOverlay.hide();

                          if(result){
                            Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                            Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
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
                      },
                    ),

                    const SizedBox(height: 20,),

                    Text('V.1.1.0', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xff888888),),),

                    Expanded(child: Container(),),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  Container(height: SizeConfig.screenHeight, color: const Color(0xffECF0F1),),

                  Container(
                    height: SizeConfig.screenHeight! / 2.5,
                    child: Stack(
                      children: [
                        CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

                        Positioned(
                          bottom: 50,
                          left: (SizeConfig.screenWidth! / 2) - 120,
                          child: GestureDetector(
                            onTap: () async{
                              bool getImage = await getProfileImage();

                              if(getImage){
                                context.loaderOverlay.show();
                                bool result = await apiBLMUpdateUserProfilePicture(image: profileImage, userId: widget.userId);
                                context.loaderOverlay.hide();

                                if(result){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Successfully updated the profile picture.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular',),),
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
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  child: ((){
                                    if(profileImage.path != ''){
                                      return CircleAvatar(
                                        radius: 120,
                                        backgroundColor: const Color(0xff888888),
                                        foregroundImage: AssetImage(profileImage.path),
                                      );
                                    }else if(profile.data!.showProfileInformationImage != ''){
                                      return CircleAvatar(
                                        radius: 120,
                                        backgroundColor: const Color(0xff888888),
                                        foregroundImage: NetworkImage(profile.data!.showProfileInformationImage),
                                      );
                                    }else{
                                      return CircleAvatar(
                                        radius: 120,
                                        backgroundColor: const Color(0xff888888),
                                        foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                      );
                                    }
                                  }()),
                                ),

                                Positioned(
                                  top: 0,
                                  right: 20,
                                  child: const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xff888888),
                                    child: const Icon(Icons.camera, size: 50, color: const Color(0xffffffff),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: (){
                          Navigator.of(context).popAndPushNamed('/home/blm');
                        },
                        icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 35,),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.screenHeight! / 2.5,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              profile.data!.showProfileInformationFirstName + ' ' + profile.data!.showProfileInformationLastName,
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.52, fontFamily: 'NexaBold', color: const Color(0xff000000),),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: Text(
                              profile.data!.showProfileInformationEmail,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                fontFamily: 'NexaRegular',
                                color: const Color(0xffBDC3C7),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }else if(profile.hasError){
            return MiscBLMErrorMessageTemplate();
          }else{
            return Container(
              height: SizeConfig.screenHeight,
              child: Center(
                child: Container(
                  child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,),
                  color: const Color(0xffffffff),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}