import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-01-logout.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-03-show-other-details-status.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-12-update-user-profile-picture.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/ui-01-get-started.dart';
import 'home-settings-user-regular-02-user-update-details.dart';
import 'home-settings-user-regular-03-change-password.dart';
import 'home-settings-user-regular-04-other-details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_slide/we_slide.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomeRegularUserProfileDetails extends StatefulWidget{
  final int userId;
  const HomeRegularUserProfileDetails({required this.userId});
  
  HomeRegularUserProfileDetailsState createState() => HomeRegularUserProfileDetailsState(userId: userId);
}

class HomeRegularUserProfileDetailsState extends State<HomeRegularUserProfileDetails>{
  final int userId;
  HomeRegularUserProfileDetailsState({required this.userId});

  Future<APIRegularShowProfileInformation>? showProfile;
  WeSlideController controller = WeSlideController();
  final picker = ImagePicker();
  File profileImage = File('');

  Future<APIRegularShowProfileInformation> getProfileInformation() async{
    return await apiRegularShowProfileInformation();
  }

  Future<bool> getProfileImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        profileImage = File(pickedFile.path);
      });
      return true;
    }else{
      return false;
    }
  }

  void initState(){
    super.initState();
    showProfile = getProfileInformation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: FutureBuilder<APIRegularShowProfileInformation>(
        future: showProfile,
        builder: (context, profile){
          if(profile.hasData){
            return WeSlide(
              controller: controller,
              panelMaxSize: SizeConfig.screenHeight! / 1.5,
              // panelBackground: Color(0xffECF0F1),
              backgroundColor: const Color(0xffECF0F1),
              panel: Container(
                height: SizeConfig.screenHeight! / 1.5,
                padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                decoration: const BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(50.0),
                  ),
                ),
                child: Column(
                  children: [

                    Expanded(child: Container(),),

                    ListTile(
                      onTap: (){
                        print('The user id is $userId');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserUpdateDetails(userId: userId,)));
                      },
                      title: const Text('Update Details', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                      subtitle: const Text('Update your account details', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserChangePassword(userId: userId,)));
                      },
                      title: const Text('Password', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                      subtitle: const Text('Change your login password', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    ListTile(
                      onTap: () async{
                        context.loaderOverlay.show();
                        APIRegularShowOtherDetailsStatus result = await apiRegularShowOtherDetailsStatus(userId: userId);
                        context.loaderOverlay.hide();

                        Navigator.push(context, MaterialPageRoute(builder: (context) => 
                        HomeRegularUserOtherDetails(
                          userId: userId, 
                          toggleBirthdate: result.showOtherDetailsStatusHideBirthdate, 
                          toggleBirthplace: result.showOtherDetailsStatusHideBirthplace, 
                          toggleAddress: result.showOtherDetailsStatusHideAddress, 
                          toggleEmail: result.showOtherDetailsStatusHideEmail, 
                          toggleNumber: result.showOtherDetailsStatusHidePhoneNumber)));
                      },
                      title: const Text('Other info', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                      subtitle: const Text('Optional informations you can share', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    ListTile(
                      onTap: () => {},
                      title: const Text('Privacy Settings', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                      subtitle: const Text('Control what others see', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                    ),

                    const Divider(height: 20, color: const Color(0xff888888),),

                    const SizedBox(height: 20,),

                    MiscRegularButtonTemplate(
                      buttonText: 'Logout',
                      buttonTextStyle: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: const Color(0xffffffff),
                      ),
                      width: SizeConfig.screenWidth! / 2,
                      height: 45,
                      onPressed: () async{
                        bool logoutResult = await showDialog(context: (context), builder: (build) => const MiscRegularConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: const Color(0xff000000), confirmColor_2: const Color(0xff888888),));

                        print('The logoutResult is $logoutResult');

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
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: const Text('Something went wrong. Please try again.',
                                  textAlign: TextAlign.center,
                                ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            );
                          }
                        }
                      },
                      buttonColor: const Color(0xff04ECFF),
                    ),

                    const SizedBox(height: 20,),
                    
                    const Text('V.1.1.0', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff888888),),),

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
                        CustomPaint(size: Size.infinite, painter: MiscRegularCurvePainter(),),

                        Positioned(
                          bottom: 50,
                          left: (SizeConfig.screenWidth! / 2) - 120,
                          child: GestureDetector(
                            onTap: () async{
                              bool getImage = await getProfileImage();

                              if(getImage){
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateUserProfilePicture(image: profileImage, userId: userId);
                                context.loaderOverlay.hide();

                                if(result){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Successfully updated the profile picture.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                profileImage.path != ''
                                ? CircleAvatar(
                                  radius: 120,
                                  backgroundColor: const Color(0xff888888),
                                  backgroundImage: AssetImage(profileImage.path),
                                )
                                : CircleAvatar(
                                  radius: 120,
                                  backgroundColor: const Color(0xff888888),
                                  backgroundImage: NetworkImage(profile.data!.showProfileInformationImage),
                                ),
                                const Positioned(
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
                          Navigator.of(context).popAndPushNamed('/home/regular');
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
                            child: Text(profile.data!.showProfileInformationFirstName + ' ' + profile.data!.showProfileInformationLastName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: Text(profile.data!.showProfileInformationEmail,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff000000),
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
            return const MiscRegularErrorMessageTemplate();
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
          }
        },
      ),
    );
  }
}