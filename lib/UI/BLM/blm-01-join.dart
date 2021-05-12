import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Start/misc-02-image-blm.dart';
import 'package:flutter/material.dart';

class BLMJoin extends StatelessWidget {
  const BLMJoin();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          color: Colors.white,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:  Icon(Icons.arrow_back,
                    color:  Color(0xff000000), size: SizeConfig.blockSizeVertical! * 3.65,),
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical! * 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Spacer(),
                    Text(
                      'BLACK',
                      style:  TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 3.65,
                          color: const Color(0xff000000),
                          fontFamily: 'NexaBold'),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      child:  Text(
                        'LIVES',
                        style:  TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 3.65,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff),
                        ),
                      ),
                      decoration: const BoxDecoration(
                        color: const Color(0xff000000),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                    Text(
                      'MATTER',
                      style:  TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 3.65,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff000000),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 5),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: SizeConfig.blockSizeVertical! * 30,
                      child: Container(
                        height: SizeConfig.blockSizeVertical! * 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: const DecorationImage(
                            fit: BoxFit.fill,
                            image: const AssetImage(
                              'assets/icons/join6.png',
                            ),
                          ),
                        ),
                        child: Container(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.blockSizeVertical! * 5,
                      left: SizeConfig.blockSizeHorizontal! * 8,
                      child: Transform.rotate(
                        angle: 75,
                        child: const MiscStartImageBlmTemplate(
                          image: 'assets/icons/join1.png',
                        ),
                      ),
                    ),
                    Positioned(
                      left: SizeConfig.blockSizeHorizontal! * 40,
                      child: Transform.rotate(
                        angle: 0,
                        child: const MiscStartImageBlmTemplate(),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.blockSizeVertical! * 5,
                      right: 0,
                      child: Transform.rotate(
                        angle: 101,
                        child: const MiscStartImageBlmTemplate(
                          image: 'assets/icons/join2.png',
                        ),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.blockSizeVertical! * 20,
                      child: Transform.rotate(
                        angle: 101,
                        child: const MiscStartImageBlmTemplate(),
                      ),
                    ),
                    Positioned(
                      bottom: SizeConfig.blockSizeVertical! * 30,
                      left: SizeConfig.blockSizeHorizontal! * 65,
                      child: Transform.rotate(
                        angle: 101,
                        child: const MiscStartImageBlmTemplate(
                            image: 'assets/icons/join7.png'),
                      ),
                    ),
                    Positioned(
                      top: SizeConfig.blockSizeVertical! * 20,
                      right: 0,
                      child: Transform.rotate(
                        angle: 0,
                        child: const MiscStartImageBlmTemplate(
                            image: 'assets/icons/join4.png'),
                      ),
                    ),
                    Positioned(
                      bottom: SizeConfig.blockSizeVertical! * 30,
                      left: SizeConfig.blockSizeHorizontal! * 30,
                      child: Transform.rotate(
                        angle: 101,
                        child: Container(
                          height: 150,
                          width: 150,
                          color: Color(0xffF4F3EB),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Transform.rotate(
                              angle: 25,
                              child: Image.asset('assets/icons/join1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: SizeConfig.blockSizeVertical! * 30,
                      left: SizeConfig.blockSizeHorizontal! * 5,
                      child: const MiscStartImageBlmTemplate(
                          image: 'assets/icons/join4.png'),
                    ),
                    Positioned.fill(
                        right: SizeConfig.blockSizeHorizontal! * 30,
                        left: SizeConfig.blockSizeHorizontal! * 30,
                        bottom: SizeConfig.blockSizeVertical! * 30,
                        child: Image.asset(
                          'assets/icons/logo.png',
                        )),
                    Positioned.fill(
                      top: SizeConfig.blockSizeVertical! * 40,
                      child: Center(
                        child: Text(
                          'Remembering the Victims',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 3.29,
                            fontFamily: 'NexaBold',
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: SizeConfig.blockSizeVertical! * 60,
                      child: Center(
                        child:  MiscBLMButtonTemplate(
                          buttonText: 'Join',
                          buttonTextStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 3.29,
                            fontFamily: 'NexaBold',
                            color: const Color(0xffffffff),
                          ),
                          width: SizeConfig.blockSizeHorizontal! * 55,
                          height: SizeConfig.blockSizeVertical! * 7.31,
                          buttonColor: const Color(0xff4EC9D4),
                          onPressed: (){
                            Navigator.pushNamed(context, '/blm/login');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
