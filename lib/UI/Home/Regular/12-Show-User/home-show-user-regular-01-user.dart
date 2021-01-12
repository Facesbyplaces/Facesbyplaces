import 'package:facesbyplaces/API/Regular/13-Show-User/api-show-user-regular-01-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-17-regular-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-21-regular-user-details.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeRegularUserProfile extends StatefulWidget{
  final int userId;
  HomeRegularUserProfile({this.userId});

  HomeRegularUserProfileState createState() => HomeRegularUserProfileState(userId: userId);
}

class HomeRegularUserProfileState extends State<HomeRegularUserProfile>{
  final int userId;
  HomeRegularUserProfileState({this.userId});

  Future<APIRegularShowUserInformation> showProfile;

  Future<APIRegularShowUserInformation> getProfileInformation() async{
    return await apiRegularShowUserInformation(userId: userId);
  }

  void initState(){
    super.initState();
    showProfile = getProfileInformation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Scaffold(
      body: FutureBuilder<APIRegularShowUserInformation>(
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

                      CustomPaint(size: Size.infinite, painter: MiscRegularCurvePainter(),),

                      Container(
                        padding: EdgeInsets.only(bottom: 20.0),
                        alignment: Alignment.bottomCenter,
                        child: CircleAvatar(radius: ScreenUtil().setHeight(100), backgroundColor: Color(0xff888888), backgroundImage: profile.data.image != null ? NetworkImage(profile.data.image) : AssetImage('assets/icons/app-icon.png')),
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
                              Navigator.pop(context);
                            },
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
                        Text(
                          '${profile.data.firstName + ' ' + profile.data.lastName}',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Text('${profile.data.emailAddress}',
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

                        Padding(
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
                                    child: Text('${profile.data.birthdate}',
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
                                    child: Text('${profile.data.birthplace}',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                        color: Color(0xff000000),
                                      ),
                                    )
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
                                    child: 
                                    Text('${profile.data.homeAddress}',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                        color: Color(0xff000000),
                                      ),
                                    )
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
                                    child: Text('${profile.data.emailAddress}',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                        color: Color(0xff000000),
                                      ),
                                    )
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
                                    child: Text('${profile.data.contactNumber}',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                        color: Color(0xff000000),
                                      ),
                                    )
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                MiscRegularUserProfileDraggableSwitchTabs(userId: userId,),

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