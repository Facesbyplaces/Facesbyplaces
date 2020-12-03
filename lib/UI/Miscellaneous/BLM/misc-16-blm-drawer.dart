import 'package:cached_network_image/cached_network_image.dart';
import 'package:facesbyplaces/API/BLM/api-22-blm-show-user-information.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-20-blm-logout.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import '../../ui-01-get-started.dart';
import 'misc-02-blm-dialog.dart';


class MiscBLMDrawer extends StatelessWidget{

  final int userId;

  MiscBLMDrawer({this.userId});

// class MiscBLMDrawer extends StatefulWidget{

//   MiscBLMDrawerState createState() => MiscBLMDrawerState();
// }

// class MiscBLMDrawerState extends State<MiscBLMDrawer>{

    // final sharedPrefs = await SharedPreferences.getInstance();

    // sharedPrefs.setInt('blm-user-id', userId);

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Container(
        color: Color(0xff4EC9D4),
        child: FutureBuilder<APIBLMShowProfileInformation>(
          future: apiBLMShowProfileInformation(),
          builder: (context, manageDrawer){
            if(manageDrawer.hasData){
              return Column(
                children: [
                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 10.5,
                    backgroundColor: Color(0xffffffff),
                    child: CachedNetworkImage(
                      imageUrl: manageDrawer.data.image,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  GestureDetector(
                    onTap: (){
                      // key.currentState.close();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
                    },
                    child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  GestureDetector(
                    onTap: (){
                      // key.currentState.close();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/home/blm/home-14-blm-user-details');
                    },
                    child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  GestureDetector(
                    onTap: () async{
                      context.showLoaderOverlay();
                      bool result = await apiBLMLogout();
                      context.hideLoaderOverlay();

                      if(result){
                        Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                      }else{
                        await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
                      }
                      
                    },
                    child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                  ),
                  
                ],
              );
            }else if(manageDrawer.hasError){
              return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
            }else{
              return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
            }
          },
        ),
      ),
    );
  }
}