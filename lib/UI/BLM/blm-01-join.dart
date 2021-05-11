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
                      icon: const Icon(Icons.arrow_back,
                          color: const Color(0xff000000), size: 30),
                    ),
                  ),
                  Container(
                    height: SizeConfig.blockSizeVertical! * 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(),
                        const Text(
                          'BLACK',
                          style: const TextStyle(
                              fontSize: 24,
                              color: const Color(0xff000000),
                              fontFamily: 'NexaBold'),
                        ),
                        SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          child: const Text(
                            'LIVES',
                            style: const TextStyle(
                              fontSize: 24,
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
                        const Text(
                          'MATTER',
                          style: const TextStyle(
                            fontSize: 24,
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
                            height: SizeConfig.blockSizeVertical!*30,
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
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Positioned(
                          top: SizeConfig.blockSizeVertical!*5,
                          left: SizeConfig.blockSizeHorizontal!*5,
                          child: Transform.rotate(
                            angle: 75,
                            child: const MiscStartImageBlmTemplate(),
                          ),
                        ),

                        Positioned(
                          left: 200,
                          child: Transform.rotate(
                            angle: 101,
                            child: const MiscStartImageBlmTemplate(),
                          ),
                        ),

                        Positioned(
                          top: 100,
                          right: 0,
                          child: Transform.rotate(
                            angle: 101,
                            child: const MiscStartImageBlmTemplate(),
                          ),
                        ),

                        Positioned(
                          top: 200,
                          child: Transform.rotate(
                            angle: 101,
                            child: const MiscStartImageBlmTemplate(),
                          ),
                        ),

                        Positioned(
                          top: 200,
                          right: 0,
                          child: const MiscStartImageBlmTemplate(),
                        ),

                        Positioned(
                          bottom: 0,
                          child: const MiscStartImageBlmTemplate(),
                        ),

                        Positioned(
                          bottom: 0,
                          left: 150,
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
                                  child: Image.asset('assets/icons/blm-image2.png'),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Transform.rotate(
                            angle: 101,
                            child: const MiscStartImageBlmTemplate(),
                          ),
                        ),
                        Positioned.fill(
                            right: SizeConfig.blockSizeHorizontal!* 30,
                            left: SizeConfig.blockSizeHorizontal!* 30,
                            bottom: SizeConfig.blockSizeVertical!* 30,
                          child: Image.asset('assets/icons/logo.png',)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),),);
  }
}
