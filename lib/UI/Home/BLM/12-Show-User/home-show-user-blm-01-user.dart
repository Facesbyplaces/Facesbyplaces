import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-01-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-user-details.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:we_slide/we_slide.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeBLMUserProfile extends StatefulWidget{
  final int userId;
  final int accountType;
  HomeBLMUserProfile({required this.userId, required this.accountType});

  HomeBLMUserProfileState createState() => HomeBLMUserProfileState(userId: userId, accountType: accountType);
}

class HomeBLMUserProfileState extends State<HomeBLMUserProfile>{
  final int userId;
  final int accountType;
  HomeBLMUserProfileState({required this.userId, required this.accountType});

  Future<APIBLMShowUserInformation>? showProfile;
  
  WeSlideController controller = WeSlideController();
  int currentIndex = 0;
  List<Widget> children = [];

  Future<APIBLMShowUserInformation> getProfileInformation() async{
    return await apiBLMShowUserInformation(userId: userId, accountType: accountType);
  }

  void initState(){
    super.initState();
    showProfile = getProfileInformation();
    children = [MiscBLMDraggablePost(userId: userId,), MiscBLMDraggableMemorials(userId: userId,)]; // MISCELLANEOUS - MISC-13-BLM-USER-DETAILS.DART
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: FutureBuilder<APIBLMShowUserInformation>(
        future: showProfile,
        builder: (context, profile){
          if(profile.hasData){
            return WeSlide(
              controller: controller,
              panelMaxSize: SizeConfig.screenHeight! / 1.5,
              backgroundColor: Color(0xffffffff),
              panel: Container(
                height: SizeConfig.screenHeight! / 1.5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(blurRadius: 0.5, offset: Offset(0, 1)),
                  ],
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth,
                      height: 70,
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: currentIndex,
                        child: TabBar(
                          isScrollable: false,
                          labelColor: Color(0xff04ECFF),
                          unselectedLabelColor: Color(0xffCDEAEC),
                          indicatorColor: Color(0xff04ECFF),
                          onTap: (int number){
                            setState(() {
                              currentIndex = number;
                            });
                          },
                          tabs: [

                            Container(
                              width: SizeConfig.screenWidth! / 2.5,
                              child: Center(
                                child: Text('Post',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: SizeConfig.screenWidth! / 2.5,
                              child: Center(
                                child: Text('Memorials',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        child: IndexedStack(
                          index: currentIndex,
                          children: children,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [

                  Container(height: SizeConfig.screenHeight, color: Color(0xffffffff),),

                  Container(
                    height: SizeConfig.screenHeight! / 2.5,
                    child: Stack(
                      children: [
                        CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

                        GestureDetector( // BACKGROUND IMAGE FOR ZOOMING IN
                          onTap: (){
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: 'Dialog',
                              transitionDuration: Duration(milliseconds: 0),
                              pageBuilder: (_, __, ___) {
                                return Scaffold(
                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                  body: SizedBox.expand(
                                    child: SafeArea(
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(right: 20.0),
                                            child: GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Color(0xff000000).withOpacity(0.8),
                                                child: Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 20,),

                                          Expanded(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: profile.data!.showUserInformationImage,
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            )
                                          ),

                                          SizedBox(height: 80,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 20.0),
                            alignment: Alignment.bottomCenter,
                            child: profile.data!.showUserInformationImage != '' 
                            ? CircleAvatar(
                              radius: 100, 
                              backgroundColor: Color(0xff888888), 
                              backgroundImage: NetworkImage(profile.data!.showUserInformationImage),
                            )
                            : CircleAvatar(
                              radius: 100, 
                              backgroundColor: Color(0xff888888), 
                              backgroundImage: AssetImage('assets/icons/app-icon.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: 30), 
                      ),
                    ),
                  ),

                  Positioned(
                    top: SizeConfig.screenHeight! / 2.5,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          Text('${profile.data!.showUserInformationFirstName + ' ' + profile.data!.showUserInformationLastName}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000),
                            ),
                          ),

                          SizedBox(height: 20,),

                          Text('${profile.data!.showUserInformationEmailAddress}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff000000),
                            ),
                          ),

                          SizedBox(height: 20,),

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
                                      child: Text('${profile.data!.showUserInformationBirthdate}',
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
                                      child: Text('${profile.data!.showUserInformationBirthplace}',
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
                                          Icon(Icons.home, color: Color(0xffBDC3C7), size: 20),

                                          SizedBox(width: 20),

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
                                      child: 
                                      Text('${profile.data!.showUserInformationHomeAddress}',
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

                                          SizedBox(width: 20),

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
                                      child: Text('${profile.data!.showUserInformationEmailAddress}',
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
                                      child: Text('${profile.data!.showUserInformationContactNumber}',
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

                ],
              ),
            );

          }else if(profile.hasError){
            return MiscBLMErrorMessageTemplate();
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        }
      ),
    );
  }
}