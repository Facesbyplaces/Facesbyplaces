import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class RegularJoin extends StatelessWidget {
  const RegularJoin();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: const AssetImage('assets/icons/All Lives Matter.png'),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: const Color(0xffFFFFFF),
                    size: SizeConfig.blockSizeVertical! * 3.65,
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical! * 7.12),
              
              Container(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical! * 22.48, width: SizeConfig.blockSizeHorizontal! * 35.9,),),

              SizedBox(height: SizeConfig.blockSizeVertical! * 35.20),

              Center(
                child: Text('All Lives Matter',
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 4.57,
                    color: const Color(0xffffffff),
                    fontFamily: 'NexaBold'
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical! * 6.03),

              MiscRegularButtonTemplate(
                buttonText: 'Next',
                buttonTextStyle: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 3.29,
                  fontFamily: 'NexaBold',
                  color: const Color(0xffffffff),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/regular/login');
                },
                width: SizeConfig.blockSizeHorizontal! * 52.17,
                height: SizeConfig.blockSizeVertical! * 7.00,
                buttonColor: const Color(0xff04ECFF),
              ),

              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}