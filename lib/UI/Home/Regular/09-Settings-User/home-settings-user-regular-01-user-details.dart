import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-12-update-user-profile-picture.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-custom-drawings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-16-regular-user-settings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:io';

class HomeRegularUserProfileDetails extends StatefulWidget{
  final int userId;
  HomeRegularUserProfileDetails({this.userId});
  
  HomeRegularUserProfileDetailsState createState() => HomeRegularUserProfileDetailsState(userId: userId);
}

class HomeRegularUserProfileDetailsState extends State<HomeRegularUserProfileDetails>{
  final int userId;
  HomeRegularUserProfileDetailsState({this.userId});

  Future showProfile;
  final picker = ImagePicker();
  File profileImage;

  Future<APIRegularShowProfileInformation> getProfileInformation() async{
    return await apiRegularShowProfileInformation();
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
      body: FutureBuilder<APIRegularShowProfileInformation>(
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

                      CustomPaint(size: Size.infinite, painter: MiscRegularCurvePainter(),),

                      

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
                              bool result = await apiRegularUpdateUserProfilePicture(image: profileImage, userId: userId);
                              context.hideLoaderOverlay();

                              if(result != true){
                                await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
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
                              Navigator.of(context).popAndPushNamed('/home/regular');
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
                
                MiscRegularUserProfileDetailsDraggable(userId: userId,),

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