import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-01-logout.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-03-show-other-details-status.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-12-update-user-profile-picture.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_slide/we_slide.dart';
import 'package:flutter/material.dart';
import '../../../ui-01-get-started.dart';
import 'home-settings-user-blm-02-user-update-details.dart';
import 'home-settings-user-blm-03-change-password.dart';
import 'home-settings-user-blm-04-other-details.dart';
import 'dart:io';

class HomeBLMUserProfileDetails extends StatefulWidget{
  final int userId;
  HomeBLMUserProfileDetails({required this.userId});
  
  HomeBLMUserProfileDetailsState createState() => HomeBLMUserProfileDetailsState(userId: userId);
}

class HomeBLMUserProfileDetailsState extends State<HomeBLMUserProfileDetails>{
  final int userId;
  HomeBLMUserProfileDetailsState({required this.userId});

  Future<APIBLMShowProfileInformation>? showProfile;
  WeSlideController controller = WeSlideController();
  final picker = ImagePicker();
  File profileImage = File('');

  Future<APIBLMShowProfileInformation> getProfileInformation() async{
    return await apiBLMShowProfileInformation();
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
      body: FutureBuilder<APIBLMShowProfileInformation>(
        future: showProfile,
        builder: (context, profile){
          if(profile.hasData){
            return WeSlide(
              controller: controller,
              panelMaxSize: SizeConfig.screenHeight! / 1.5,
              panelBackground: Color(0xffECF0F1),
              panel: Container(
                height: SizeConfig.screenHeight! / 1.5,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Column(
                    children: [

                      SizedBox(height: 50,),

                      ListTile(
                        onTap: (){
                          print('The user id is $userId');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserUpdateDetails(userId: userId,)));
                        },
                        title: Text('Update Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                        subtitle: Text('Update your account details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                      ),

                      Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: userId,)));
                        },
                        title: Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                        subtitle: Text('Change your login password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                      ),

                      Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        onTap: () async{
                          context.showLoaderOverlay();
                          APIBLMShowOtherDetailsStatus result = await apiBLMShowOtherDetailsStatus(userId: userId);
                          context.hideLoaderOverlay();

                          Navigator.push(context, MaterialPageRoute(builder: (context) => 
                          HomeBLMUserOtherDetails(
                            userId: userId, 
                            toggleBirthdate: result.showOtherDetailsStatusHideBirthdate, 
                            toggleBirthplace: result.showOtherDetailsStatusHideBirthplace, 
                            toggleAddress: result.showOtherDetailsStatusHideAddress, 
                            toggleEmail: result.showOtherDetailsStatusHideEmail, 
                            toggleNumber: result.showOtherDetailsStatusHidePhoneNumber)));
                        },
                        title: Text('Other info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                        subtitle: Text('Optional informations you can share', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                      ),

                      Divider(height: 20, color: Color(0xff888888),),

                      ListTile(
                        onTap: (){
                          
                        },
                        title: Text('Privacy Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                        subtitle: Text('Control what others see', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                      ),

                      Divider(height: 20, color: Color(0xff888888),),

                      SizedBox(height: 20,),

                      MiscBLMButtonTemplate(
                        buttonText: 'Logout',
                        buttonTextStyle: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2,
                        height: 45,
                        onPressed: () async{

                          bool logoutResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

                          print('The logoutResult is $logoutResult');

                          if(logoutResult){
                            context.showLoaderOverlay();
                            bool result = await apiBLMLogout();
                            context.hideLoaderOverlay();

                            if(result){
                              Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                              Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                            }else{
                              await showOkAlertDialog(
                                context: context,
                                title: 'Error',
                                message: 'Something went wrong. Please try again.',
                              );
                            }
                          }
                        },
                        buttonColor: Color(0xff04ECFF),
                      ),

                      SizedBox(height: 20,),
                      
                      Text('V.1.1.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff888888),),),

                      SizedBox(height: 20,),

                    ],
                  ),
                ),
              ),
              body: Stack(
                children: [

                  Container(height: SizeConfig.screenHeight, color: Color(0xffECF0F1),),

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
                                context.showLoaderOverlay();
                                bool result = await apiBLMUpdateUserProfilePicture(image: profileImage, userId: userId);
                                context.hideLoaderOverlay();

                                if(result){
                                  await showOkAlertDialog(
                                    context: context,
                                    title: 'Success',
                                    message: 'Successfully updated the profile picture.',
                                  );
                                }else{
                                  await showOkAlertDialog(
                                    context: context,
                                    title: 'Error',
                                    message: 'Something went wrong. Please try again.',
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
                                  backgroundColor: Color(0xff888888),
                                  backgroundImage: AssetImage(profileImage.path),
                                )
                                : CircleAvatar(
                                  radius: 120,
                                  backgroundColor: Color(0xff888888),
                                  backgroundImage: NetworkImage(profile.data!.showProfileInformationImage),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 20,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xff888888),
                                    child: Icon(Icons.camera, size: 50, color: Color(0xffffffff),),
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
                      padding: EdgeInsets.only(left: 20),
                      child: IconButton(
                        onPressed: (){
                          Navigator.of(context).popAndPushNamed('/home/blm');
                        },
                        icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
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
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          Center(
                            child: Text(profile.data!.showProfileInformationEmail,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),

                          SizedBox(height: 40,),

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
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        },
      ),
    );
  }
}