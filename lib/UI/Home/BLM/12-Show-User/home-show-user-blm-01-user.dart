// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/13-Show-User/api_show_user_blm_01_show_user_information.dart';
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
  const HomeBLMUserProfile({Key? key, required this.userId, required this.accountType}) : super(key: key);

  @override
  HomeBLMUserProfileState createState() => HomeBLMUserProfileState();
}

class HomeBLMUserProfileState extends State<HomeBLMUserProfile>{
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  WeSlideController controller = WeSlideController();
  Future<APIBLMShowUserInformation>? showProfile;
  List<Widget> children = [];

  Future<APIBLMShowUserInformation> getProfileInformation() async{
    return await apiBLMShowUserInformation(userId: widget.userId, accountType: widget.accountType);
  }

  @override
  void initState(){
    super.initState();
    showProfile = getProfileInformation();
    children = [MiscBLMDraggablePost(userId: widget.userId, accountType: widget.accountType,), MiscBLMDraggableMemorials(userId: widget.userId, accountType: widget.accountType,)]; // MISCELLANEOUS - MISC-13-BLM-USER-DETAILS.DART
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (_, int currentIndexListener, __) => Scaffold(
        body: FutureBuilder<APIBLMShowUserInformation>(
          future: showProfile,
          builder: (context, profile){
            if(profile.hasData){
              return WeSlide(
                controller: controller,
                panelMaxSize: SizeConfig.screenHeight! / 1.5,
                backgroundColor: const Color(0xffffffff),
                panel: Container(
                  height: SizeConfig.screenHeight! / 1.5,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(blurRadius: 0.5, offset: Offset(0, 1)),
                    ],
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0),
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
                          initialIndex: currentIndexListener,
                          child: TabBar(
                            isScrollable: false,
                            unselectedLabelColor: const Color(0xffCDEAEC),
                            indicatorColor: const Color(0xff04ECFF),
                            labelColor: const Color(0xff04ECFF),
                            tabs: [
                              SizedBox(
                                width: SizeConfig.screenWidth! / 2.5,
                                child: const Center(child: Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold',),),),
                              ),

                              SizedBox(
                                width: SizeConfig.screenWidth! / 2.5,
                                child: const Center(child: Text('Memorials', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold',),),),
                              ),
                            ],
                            onTap: (int number){
                              currentIndex.value = number;
                            },
                          ),
                        ),
                      ),

                      Expanded(
                        child: IndexedStack(
                          index: currentIndexListener,
                          children: children,
                        ),
                      ),
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    Container(height: SizeConfig.screenHeight, color: const Color(0xffffffff),),

                    SizedBox(
                      height: SizeConfig.screenHeight! / 2.5,
                      child: Stack(
                        children: [
                          CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

                          GestureDetector( // BACKGROUND IMAGE FOR ZOOMING IN
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              alignment: Alignment.bottomCenter,
                              child: profile.data!.showUserInformationImage != '' 
                              ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3,),
                                ),
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: const Color(0xff888888),
                                  foregroundImage: NetworkImage(profile.data!.showUserInformationImage),
                                ),
                              )
                              : const CircleAvatar(
                                radius: 100, 
                                backgroundColor: Color(0xff888888), 
                                foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                              ),
                            ),
                            onTap: (){
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'Dialog',
                                transitionDuration: const Duration(milliseconds: 0),
                                pageBuilder: (_, __, ___){
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
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                  child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                ),
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),

                                            const SizedBox(height: 20,),

                                            Expanded(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.contain,
                                                imageUrl: profile.data!.showUserInformationImage,
                                                placeholder: (context, url) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.cover, scale: 1.0,),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
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
                          ),
                        ],
                      ),
                    ),

                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      top: SizeConfig.screenHeight! / 2.5,
                      child: SizedBox(
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [
                            Text('${profile.data!.showUserInformationFirstName} ${profile.data!.showUserInformationLastName}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                            const SizedBox(height: 20),

                            Text(profile.data!.showUserInformationEmailAddress, style: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),

                            const SizedBox(height: 10),

                            const Text('About', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xff04ECFF),),),

                            const SizedBox(height: 20,),

                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: const [
                                            Icon(Icons.star_outline, color: Color(0xffBDC3C7), size: 20,),

                                            SizedBox(width: 20,),

                                            Text('Birthdate', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                          ],
                                        ),
                                      ),

                                      Expanded(child: Text(profile.data!.showUserInformationBirthdate, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),),
                                    ],
                                  ),

                                  const SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: const [
                                            Icon(Icons.place, color: Color(0xffBDC3C7), size: 20,),

                                            SizedBox(width: 20,),

                                            Text('Birthplace', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                          ],
                                        ),
                                      ),

                                      Expanded(child: Text(profile.data!.showUserInformationBirthplace, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),)),
                                    ],
                                  ),

                                  const SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: const [
                                            Icon(Icons.home, color: Color(0xffBDC3C7), size: 20),

                                            SizedBox(width: 20),

                                            Text('Home Address', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                          ],
                                        ),
                                      ),

                                      Expanded(child: Text(profile.data!.showUserInformationHomeAddress, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),),
                                    ],
                                  ),

                                  const SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: const [
                                            Icon(Icons.email, color: Color(0xffBDC3C7), size: 20,),

                                            SizedBox(width: 20),

                                            Text('Email Address', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                          ],
                                        ),
                                      ),

                                      Expanded(child: Text(profile.data!.showUserInformationEmailAddress, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),),
                                    ],
                                  ),

                                  const SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: const [
                                            Icon(Icons.phone, color: Color(0xffBDC3C7), size: 20,),

                                            SizedBox(width: 20,),

                                            Text('Contact Number', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                          ],
                                        ),
                                      ),

                                      Expanded(child: Text(profile.data!.showUserInformationContactNumber, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),),
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
              return const MiscBLMErrorMessageTemplate();
            }else{
              return SizedBox(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
            }
          }
        ),
      ),
    );
  }
}