import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-12-update-user-profile-picture.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-user-settings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:io';

class HomeBLMUserProfileDetails extends StatefulWidget{
  final int userId;
  HomeBLMUserProfileDetails({this.userId});
  
  HomeBLMUserProfileDetailsState createState() => HomeBLMUserProfileDetailsState(userId: userId);
}

class HomeBLMUserProfileDetailsState extends State<HomeBLMUserProfileDetails>{
  final int userId;
  HomeBLMUserProfileDetailsState({this.userId});

  Future showProfile;
  final picker = ImagePicker();
  File profileImage;

  Future<APIBLMShowProfileInformation> getProfileInformation() async{
    return await apiBLMShowProfileInformation();
  }

  Future getProfileImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        profileImage = File(pickedFile.path);
      });
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
                  height: SizeConfig.screenHeight / 2.5,
                  child: Stack(
                    children: [

                      CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

                      Positioned(
                        top: SizeConfig.blockSizeVertical * 8,
                        left: SizeConfig.screenWidth / 4.2,
                        child: Badge(
                          // position: BadgePosition.topEnd(top: -3, end: -10),
                          position: BadgePosition.topEnd(top: 5, end: 15),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.fade,
                          badgeColor: Colors.grey,
                          badgeContent: Icon(Icons.camera, size: SizeConfig.blockSizeVertical * 5.5,),
                          child: GestureDetector(
                            onTap: () async{

                              await getProfileImage();
                              
                              context.showLoaderOverlay();
                              bool result = await apiBLMUpdateUserProfilePicture(image: profileImage, userId: userId);
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
                              }

                              print('The result is $result');
                              
                            },
                            child: CircleAvatar(
                              radius: SizeConfig.blockSizeVertical * 15,
                              backgroundColor: Color(0xff888888),
                              backgroundImage: ((){
                                if(profileImage != null){
                                  return AssetImage(profileImage.path);
                                }else if(profile.data.image != null && profile.data.image != ''){
                                  return NetworkImage(profile.data.image);
                                }else{
                                  return AssetImage('assets/icons/app-icon.png');
                                }
                              }()),
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
                              Navigator.of(context).popAndPushNamed('/home/blm');
                            },
                            icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,), 
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
                  top: SizeConfig.screenHeight / 2.5,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      children: [
                        Center(
                          child: Text(profile.data.firstName + ' ' + profile.data.lastName,
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Center(
                          child: Text(profile.data.email,
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              fontWeight: FontWeight.w300,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      ],
                    ),
                  ),
                ),

                MiscBLMUserProfileDetailsDraggable(userId: userId,),

              ],
            );
          }else if(profile.hasError){
            return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
          }else{
            return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
          }
        },
      ),
    );
  }
}