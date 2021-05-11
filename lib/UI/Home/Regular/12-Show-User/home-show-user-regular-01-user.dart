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

  HomeRegularUserProfileState createState() => HomeRegularUserProfileState(userId: userId, accountType: accountType);
}

class HomeRegularUserProfileState extends State<HomeRegularUserProfile>{
  final int userId;
  final int accountType;
  HomeRegularUserProfileState({required this.userId, required this.accountType});

  Future<APIRegularShowUserInformation>? showProfile;

  WeSlideController controller = WeSlideController();
  int currentIndex = 0;
  List<Widget> children = [];

  Future<APIRegularShowUserInformation> getProfileInformation() async{
    return await apiRegularShowUserInformation(userId: userId, accountType: accountType);
  }

  void initState(){
    super.initState();
    showProfile = getProfileInformation();
    children = [MiscRegularDraggablePost(userId: userId,), MiscRegularDraggableMemorials(userId: userId,)];
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
              // panelBackground: Color(0xffffffff),
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
                              child: const Center(
                                child: const Text('Post',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: SizeConfig.screenWidth! / 2.5,
                              child: const Center(
                                child: const Text('Memorials',
                                  style: const TextStyle(
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
                                              fit: BoxFit.cover,
                                              imageUrl: profile.data!.showUserInformationImage,
                                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                            ? CircleAvatar(
                              radius: 100, 
                              backgroundColor: const Color(0xff888888),
                              foregroundImage: NetworkImage(profile.data!.showUserInformationImage),
                              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                            )
                            : const CircleAvatar(
                              radius: 100, 
                              backgroundColor: const Color(0xff888888), 
                              foregroundImage: const AssetImage('assets/icons/app-icon.png'),
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
                        icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 30), 
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
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000),
                            ),
                          ),

                          const SizedBox(height: 20,),

                          Text('${profile.data!.showUserInformationEmailAddress}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xff000000),
                            ),
                          ),

                          const SizedBox(height: 20,),

                          const Text('About',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff04ECFF),
                            ),
                          ),

                          const SizedBox(height: 40,),

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

                                          const Text('Birthdate',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationBirthdate}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xff000000),
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

                                          const Text('Birthplace',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationBirthplace}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xff000000),
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

                                          const Text('Home Address',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: 
                                      Text('${profile.data!.showUserInformationHomeAddress}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xff000000),
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
                                          const Icon(Icons.email, color: const Color(0xffBDC3C7), size: 20,),

                                          const SizedBox(width: 20),

                                          const Text('Email Address',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationEmailAddress}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xff000000),
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

                                          const Text('Contact Number',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xffBDC3C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('${profile.data!.showUserInformationContactNumber}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xff000000),
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