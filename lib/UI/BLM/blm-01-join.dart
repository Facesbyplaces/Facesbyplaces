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
      body: Stack(
        children: [

          const MiscBLMBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),

          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerLeft, 
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(Icons.arrow_back, color: const Color(0xff000000), size: 30),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('BLACK',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff000000),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: const Text('LIVES',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffffffff),
                          ),
                        ),
                        decoration: const BoxDecoration(
                          color: const Color(0xff000000),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),

                      const Text('MATTER',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50,),

                Container(
                  width: 500,
                  height: 500,
                  child: Stack(
                    children: [

                      Positioned(
                        top: 25,
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

                      Center(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),                                

                    ],
                  ),
                ),

                const SizedBox(height: 50,),

                const Center(child: const Text('Remembering the Victims', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),),

                const SizedBox(height: 50,),
            
                MiscBLMButtonTemplate(
                  buttonText: 'Join', 
                  buttonTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xffffffff),
                  ),
                  width: SizeConfig.screenWidth! / 2, 
                  height: 45,
                  buttonColor: const Color(0xff4EC9D4),
                  onPressed: (){
                    Navigator.pushNamed(context, '/blm/login');
                  },
                ),

                const SizedBox(height: 80,),

              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
