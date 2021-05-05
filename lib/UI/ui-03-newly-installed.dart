import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class UINewlyInstalled extends StatefulWidget{

  UINewlyInstalledState createState() => UINewlyInstalledState();
}

class UINewlyInstalledState extends State<UINewlyInstalled>{

  List<bool> bottomTab = [true, false, false];
  List<Widget> screens = [UINewlyInstalled01(), UINewlyInstalled02(), UINewlyInstalled03()];
  int currentIndex = 0;

  newlyInstalled() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('newly-installed', false);
  }

  void initState(){
    super.initState();
    newlyInstalled();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return RepaintBoundary(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Stack(
              children: [
                Container(
                  height: SizeConfig.screenHeight! + 100,
                  child: TabBarView(
                    children: screens,
                  ),
                ),

                Container(
                  height: SizeConfig.screenHeight! + 50,
                  width: SizeConfig.screenWidth,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 100,
                    child: TabBar(
                      isScrollable: false,
                      labelColor: Color(0xff04ECFF),
                      unselectedLabelColor: Color(0xffCDEAEC),
                      indicatorColor: Color(0xff04ECFF),
                      indicator: BoxDecoration(
                        color: Colors.transparent
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [

                        Icon(Icons.circle, size: 15,),

                        Icon(Icons.circle, size: 15,),

                        Icon(Icons.circle, size: 15,),
                      ],
                    ),
                  ),
                ),


                Container(
                  height: SizeConfig.screenHeight! + 100,
                  width: SizeConfig.screenWidth,
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Next', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),
                    minWidth: 200,
                    height: 45,
                    shape: const StadiumBorder(),
                    color: const Color(0xff04ECFF),
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, '/start');
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UINewlyInstalled01 extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage('assets/icons/stephen-hawking.jpeg'),
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [

                  const SizedBox(height: 50,),

                  Image.asset('assets/icons/logo.png', height: 100, width: 100,),

                  const SizedBox(height: 20,),

                  Image.asset('assets/icons/stephen-hawking.jpeg', height: SizeConfig.screenWidth! / 1.2, width: SizeConfig.screenWidth! / 1.2, fit: BoxFit.cover,),

                  const SizedBox(height: 20,),

                  Text('Stephen Hawking',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color(0xff04ECFF),
                    )
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.starOutline, color: Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Born ',
                            ),

                            TextSpan(
                              text: 'January 8, 1942',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.graveStone, color: Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Died ',
                            ),

                            TextSpan(
                              text: 'March 14, 2018',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  const Text('"If human life were long enough to find the ultimate theory, everything would have been solved by previous generations. Nothing would be left to be discovered."', textAlign: TextAlign.center, style: TextStyle(color: Color(0xffffffff),),),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UINewlyInstalled02 extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage('assets/icons/kobe-bryant.jpeg'),
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [

                  const SizedBox(height: 50,),

                  Image.asset('assets/icons/logo.png', height: 100, width: 100,),

                  const SizedBox(height: 20,),

                  Image.asset('assets/icons/kobe-bryant.jpeg', height: SizeConfig.screenWidth! / 1.2, width: SizeConfig.screenWidth! / 1.2, fit: BoxFit.cover,),

                  const SizedBox(height: 20,),

                  Text('Kobe Bryant',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color(0xff04ECFF),
                    )
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.starOutline, color: Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Born ',
                            ),

                            TextSpan(
                              text: 'August 23, 1978',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.graveStone, color: Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Died ',
                            ),

                            TextSpan(
                              text: 'January 26, 2020',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  const Text('"I\'ll do whatever it takes to win games, whether it\'s sitting on a bench waving a towel, handing a cup of water to a teammate, or hitting the game-winning shot."', textAlign: TextAlign.center, style: TextStyle(color: Color(0xffffffff),),),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UINewlyInstalled03 extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage('assets/icons/stan-lee.jpeg'),
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [

                  const SizedBox(height: 50,),

                  Image.asset('assets/icons/logo.png', height: 100, width: 100,),

                  const SizedBox(height: 20,),

                  Image.asset('assets/icons/stan-lee.jpeg', height: SizeConfig.screenWidth! / 1.2, width: SizeConfig.screenWidth! / 1.2, fit: BoxFit.cover,),

                  const SizedBox(height: 20,),

                  Text('Stan Lee',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color(0xff04ECFF),
                    )
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.starOutline, color: Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Born ',
                            ),

                            TextSpan(
                              text: 'December 28, 1922',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.graveStone, color: Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Died ',
                            ),

                            TextSpan(
                              text: 'November 12, 2018',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  const Text('"I\'ve been the luckiest man in the world because I\'ve had friends, and to have the right friends is everything: people you can depend on, people who tell you the truth if you ask something."', textAlign: TextAlign.center, style: TextStyle(color: Color(0xffffffff),),),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}