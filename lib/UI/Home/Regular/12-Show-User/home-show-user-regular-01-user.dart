import 'package:facesbyplaces/API/Regular/13-Show-User/api-show-user-regular-01-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-12-regular-user-details.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:we_slide/we_slide.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeRegularUserProfile extends StatefulWidget{
  final int userId;
  final int accountType;
  const HomeRegularUserProfile({required this.userId, required this.accountType});

  HomeRegularUserProfileState createState() => HomeRegularUserProfileState();
}

class HomeRegularUserProfileState extends State<HomeRegularUserProfile>{
  Future<APIRegularShowUserInformation>? showProfile;

  WeSlideController controller = WeSlideController();
  int currentIndex = 0;
  List<Widget> children = [];

  Future<APIRegularShowUserInformation> getProfileInformation() async{
    return await apiRegularShowUserInformation(userId: widget.userId, accountType: widget.accountType);
  }

  void initState(){
    super.initState();
    showProfile = getProfileInformation();
    children = [MiscRegularDraggablePost(userId: widget.userId,), MiscRegularDraggableMemorials(userId: widget.userId,)];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: FutureBuilder<APIRegularShowUserInformation>(
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
                    const BoxShadow(blurRadius: 0.5, offset: const Offset(0, 1)),
                  ],
                  color: const Color(0xffffffff),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(50.0),
                    topRight: const Radius.circular(50.0),
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
                          labelColor: const Color(0xff04ECFF),
                          unselectedLabelColor: const Color(0xffCDEAEC),
                          indicatorColor: const Color(0xff04ECFF),
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
                                    fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                    fontFamily: 'NexaBold',
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: SizeConfig.screenWidth! / 2.5,
                              child: Center(
                                child: Text('Memorials',
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                    fontFamily: 'NexaBold',
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
                  Container(height: SizeConfig.screenHeight, color: const Color(0xffffffff),),

                  Container(
                    height: SizeConfig.screenHeight! / 2.5,
                    child: Stack(
                      children: [
                        CustomPaint(size: Size.infinite, painter: MiscRegularCurvePainter(),),

                        GestureDetector( // BACKGROUND IMAGE FOR ZOOMING IN
                          onTap: (){
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: 'Dialog',
                              transitionDuration: const Duration(milliseconds: 0),
                              pageBuilder: (_, __, ___) {
                                return Scaffold(
                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                  body: SizedBox.expand(
                                    child: SafeArea(
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 20,),

                                          Expanded(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.contain,
                                              imageUrl: profile.data!.showUserInformationImage,
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                            )
                                          ),

                                          const SizedBox(height: 80,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            alignment: Alignment.bottomCenter,
                            child: profile.data!.showUserInformationImage != ''
                            ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 100,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: NetworkImage(profile.data!.showUserInformationImage),
                              ),
                            )
                            : const CircleAvatar(
                              radius: 100, 
                              backgroundColor: const Color(0xff888888), 
                              foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding:const  EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52),
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
                              fontSize: SizeConfig.blockSizeVertical! * 3.52,
                              fontFamily: 'NexaBold',
                              color: const Color(0xff000000),
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical! * 2.03),

                          Text('${profile.data!.showUserInformationEmailAddress}',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xffBDC3C7),
                            ),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical! * 1,),

                          Text('About',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xff04ECFF),
                            ),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical! * 2,),

                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star_outline, color: const Color(0xffBDC3C7), size: 20,),

                                          const SizedBox(width: 20,),

                                          Text('Birthdate',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                              fontFamily: 'NexaRegular',
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationBirthdate}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                          fontFamily: 'NexaRegular',
                                          color: const Color(0xff2F353D),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.place, color: const Color(0xffBDC3C7), size: 20,),

                                          const SizedBox(width: 20,),

                                          Text('Birthplace',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                              fontFamily: 'NexaRegular',
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationBirthplace}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                          fontFamily: 'NexaRegular',
                                          color: const Color(0xff2F353D),
                                        ),
                                      )
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.home, color: const Color(0xffBDC3C7), size: 20),

                                          const SizedBox(width: 20),

                                           Text('Home Address',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                              fontFamily: 'NexaRegular',
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: 
                                      Text('${profile.data!.showUserInformationHomeAddress}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                          fontFamily: 'NexaRegular',
                                          color: const Color(0xff2F353D),
                                        ),
                                      )
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.email, color: const Color(0xffBDC3C7), size: 20,),

                                          const SizedBox(width: 20),

                                          Text('Email Address',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                              fontFamily: 'NexaRegular',
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationEmailAddress}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical! * 2,
                                          fontFamily: 'NexaRegular',
                                          color: const Color(0xff2F353D),
                                        ),
                                      )
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.phone, color: const Color(0xffBDC3C7), size: 20,),

                                          const SizedBox(width: 20,),

                                          Text('Contact Number',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                              fontFamily: 'NexaRegular',
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationContactNumber}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical! * 2.11,
                                          fontFamily: 'NexaRegular',
                                          color: const Color(0xff2F353D),
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
            return const MiscRegularErrorMessageTemplate();
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
          }
        }
      ),
    );
  }
}