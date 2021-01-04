import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-04-show-other-details.dart';
import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-01-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-custom-drawings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeBLMUserProfile extends StatefulWidget{
  final int userId;
  HomeBLMUserProfile({this.userId});

  HomeBLMUserProfileState createState() => HomeBLMUserProfileState(userId: userId);
}

class HomeBLMUserProfileState extends State<HomeBLMUserProfile>{
  final int userId;
  HomeBLMUserProfileState({this.userId});

  Future showProfile;
  Future showDetails;

  void initState(){
    super.initState();
    showDetails = getOtherDetails(userId);
    showProfile = getProfileInformation(userId);
  }

  Future<APIBLMShowOtherDetails> getOtherDetails(int userId) async{
    return await apiBLMShowOtherDetails(userId);
  }

  Future<APIBLMShowUserInformation> getProfileInformation(int userId) async{
    return await apiBLMShowUserInformation(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Scaffold(
      body: FutureBuilder<APIBLMShowUserInformation>(
        future: showProfile,
        builder: (context, profile){
          if(profile.hasData){
            return Stack(
              children: [

                Container(height: SizeConfig.screenHeight, color: Color(0xffffffff),),

                Container(
                  height: SizeConfig.screenHeight / 2.5,
                  child: Stack(
                    children: [

                      CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

                      Container(
                        padding: EdgeInsets.only(bottom: 20.0),
                        alignment: Alignment.bottomCenter,
                        // child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 15, backgroundImage: AssetImage('assets/icons/profile1.png'),)
                        child: CircleAvatar(radius: ScreenUtil().setHeight(100), backgroundColor: Color(0xff888888), backgroundImage: AssetImage('assets/icons/app-icon.png'))

                        // child: CircleAvatar(radius: ScreenUtil().setHeight(100), backgroundColor: Color(0xff888888), backgroundImage: profileImage != null ? NetworkImage(profileImage) : AssetImage('assets/icons/app-icon.png')),
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
                              // Navigator.popUntil(context, ModalRoute.withName('/home/blm'));
                              Navigator.pop(context);
                            },
                            // icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,),
                            icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: ScreenUtil().setHeight(30)), 
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.zero,
                            onPressed: (){},
                            icon: Icon(Icons.more_vert, color: Color(0xffffffff), size: ScreenUtil().setHeight(30)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: SizeConfig.screenHeight / 2.5,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      children: [
                        Text('${profile.data.firstName + ' ' + profile.data.lastName}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Text('${profile.data.email}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                        Text('About',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                            fontWeight: FontWeight.bold,
                            color: Color(0xff04ECFF),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                        FutureBuilder<APIBLMShowOtherDetails>(
                          future: showDetails,
                          builder: (context, about){
                            if(profile.hasData){
                              return Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(Icons.star_outline, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                              SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                              Text('Birthdate',
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: Color(0xffBDC3C7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: about.data.birthdate != null && about.data.birthdate != ''
                                          ? Text('${about.data.birthdate}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          )
                                          : Text('',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(Icons.place, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                              SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                              Text('Birthplace',
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: Color(0xffBDC3C7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: about.data.birthplace != null && about.data.birthplace != ''
                                          ? Text('${about.data.birthplace}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          )
                                          : Text('',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(Icons.home, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                              SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                              Text('Home Address',
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: Color(0xffBDC3C7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: about.data.address != null && about.data.address != ''
                                          ? Text('${about.data.address}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          )
                                          : Text('',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(Icons.email, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                              SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                              Text('Email Address',
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: Color(0xffBDC3C7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: about.data.email != null && about.data.email != ''
                                          ? Text('${about.data.email}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          )
                                          : Text('',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(Icons.phone, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                              SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                              Text('Contact Number',
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                  color: Color(0xffBDC3C7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: about.data.phoneNumber != null && about.data.phoneNumber != ''
                                          ? Text('${about.data.phoneNumber}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          )
                                          : Text('',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              );
                            }else if(profile.hasError){
                              return Container(child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
                            }else{
                              return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                MiscBLMUserProfileDraggableSwitchTabs(),

              ],
            );
          }else if(profile.hasError){
            return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        }
      ),
    );
  }
}