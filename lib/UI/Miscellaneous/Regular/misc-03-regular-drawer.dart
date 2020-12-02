import 'package:facesbyplaces/API/BLM/api-20-blm-logout.dart';
import 'package:facesbyplaces/API/Regular/api-18-regular-logout.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularDrawer extends StatelessWidget {

  Widget build(BuildContext context){
    return Drawer(
      child: Container(
        color: Color(0xff4EC9D4),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            CircleAvatar(radius: SizeConfig.blockSizeVertical * 10.5, backgroundColor: Color(0xffffffff), child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 10, backgroundImage: AssetImage('assets/icons/profile2.png'),),),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            Text('Michael Philips', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

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
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home/regular/home-04-01-regular-create-memorial');
              },
              child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, 'home/regular/home-15-regular-user-details');
              },
              child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: () async{

                await apiRegularLogout();
                await apiBLMLogout();

                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                
              },
              child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),
            
          ],
        ),
      ),
    );
  }  
}
