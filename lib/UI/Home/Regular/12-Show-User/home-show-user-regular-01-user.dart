import 'package:facesbyplaces/API/Regular/13-Show-User/api-show-user-regular-01-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-user-details.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeRegularUserProfile extends StatefulWidget{
  final int userId;
  final int accountType;
  HomeRegularUserProfile({this.userId, this.accountType});

  HomeRegularUserProfileState createState() => HomeRegularUserProfileState(userId: userId, accountType: accountType);
}

class HomeRegularUserProfileState extends State<HomeRegularUserProfile>{
  final int userId;
  final int accountType;
  HomeRegularUserProfileState({this.userId, this.accountType});

  Future<APIRegularShowUserInformation> showProfile;

  Future<APIRegularShowUserInformation> getProfileInformation() async{
    return await apiRegularShowUserInformation(userId: userId, accountType: accountType);
  }

  void initState(){
    super.initState();
    showProfile = getProfileInformation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
                        child: CircleAvatar(radius: 100, backgroundColor: Color(0xff888888), backgroundImage: profile.data.showUserInformationImage != null ? NetworkImage(profile.data.showUserInformationImage) : AssetImage('assets/icons/app-icon.png')),
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
                            icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: 30), 
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(height: 0,),
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
                        Text('${profile.data.showUserInformationFirstName + ' ' + profile.data.showUserInformationLastName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),

                        SizedBox(height: 20,),

                        Text('${profile.data.showUserInformationEmailAddress}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),

                        SizedBox(height: 40,),

                        Text('About',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff04ECFF),
                          ),
                        ),

                        SizedBox(height: 40,),

                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.star_outline, color: Color(0xffBDC3C7), size: 20,),

                                        SizedBox(width: 20,),

                                        Text('Birthdate',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffBDC3C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${profile.data.showUserInformationBirthdate}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),

                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.place, color: Color(0xffBDC3C7), size: 20,),

                                        SizedBox(width: 20,),

                                        Text('Birthplace',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffBDC3C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${profile.data.showUserInformationBirthplace}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    )
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),

                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.home, color: Color(0xffBDC3C7), size: 20,),

                                        SizedBox(width: 20,),

                                        Text('Home Address',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffBDC3C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${profile.data.showUserInformationHomeAddress}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    )
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),

                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.email, color: Color(0xffBDC3C7), size: 20,),

                                        SizedBox(width: 20,),

                                        Text('Email Address',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffBDC3C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${profile.data.showUserInformationEmailAddress}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    )
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),

                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone, color: Color(0xffBDC3C7), size: 20,),

                                        SizedBox(width: 20,),

                                        Text('Contact Number',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffBDC3C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${profile.data.showUserInformationContactNumber}',
                                      style: TextStyle(
                                        fontSize: 14,
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
            return MiscRegularErrorMessageTemplate();
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        }
      ),
    );
  }
}