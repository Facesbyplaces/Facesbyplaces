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

          MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerLeft, 
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: 30),
                  ),
                ),

                SizedBox(height: 10),

                Container(
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('BLACK',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Text('LIVES',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff000000),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),

                      Text('MATTER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50,),

                Container(
                  width: 500,
                  height: 500,
                  child: Stack(
                    children: [

                      Positioned(
                        top: 25,
                        child: Transform.rotate(
                          angle: 75,
                          child: MiscStartImageBlmTemplate(),
                        ),
                      ),

                      Positioned(
                        left: 200,
                        child: Transform.rotate(
                          angle: 101,
                          child: MiscStartImageBlmTemplate(),
                        ),
                      ),

                      Positioned(
                        top: 100,
                        right: 0,
                        child: Transform.rotate(
                          angle: 101,
                          child: MiscStartImageBlmTemplate(),
                        ),
                      ),

                      Positioned(
                        top: 200,
                        child: Transform.rotate(
                          angle: 101,
                          child: MiscStartImageBlmTemplate(),
                        ),
                      ),

                      Positioned(
                        top: 200,
                        right: 0,
                        child: MiscStartImageBlmTemplate(),
                      ),

                      Positioned(
                        bottom: 0,
                        child: MiscStartImageBlmTemplate(),
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
                              padding: EdgeInsets.all(5.0),
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
                          child: MiscStartImageBlmTemplate(),
                        ),
                      ),

                      Center(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),                                

                    ],
                  ),
                ),

                SizedBox(height: 50,),

                Center(child: Text('Remembering the Victims', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                SizedBox(height: SizeConfig.blockSizeVertical! * 5,),
            
                MiscBLMButtonTemplate(
                  buttonText: 'Join', 
                  buttonTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, 
                    color: Color(0xffffffff),
                  ),
                  width: SizeConfig.screenWidth! / 2, 
                  height: 45,
                  buttonColor: Color(0xff4EC9D4),
                  onPressed: (){
                    Navigator.pushNamed(context, '/blm/login');
                  },
                ),

                SizedBox(height: 80,),

              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
