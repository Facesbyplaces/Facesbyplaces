import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-17-regular-custom-drawings.dart';
import 'package:facesbyplaces/API/Regular/api-32-show-user-information.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeRegularUserProfileDetails extends StatefulWidget{
  final int userId;
  HomeRegularUserProfileDetails({this.userId});
  
  HomeRegularUserProfileDetailsState createState() => HomeRegularUserProfileDetailsState(userId: userId);
}

class HomeRegularUserProfileDetailsState extends State<HomeRegularUserProfileDetails>{
  final int userId;
  HomeRegularUserProfileDetailsState({this.userId});

  Future showProfile;

  Future<APIRegularShowProfileInformation> getProfileInformation() async{
    return await apiRegularShowProfileInformation();
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
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 15,
                          backgroundColor: Color(0xff888888),
                          backgroundImage: ((){
                            if(profile.data.image != null && profile.data.image != ''){
                              return NetworkImage(profile.data.image);
                            }else{
                              return AssetImage('assets/icons/app-icon.png');
                            }
                          }()),
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
                              Navigator.pop(context);
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