import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Container(
        color: Color(0xff4EC9D4),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            CircleAvatar(
              radius: SizeConfig.blockSizeVertical * 10.5,
              backgroundColor: Color(0xffffffff),
              child: CircleAvatar(
                radius: SizeConfig.blockSizeVertical * 10,
                backgroundImage: AssetImage('assets/icons/profile1.png'),
              ),
            ),

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
                Navigator.pushNamed(context, '/home/home-07-01-create-memorial');
              },
              child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/home/home-13-user-details');
              },
              child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: (){

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