import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-01-logout.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-03-show-other-details-status.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-12-update-user-profile-picture.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'home-settings-user-regular-02-user-update-details.dart';
import 'home-settings-user-regular-03-change-password.dart';
import 'home-settings-user-regular-04-other-details.dart';
import 'package:facesbyplaces/UI/ui-01-get-started.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
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
            return Stack(
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
                        child: Badge(
                          position: BadgePosition.topEnd(top: 5, end: 15),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.fade,
                          badgeColor: Colors.grey,
                          badgeContent: Icon(Icons.camera, size: 50),
                          child: GestureDetector(
                            onTap: () async{

                              bool getImage = await getProfileImage();

                              if(getImage){
                                context.showLoaderOverlay();
                                bool result = await apiRegularUpdateUserProfilePicture(image: profileImage, userId: userId);
                                context.hideLoaderOverlay();

                                if(result != true){
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
                                }else{
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
                                      buttonOkColor: Colors.green,
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              }
                              
                            },
                            child: CircleAvatar(
                              radius: 120,
                              backgroundColor: Color(0xff888888),
                              backgroundImage: NetworkImage(profile.data!.showProfileInformationImage),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          alignment: Alignment.centerLeft,
                            child: IconButton(
                            onPressed: (){
                              Navigator.of(context).popAndPushNamed('/home/regular');
                            },
                            icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,), 
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
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

                SlidingUpPanel(
                  maxHeight: SizeConfig.screenHeight! / 1.5,
                  panel: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Column(
                      children: [

                        SizedBox(height: 80,),

                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserUpdateDetails(userId: userId,)));
                          },
                          child: Container(
                            height: 80,
                            color: Color(0xffffffff),
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('Update Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10,),

                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Update your account details',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xffBDC3C7),
                                      ),
                                    ),
                                  ),
                                ),

                                Divider(height: 20, color: Color(0xff888888),)
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserChangePassword(userId: userId,)));
                          },
                          child: Container(
                            height: 80,
                            color: Color(0xffffffff),
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('Password',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10,),

                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Change your login password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xffBDC3C7),
                                      ),
                                    ),
                                  ),
                                ),

                                Divider(height: 20, color: Color(0xff888888),)
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async{
                            context.showLoaderOverlay();
                            APIRegularShowOtherDetailsStatus result = await apiRegularShowOtherDetailsStatus(userId: userId);
                            context.hideLoaderOverlay();

                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            HomeRegularUserOtherDetails(
                              userId: userId, 
                              toggleBirthdate: result.showOtherDetailsStatusHideBirthdate, 
                              toggleBirthplace: result.showOtherDetailsStatusHideBirthplace, 
                              toggleAddress: result.showOtherDetailsStatusHideAddress, 
                              toggleEmail: result.showOtherDetailsStatusHideEmail, 
                              toggleNumber: result.showOtherDetailsStatusHidePhoneNumber)));
                          },
                          child: Container(
                            height: 80,
                            color: Color(0xffffffff),
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('Other Info',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10,),

                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Optional informations you can share',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xffBDC3C7),
                                      ),
                                    ),
                                  ),
                                ),

                                Divider(height: 20, color: Color(0xff888888),)
                              ],
                            ),
                          ),
                        ),

                        Container(
                          height: 80,
                          color: Color(0xffffffff),
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text('Privacy Settings',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10,),

                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Control what others see',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffBDC3C7),
                                    ),
                                  ),
                                ),
                              ),

                              Divider(height: 20, color: Color(0xff888888),),
                            ]
                          ),
                        ),

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

                            if(logoutResult){
                              context.showLoaderOverlay();
                              bool result = await apiRegularLogout();

                              GoogleSignIn googleSignIn = GoogleSignIn(
                                scopes: [
                                  'profile',
                                  'email',
                                  'openid'
                                ],
                              );
                              await googleSignIn.signOut();

                              FacebookLogin fb = FacebookLogin();
                              await fb.logOut();

                              context.hideLoaderOverlay();

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

                        SizedBox(height: 20,),

                      ],
                    ),
                  ),
                  collapsed: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                      ),
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                  ),
                ),

              ],
            );
          }else if(profile.hasError){
            return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),));
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        },
      ),
    );
  }
}