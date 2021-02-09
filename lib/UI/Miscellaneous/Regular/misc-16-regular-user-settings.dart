import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-02-user-update-details.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-03-change-password.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-04-other-details.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-01-logout.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-03-show-other-details-status.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import '../../ui-01-get-started.dart';
import 'misc-07-regular-button.dart';
import 'misc-02-regular-dialog.dart';

class MiscRegularUserProfileDetailsDraggable extends StatefulWidget {
  final int userId;
  MiscRegularUserProfileDetailsDraggable({this.userId});

  @override
  MiscRegularUserProfileDetailsDraggableState createState() => MiscRegularUserProfileDetailsDraggableState(userId: userId);
}

class MiscRegularUserProfileDetailsDraggableState extends State<MiscRegularUserProfileDetailsDraggable> {
  final int userId;
  MiscRegularUserProfileDetailsDraggableState({this.userId});

  double height;
  Offset position;
  int currentIndex = 0;
  List<Widget> children;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: draggable(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          if(offset.dy > 10 && offset.dy < (SizeConfig.screenHeight - 100)){
            setState(() {
              position = offset;
            });
          }
        },
        child: draggable(),
        childWhenDragging: Container(),
        axis: Axis.vertical,
      ),
    );
  }

  draggable(){
    return Material(
      color: Colors.transparent,
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
        ),
        child: Column(
          children: [

            // SizedBox(height: SizeConfig.blockSizeVertical * 10,),
            SizedBox(height: 80,),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserUpdateDetails(userId: userId,)));
              },
              child: Container(
                // height: SizeConfig.blockSizeVertical * 10,
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
                            // fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    // SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                    SizedBox(height: 10,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Update your account details',
                          style: TextStyle(
                            // fontSize: SizeConfig.safeBlockHorizontal * 3.5,
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
                // height: SizeConfig.blockSizeVertical * 10,
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
                            // fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                            // fontSize: SizeConfig.safeBlockHorizontal * 3.5,
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
                // height: SizeConfig.blockSizeVertical * 10,
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
                            // fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    // SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                    SizedBox(height: 10,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Optional informations you can share',
                          style: TextStyle(
                            // fontSize: SizeConfig.safeBlockHorizontal * 3.5,
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
              // height: SizeConfig.blockSizeVertical * 10,
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
                          // fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                  SizedBox(height: 10,),

                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Control what others see',
                        style: TextStyle(
                          // fontSize: SizeConfig.safeBlockHorizontal * 3.5,
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

            Expanded(child: Container(),),

            MiscRegularButtonTemplate(
              buttonText: 'Logout',
              buttonTextStyle: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Color(0xffffffff),
              ),
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
              // width: SizeConfig.screenWidth / 2, 
              // height: SizeConfig.blockSizeVertical * 7, 
              width: 150,
              height: 45,
              buttonColor: Color(0xff04ECFF),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),
            
            Text('V.1.1.0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff888888),),),

            Expanded(child: Container(),),

          ],
        ),
      ),
    );
  }
}
