import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget{
  const UILogin01();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: SizeConfig.blockSizeVertical! * 5),

              Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical! * 29.98, width: SizeConfig.blockSizeVertical! * 47.81,),

              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              
              Text('FacesByPlaces.com', style: TextStyle( fontSize: SizeConfig.blockSizeVertical! * 2.74, color: Color(0xff2F353D), fontFamily: 'NexaBold'),),
              
              SizedBox(height: SizeConfig.blockSizeVertical! * 4.79),
              
              Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'NexaBold', fontSize: SizeConfig.blockSizeVertical! * 2.74, color: const Color(0xff000000), ),),
              
              SizedBox(height: SizeConfig.blockSizeVertical! * 4.20),
              
              Text('Black Lives Matter', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, color: const Color(0xff000000), fontFamily: 'NexaRegular'),),

              SizedBox(height: SizeConfig.blockSizeVertical! * 0.54),

              Padding(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 3, right: SizeConfig.blockSizeHorizontal! * 3),
                child: MaterialButton(
                  height: SizeConfig.blockSizeVertical! * 10.00,
                  minWidth: SizeConfig.screenWidth! / 1.5,
                  color: const Color(0xffF2F2F2),
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Center(child: Image.asset('assets/icons/fist.png', height: SizeConfig.blockSizeVertical! * 10,),),
                        backgroundColor: const Color(0xff000000),
                        minRadius: 35,
                      ),

                      Expanded(
                        child: Container(
                          child: Text('Speak for a loved one killed by law enforcement', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.5, color: const Color(0xff2F353D), fontFamily: 'NexaRegular'),),
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 3.75, right: SizeConfig.blockSizeHorizontal! * 0,),
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/blm/join');
                  },
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical! * 3.83),

              Text('All Lives Matter', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, color: const Color(0xff000000), fontFamily: 'NexaRegular'),),

              SizedBox(height: SizeConfig.blockSizeVertical! * 0.54),

              Padding(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 3, right: SizeConfig.blockSizeHorizontal! * 3),
                child: MaterialButton(
                  height: SizeConfig.blockSizeVertical! * 10.0,
                  minWidth: SizeConfig.screenWidth! / 1.5,
                  color: const Color(0xffE6FDFF),
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.favorite, size: SizeConfig.blockSizeVertical! * 5.0, color: const Color(0xffffffff),),
                        backgroundColor: const Color(0xff04ECFF),
                        minRadius: 35,
                      ),

                      Expanded(
                        child: Container(
                          child: Text('Remembering friends and family', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.5, color: const Color(0xff2F353D), fontFamily: 'NexaRegular'),),
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 3.75, right: SizeConfig.blockSizeHorizontal! * 5,),
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, '/regular/join');
                  },
                ),
              ),

              Spacer(),

              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Already have an Account? ', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, color: const Color(0xff000000), fontFamily: 'NexaRegular'),),

                    TextSpan(
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, color: const Color(0xff04ECFF), fontFamily: 'NexaRegular',),
                      text: 'Login',
                      recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        Navigator.pushNamed(context, '/regular/login');
                      },
                    ),
                  ],
                ),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}