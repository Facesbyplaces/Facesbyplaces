import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
// import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-03-show-other-details-status.dart';
// import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-12-update-user-profile-picture.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-custom-drawings.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/UI/ui-01-get-started.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'home-settings-user-02-user-update-details.dart';
// import 'home-settings-user-03-change-password.dart';
// import 'home-settings-user-04-other-details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:badges/badges.dart';
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
  final picker = ImagePicker();
  File? profileImage;

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
            return Stack(
              children: [

                Container(height: SizeConfig.screenHeight, color: Color(0xffECF0F1),),

                Container(
                  height: SizeConfig.screenHeight! / 2.5,
                  child: Stack(
                    children: [

                      CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

                      // Positioned(
                      //   bottom: 20,
                      //   left: (SizeConfig.screenWidth! / 2) - 120,
                      //   child: Badge(
                      //     position: BadgePosition.topEnd(top: 5, end: 15),
                      //     animationDuration: Duration(milliseconds: 300),
                      //     animationType: BadgeAnimationType.fade,
                      //     badgeColor: Colors.grey,
                      //     badgeContent: Icon(Icons.camera, size: 50,),
                      //     child: GestureDetector(
                      //       onTap: () async{
                      //         bool getImage = await getProfileImage();

                      //         if(getImage){
                      //           context.showLoaderOverlay();
                      //           bool result = await apiBLMUpdateUserProfilePicture(image: profileImage, userId: userId);
                      //           context.hideLoaderOverlay();

                      //           if(result != true){
                      //             await showDialog(
                      //               context: context,
                      //               builder: (_) => 
                      //                 AssetGiffyDialog(
                      //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      //                 title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      //                 entryAnimation: EntryAnimation.DEFAULT,
                      //                 description: Text('Something went wrong. Please try again.',
                      //                   textAlign: TextAlign.center,
                      //                   style: TextStyle(),
                      //                 ),
                      //                 onlyOkButton: true,
                      //                 buttonOkColor: Colors.red,
                      //                 onOkButtonPressed: () {
                      //                   Navigator.pop(context, true);
                      //                 },
                      //               )
                      //             );
                      //           }else{
                      //             await showDialog(
                      //               context: context,
                      //               builder: (_) => 
                      //                 AssetGiffyDialog(
                      //                 image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      //                 title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      //                 entryAnimation: EntryAnimation.DEFAULT,
                      //                 description: Text('Successfully updated the profile picture.',
                      //                   textAlign: TextAlign.center,
                      //                   style: TextStyle(),
                      //                 ),
                      //                 onlyOkButton: true,
                      //                 buttonOkColor: Colors.green,
                      //                 onOkButtonPressed: () {
                      //                   Navigator.pop(context, true);
                      //                 },
                      //               )
                      //             );
                      //           }
                      //         }
                              
                      //       },
                      //       child: CircleAvatar(
                      //         radius: 120,
                      //         backgroundColor: Color(0xff888888),
                      //         backgroundImage: NetworkImage(profile.data!.showProfileInformationImage),
                      //         // backgroundImage: ((){
                      //         //   if(profileImage != null){
                      //         //     return AssetImage(profileImage.path);
                      //         //   }else if(profile.data.showProfileInformationImage != null && profile.data.showProfileInformationImage != ''){
                      //         //     return NetworkImage(profile.data.showProfileInformationImage);
                      //         //   }else{
                      //         //     return AssetImage('assets/icons/app-icon.png');
                      //         //   }
                      //         // }()),
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                              Navigator.of(context).popAndPushNamed('/home/blm');
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

                // SlidingUpPanel(
                //   maxHeight: SizeConfig.screenHeight! / 1.5,
                //   panel: SingleChildScrollView(
                //     physics: ClampingScrollPhysics(),
                //     padding: EdgeInsets.only(left: 50.0, right: 50.0),
                //     child: Column(
                //       children: [

                //         SizedBox(height: 80,),

                //         GestureDetector(
                //           onTap: (){
                //             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserUpdateDetails(userId: userId,)));
                //           },
                //           child: Container(
                //             height: 80,
                //             color: Color(0xffffffff),
                //             padding: EdgeInsets.only(left: 20.0, right: 20.0),
                //             child: Column(
                //               children: [
                //                 Expanded(
                //                   child: Align(
                //                     alignment: Alignment.bottomLeft,
                //                     child: Text('Update Details',
                //                       style: TextStyle(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.bold,
                //                         color: Color(0xff000000),
                //                       ),
                //                     ),
                //                   ),
                //                 ),

                //                 SizedBox(height: 10,),

                //                 Expanded(
                //                   child: Align(
                //                     alignment: Alignment.topLeft,
                //                     child: Text('Update your account details',
                //                       style: TextStyle(
                //                         fontSize: 14,
                //                         fontWeight: FontWeight.w300,
                //                         color: Color(0xffBDC3C7),
                //                       ),
                //                     ),
                //                   ),
                //                 ),

                //                 Divider(height: 20, color: Color(0xff888888),)
                //               ],
                //             ),
                //           ),
                //         ),

                //         GestureDetector(
                //           onTap: (){
                //             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: userId,)));
                //           },
                //           child: Container(
                //             height: 80,
                //             color: Color(0xffffffff),
                //             padding: EdgeInsets.only(left: 20.0, right: 20.0),
                //             child: Column(
                //               children: [
                //                 Expanded(
                //                   child: Align(
                //                     alignment: Alignment.bottomLeft,
                //                     child: Text('Password',
                //                       style: TextStyle(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.bold,
                //                         color: Color(0xff000000),
                //                       ),
                //                     ),
                //                   ),
                //                 ),

                //                 SizedBox(height: 10,),

                //                 Expanded(
                //                   child: Align(
                //                     alignment: Alignment.topLeft,
                //                     child: Text('Change your login password',
                //                       style: TextStyle(
                //                         fontSize: 14,
                //                         fontWeight: FontWeight.w300,
                //                         color: Color(0xffBDC3C7),
                //                       ),
                //                     ),
                //                   ),
                //                 ),

                //                 Divider(height: 20, color: Color(0xff888888),)
                //               ],
                //             ),
                //           ),
                //         ),

                //         GestureDetector(
                //           onTap: () async{
                //             context.showLoaderOverlay();
                //             APIBLMShowOtherDetailsStatus result = await apiBLMShowOtherDetailsStatus(userId: userId);
                //             context.hideLoaderOverlay();

                //             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserOtherDetails(userId: userId, toggleBirthdate: result.showOtherdetailsStatusHideBirthdate, toggleBirthplace: result.showOtherdetailsStatusHideBirthplace, toggleAddress: result.showOtherdetailsStatusHideAddress, toggleEmail: result.showOtherdetailsStatusHideEmail, toggleNumber: result.showOtherdetailsStatusHidePhoneNumber)));
                //           },
                //           child: Container(
                //             height: 80,
                //             color: Color(0xffffffff),
                //             padding: EdgeInsets.only(left: 20.0, right: 20.0),
                //             child: Column(
                //               children: [
                //                 Expanded(
                //                   child: Align(
                //                     alignment: Alignment.bottomLeft,
                //                     child: Text('Other Info',
                //                       style: TextStyle(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.bold,
                //                         color: Color(0xff000000),
                //                       ),
                //                     ),
                //                   ),
                //                 ),

                //                 SizedBox(height: 10,),

                //                 Expanded(
                //                   child: Align(
                //                     alignment: Alignment.topLeft,
                //                     child: Text('Optional informations you can share',
                //                       style: TextStyle(
                //                         fontSize: 14,
                //                         fontWeight: FontWeight.w300,
                //                         color: Color(0xffBDC3C7),
                //                       ),
                //                     ),
                //                   ),
                //                 ),

                //                 Divider(height: 20, color: Color(0xff888888),)
                //               ],
                //             ),
                //           ),
                //         ),

                //         Container(
                //           height: 80,
                //           color: Color(0xffffffff),
                //           padding: EdgeInsets.only(left: 20.0, right: 20.0),
                //           child: Column(
                //             children: [
                //               Expanded(
                //                 child: Align(
                //                   alignment: Alignment.bottomLeft,
                //                   child: Text('Privacy Settings',
                //                     style: TextStyle(
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.bold,
                //                       color: Color(0xff000000),
                //                     ),
                //                   ),
                //                 ),
                //               ),

                //               SizedBox(height: 10,),

                //               Expanded(
                //                 child: Align(
                //                   alignment: Alignment.topLeft,
                //                   child: Text('Control what others see',
                //                     style: TextStyle(
                //                       fontSize: 14,
                //                       fontWeight: FontWeight.w300,
                //                       color: Color(0xffBDC3C7),
                //                     ),
                //                   ),
                //                 ),
                //               ),

                //               Divider(height: 20, color: Color(0xff888888),),
                //             ]
                //           ),
                //         ),

                //         SizedBox(height: 10,),

                //         MiscBLMButtonTemplate(
                //           buttonText: 'Logout',
                //           buttonTextStyle: TextStyle(
                //             fontSize: 16, 
                //             fontWeight: FontWeight.bold, 
                //             color: Color(0xffffffff),
                //           ),
                //           width: SizeConfig.screenWidth! / 2,
                //           height: 45,
                //           onPressed: () async{

                //             bool logoutResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

                //             if(logoutResult){
                //               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UIGetStarted()), (route) => false);
                //             }

                //           }, 
                //           buttonColor: Color(0xff04ECFF),
                //         ),

                //         SizedBox(height: 20,),
                        
                //         Text('V.1.1.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff888888),),),

                //         SizedBox(height: 20,),

                //       ],
                //     ),
                //   ),
                //   collapsed: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(50.0),
                //       ),
                //     ),
                //   ),
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(50.0),
                //   ),
                // ),

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