import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_01_logout.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_02_show_user_information.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api_settings_user_regular_03_show_other_details_status.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api_settings_user_regular_12_update_user_profile_picture.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api_settings_user_regular_14_check_account.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/ui_01_get_started.dart';
import 'home_settings_user_regular_02_user_update_details.dart';
import 'home_settings_user_regular_03_change_password.dart';
import 'home_settings_user_regular_04_other_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_slide/we_slide.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:misc/misc.dart';
import 'dart:io';

class HomeRegularUserProfileDetails extends StatefulWidget{
  final int userId;
  const HomeRegularUserProfileDetails({Key? key, required this.userId}) : super(key: key);

  @override
  HomeRegularUserProfileDetailsState createState() => HomeRegularUserProfileDetailsState();
}

class HomeRegularUserProfileDetailsState extends State<HomeRegularUserProfileDetails>{
  ValueNotifier<File> profileImage = ValueNotifier<File>(File(''));
  Future<APIRegularShowProfileInformation>? showProfile;
  WeSlideController controller = WeSlideController();
  final picker = ImagePicker();

  Future<APIRegularShowProfileInformation> getProfileInformation() async{
    return await apiRegularShowProfileInformation();
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
        body: FutureBuilder<APIRegularShowProfileInformation>(
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
                  decoration: const BoxDecoration(color: Color(0xffffffff), borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0),),),
                  child: Column(
                    children: [
                      Expanded(child: Container(),),

                      ListTile(
                        title: const Text('Update Details', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                        subtitle: const Text('Update your account details', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserUpdateDetails(userId: widget.userId,)));
                        },
                      ),

                      const Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        title: const Text('Password', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                        subtitle: const Text('Change your login password', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        onTap: () async{
                          final sharedPrefs = await SharedPreferences.getInstance();
                          bool socialAppSession = sharedPrefs.getBool('regular-social-app-session') ?? false;
                          context.loaderOverlay.show();
                          bool checkAccount = await apiRegularCheckAccount(email: profile.data!.showProfileInformationEmail).onError((error, stackTrace){
                            context.loaderOverlay.hide();
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Error',
                                description: 'Error: $error.',
                                okButtonColor: const Color(0xfff44336), // RED
                                includeOkButton: true,
                              ),
                            );
                            throw Exception('$error');
                          });
                          context.loaderOverlay.hide();

                          if(socialAppSession == true && checkAccount == false){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserChangePassword(userId: widget.userId, isAddPassword: true,)));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserChangePassword(userId: widget.userId, isAddPassword: false,)));
                          }
                        },
                      ),

                      const Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        title: const Text('Other info', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                        subtitle: const Text('Optional informations you can share', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        onTap: () async{
                          context.loaderOverlay.show();
                          APIRegularShowOtherDetailsStatus result = await apiRegularShowOtherDetailsStatus(userId: widget.userId);
                          context.loaderOverlay.hide();

                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomeRegularUserOtherDetails(userId: widget.userId, toggleBirthdate: result.showOtherDetailsStatusHideBirthdate, toggleBirthplace: result.showOtherDetailsStatusHideBirthplace, toggleAddress: result.showOtherDetailsStatusHideAddress, toggleEmail: result.showOtherDetailsStatusHideEmail, toggleNumber: result.showOtherDetailsStatusHidePhoneNumber,),),);
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
                        buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                        buttonColor: const Color(0xff04ECFF),
                        width: SizeConfig.screenWidth! / 2,
                        buttonText: 'Logout',
                        height: 50,
                        onPressed: () async{
                          bool logoutResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Log out', content: 'Are you sure you want to logout from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),),);

                          if(logoutResult){
                            context.loaderOverlay.show();
                            bool result = await apiRegularLogout();
                            context.loaderOverlay.hide();

                            if(result){
                              Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                              Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                            }else{
                              await showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: 'Error',
                                  description: 'Something went wrong. Please try again.',
                                  okButtonColor: const Color(0xfff44336), // RED
                                  includeOkButton: true,
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
                body: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Stack(
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
                                  border: Border.all(color: const Color(0xffffffff), width: 3,),
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
                                bool result = await apiRegularUpdateUserProfilePicture(image: profileImage.value);
                                context.loaderOverlay.hide();

                                if(result){
                                  await showDialog(
                                    context: context,
                                    builder: (context) => CustomDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: 'Success',
                                      description: 'Successfully updated the profile picture.',
                                      okButtonColor: const Color(0xff4caf50), // GREEN
                                      includeOkButton: true,
                                    ),
                                  );
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (context) => CustomDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: 'Error',
                                      description: 'Something went wrong. Please try again.',
                                      okButtonColor: const Color(0xfff44336), // RED
                                      includeOkButton: true,
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
                          icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
                          onPressed: (){
                            Navigator.of(context).popAndPushNamed('/home/regular');
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
                ),
              );
            }else if(profile.hasError){
              return const MiscErrorMessageTemplate();
            }else{
              return const Center(child: CustomLoader(),);
            }
          },
        ),
      ),
    );
  }
}