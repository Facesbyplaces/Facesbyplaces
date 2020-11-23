import 'package:facesbyplaces/API/BLM/api-07-01-blm-home-feed-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeBLMFeedTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<bool>(
      future: apiBLMHomeFeedTab(),
      builder: (context, feedTab){
        if(feedTab.hasData){
          return Column(
            children: [

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'Welcome to\n', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                      TextSpan(text: 'Faces by Places', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Container(
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: SizeConfig.blockSizeVertical * 8,
                      child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8,),
                    ),

                    Positioned(
                      right: 0,
                      top: SizeConfig.blockSizeVertical * 8,
                      child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8, backgroundColor: Color(0xff04ECFF),),
                    ),

                    Positioned(
                      left: SizeConfig.blockSizeHorizontal * 12,
                      top: SizeConfig.blockSizeVertical * 6,
                      child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10,),
                    ),

                    Positioned(
                      right: SizeConfig.blockSizeHorizontal * 12,
                      top: SizeConfig.blockSizeVertical * 6,
                      child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10, backgroundColor: Color(0xff04ECFF),),
                    ),

                    Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Center(child: Text('Feed is empty', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Center(child: Text('Create or join the memorial pages of other users to get started', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),),),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              MiscBLMButtonTemplate(
                buttonText: 'Create', 
                buttonTextStyle: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xffffffff),
                ), 
                onPressed: (){
                  Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
                  // Navigator.pushNamed(context, '/home/blm/home-07-02-blm-create-memorial');
                }, 
                width: SizeConfig.screenWidth / 2, 
                height: SizeConfig.blockSizeVertical * 7, 
                buttonColor: Color(0xff000000),
              ),
              
            ],
          );
        }else if(feedTab.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}