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
  HomeRegularUserProfileDetails({required this.userId});
  
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
              backgroundColor: Color(0xffECF0F1),
              panel: Container(
                height: SizeConfig.screenHeight! / 1.5,
                padding: EdgeInsets.only(left: 50.0, right: 50.0),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
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
                      title: Text('Update Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                      subtitle: Text('Update your account details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                    ),

                    Divider(height: 20, color: Color(0xff888888),),

                    ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserChangePassword(userId: userId,)));
                      },
                      title: Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                      subtitle: Text('Change your login password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                    ),

                    Divider(height: 20, color: Color(0xff888888),),

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

                    MiscRegularButtonTemplate(
                      buttonText: 'Logout',
                      buttonTextStyle: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xffffffff),
                      ),
                      width: SizeConfig.screenWidth! / 2,
                      height: 45,
                      onPressed: () async{

                        bool logoutResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

                        print('The logoutResult is $logoutResult');

                        if(logoutResult){
                          context.loaderOverlay.show();
                          bool result = await apiRegularLogout();
                          context.loaderOverlay.hide();

                          if(result){
                            Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                            Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                          }else{
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Something went wrong. Please try again.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                                onlyOkButton: true,
                                buttonOkColor: Colors.red,
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            );
                          }
                        }
                      },
                      buttonColor: Color(0xff04ECFF),
                    ),

                    SizedBox(height: 20,),
                    
                    Text('V.1.1.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff888888),),),

                    Expanded(child: Container(),),

                  ],
                ),
              ),
              body: Stack(
                children: [

                  Container(height: SizeConfig.screenHeight, color: Color(0xffECF0F1),),

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
                                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Successfully updated the profile picture.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
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
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: Colors.red,
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
                          Navigator.of(context).popAndPushNamed('/home/regular');
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
            return MiscRegularErrorMessageTemplate();
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        },
      ),
    );
  }
}