import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_01_logout.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_02_show_user_information.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_03_show_other_details_status.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_12_update_user_profile_picture.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_14_check_account.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_settings_user_blm_02_user_update_details.dart';
import 'home_settings_user_blm_03_change_password.dart';
import 'home_settings_user_blm_04_other_details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import '../../../ui-01-get-started.dart';
import 'package:we_slide/we_slide.dart';
import 'package:flutter/material.dart';
import 'package:misc/misc.dart';
import 'dart:io';

class HomeBLMUserProfileDetails extends StatefulWidget{
  final int userId;
  const HomeBLMUserProfileDetails({Key? key, required this.userId}) : super(key: key);

  @override
  HomeBLMUserProfileDetailsState createState() => HomeBLMUserProfileDetailsState();
}

class HomeBLMUserProfileDetailsState extends State<HomeBLMUserProfileDetails>{
  ValueNotifier<File> profileImage = ValueNotifier<File>(File(''));
  Future<APIBLMShowProfileInformation>? showProfile;
  WeSlideController controller = WeSlideController();
  final picker = ImagePicker();

  Future<APIBLMShowProfileInformation> getProfileInformation() async{
    return await apiBLMShowProfileInformation();
  }

  Future<bool> getProfileImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null){
      profileImage.value = File(pickedFile.path);
      return true;
    }else{
      return false;
    }
  }

  @override
  void initState(){
    super.initState();
    showProfile = getProfileInformation();
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: profileImage,
      builder: (_, File profileImageListener, __) => Scaffold(
        body: FutureBuilder<APIBLMShowProfileInformation>(
          future: showProfile,
          builder: (context, profile){
            if(profile.hasData){
              return WeSlide(
                controller: controller,
                panelMaxSize: SizeConfig.screenHeight! / 1.5,
                backgroundColor: const Color(0xffECF0F1),
                panel: Container(
                  decoration: const BoxDecoration(color: Color(0xffffffff), borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0),),),
                  padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                  height: SizeConfig.screenHeight! / 1.5,
                  child: Column(
                    children: [
                      Expanded(child: Container(),),

                      ListTile(
                        title: const Text('Update Details', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                        subtitle: const Text('Update your account details', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserUpdateDetails(userId: widget.userId,)));
                        },
                      ),

                      const Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        title: const Text('Password', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                        subtitle: const Text('Change your login password', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        onTap: () async{
                          final sharedPrefs = await SharedPreferences.getInstance();
                          bool socialAppSession = sharedPrefs.getBool('blm-social-app-session') ?? false;
                          context.loaderOverlay.show();
                          bool checkAccount = await apiBLMCheckAccount(email: profile.data!.showProfileInformationEmail).onError((error, stackTrace){
                            context.loaderOverlay.hide();
                            showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                            throw Exception('$error');
                          });
                          context.loaderOverlay.hide();

                          if(socialAppSession == true && checkAccount == false){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: widget.userId, isAddPassword: true,)));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: widget.userId, isAddPassword: false,)));
                          }
                        },
                      ),

                      const Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        title: const Text('Other info', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                        subtitle: const Text('Optional informations you can share', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        onTap: () async{
                          context.loaderOverlay.show();
                          APIBLMShowOtherDetailsStatus result = await apiBLMShowOtherDetailsStatus(userId: widget.userId);
                          context.loaderOverlay.hide();

                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserOtherDetails(userId: widget.userId, toggleBirthdate: result.showOtherDetailsStatusHideBirthdate, toggleBirthplace: result.showOtherDetailsStatusHideBirthplace, toggleAddress: result.showOtherDetailsStatusHideAddress, toggleEmail: result.showOtherDetailsStatusHideEmail, toggleNumber: result.showOtherDetailsStatusHidePhoneNumber,),),);
                        },
                      ),

                      const Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        title: const Text('Privacy Settings', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                        subtitle: const Text('Control what others see', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        onTap: () => {},
                      ),

                      const Divider(height: 20, color: Color(0xff888888),),

                      const SizedBox(height: 20,),

                      MiscButtonTemplate(
                        buttonText: 'Logout',
                        buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                        buttonColor: const Color(0xff04ECFF),
                        width: SizeConfig.screenWidth! / 2,
                        height: 45,
                        onPressed: () async{
                          bool logoutResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Log out', content: 'Are you sure you want to logout from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),),);

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
                                  description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                        },
                      ),

                      const SizedBox(height: 20,),

                      const Text('V.1.1.0', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff888888),),),

                      Expanded(child: Container(),),
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    Container(height: SizeConfig.screenHeight, color: const Color(0xffECF0F1),),

                    SizedBox(
                      height: SizeConfig.screenHeight! / 2.5,
                      child: Stack(
                        children: [
                          CustomPaint(size: Size.infinite, painter: MiscCurvePainter(),),

                          GestureDetector( // BACKGROUND IMAGE FOR ZOOMING IN
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              alignment: Alignment.bottomCenter,
                              child: profile.data!.showProfileInformationImage != ''
                              ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3,),
                                ),
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: const Color(0xff888888),
                                  foregroundImage: NetworkImage(profile.data!.showProfileInformationImage),
                                ),
                              )
                              : const CircleAvatar(
                                radius: 100, 
                                backgroundColor: Color(0xff888888), 
                                foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                              ),
                            ),
                            onTap: () async{
                              bool getImage = await getProfileImage();

                              if(getImage){
                                context.loaderOverlay.show();
                                bool result = await apiBLMUpdateUserProfilePicture(image: profileImage.value);
                                context.loaderOverlay.hide();

                                if(result){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      description: const Text('Successfully updated the profile picture.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                      title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      entryAnimation: EntryAnimation.DEFAULT,
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
                                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                      title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
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
                            },
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                          onPressed: (){
                            Navigator.of(context).popAndPushNamed('/home/blm');
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.screenHeight! / 2.5,
                      child: SizedBox(
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [
                            Center(child: Text(profile.data!.showProfileInformationFirstName + ' ' + profile.data!.showProfileInformationLastName, style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff000000),),),),

                            const SizedBox(height: 20),

                            Center(child: Text(profile.data!.showProfileInformationEmail, style: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),),

                            const SizedBox(height: 40,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }else if(profile.hasError){
              return const MiscErrorMessageTemplate();
            }else{
              return SizedBox(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
            }
          },
        ),
      ),
    );
  }
}