
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc-start-misc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class UINewlyInstalled extends StatefulWidget{

  UINewlyInstalledState createState() => UINewlyInstalledState();
}

class UINewlyInstalledState extends State<UINewlyInstalled> with TickerProviderStateMixin{

  List<Widget> screens = [UINewlyInstalled01(), UINewlyInstalled02(), UINewlyInstalled03()];

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
    return BlocProvider(
      create: (BuildContext context) => BlocMiscStartNewlyInstalled(),
      child: BlocBuilder<BlocMiscStartNewlyInstalled, int>(
        builder: (context, content){
          return RepaintBoundary(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: const Color(0xffeeeeee),
                body: IndexedStack(
                  index: content,
                  children: screens,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UINewlyInstalled01 extends StatefulWidget{

  UINewlyInstalled01State createState() => UINewlyInstalled01State();
}

class UINewlyInstalled01State extends State<UINewlyInstalled01>{

  final TabController controller = TabController(initialIndex: 0, length: 3, vsync: UINewlyInstalledState());

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff).withOpacity(0.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage('assets/icons/stephen-hawking.jpeg'),
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: const Color(0xffffffff).withOpacity(0.0)),
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

                  const Text('Stephen Hawking',
                    style: const TextStyle(
                      fontSize: 24,
                      color: const Color(0xff04ECFF),
                    )
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.starOutline, color: const Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: const TextSpan(
                          children: const <TextSpan>[
                            const TextSpan(text: 'Born ',),

                            const TextSpan(
                              text: 'January 8, 1942',
                              style: const TextStyle(
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
                      const Icon(MdiIcons.graveStone, color: const Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: const TextSpan(
                          children: const <TextSpan>[
                            const TextSpan(text: 'Died ',),

                            const TextSpan(
                              text: 'March 14, 2018',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  const Text('"If human life were long enough to find the ultimate theory, everything would have been solved by previous generations. Nothing would be left to be discovered."', textAlign: TextAlign.center, style: const TextStyle(color: const Color(0xffffffff),),),

                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 100,
                    child: TabBar(
                      controller: controller,
                      isScrollable: false,
                      labelColor: const Color(0xff04ECFF),
                      unselectedLabelColor: const Color(0xffCDEAEC),
                      indicatorColor: const Color(0xff04ECFF),
                      indicator: BoxDecoration(
                        color: Colors.transparent
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        const Icon(Icons.circle, size: 15,),

                        const Icon(Icons.circle, size: 15,),

                        const Icon(Icons.circle, size: 15,),
                      ],
                    ),
                  ),

                  MaterialButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Next', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),
                    minWidth: 200,
                    height: 45,
                    shape: const StadiumBorder(),
                    color: const Color(0xff04ECFF),
                    onPressed: (){
                      context.read<BlocMiscStartNewlyInstalled>().modify(1);
                    },
                  ),

                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UINewlyInstalled02 extends StatefulWidget{

  UINewlyInstalled02State createState() => UINewlyInstalled02State();
}

class UINewlyInstalled02State extends State<UINewlyInstalled02>{

  final TabController controller = TabController(initialIndex: 1, length: 3, vsync: UINewlyInstalledState());

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
                decoration: new BoxDecoration(color: const Color(0xffffffff).withOpacity(0.0)),
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

                  const Text('Kobe Bryant',
                    style: const TextStyle(
                      fontSize: 24,
                      color: const Color(0xff04ECFF),
                    )
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.starOutline, color: const Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            const TextSpan(text: 'Born ',),

                            const TextSpan(
                              text: 'August 23, 1978',
                              style: const TextStyle(
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
                      const Icon(MdiIcons.graveStone, color: const Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: const TextSpan(
                          children: const <TextSpan>[
                            const TextSpan(text: 'Died ',),

                            const TextSpan(
                              text: 'January 26, 2020',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  const Text('"I\'ll do whatever it takes to win games, whether it\'s sitting on a bench waving a towel, handing a cup of water to a teammate, or hitting the game-winning shot."', textAlign: TextAlign.center, style: const TextStyle(color: const Color(0xffffffff),),),

                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 100,
                    child: TabBar(
                      controller: controller,
                      isScrollable: false,
                      labelColor: const Color(0xff04ECFF),
                      unselectedLabelColor: const Color(0xffCDEAEC),
                      indicatorColor: const Color(0xff04ECFF),
                      indicator: BoxDecoration(
                        color: Colors.transparent
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        const Icon(Icons.circle, size: 15,),

                        const Icon(Icons.circle, size: 15,),

                        const Icon(Icons.circle, size: 15,),
                      ],
                    ),
                  ),

                  MaterialButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Next', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),
                    minWidth: 200,
                    height: 45,
                    shape: const StadiumBorder(),
                    color: const Color(0xff04ECFF),
                    onPressed: (){
                      context.read<BlocMiscStartNewlyInstalled>().modify(2);
                    },
                  ),

                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UINewlyInstalled03 extends StatefulWidget{

  UINewlyInstalled03State createState() => UINewlyInstalled03State();
}

class UINewlyInstalled03State extends State<UINewlyInstalled03>{

  final TabController controller = TabController(initialIndex: 2, length: 3, vsync: UINewlyInstalledState());

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff).withOpacity(0.5),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: const AssetImage('assets/icons/stan-lee.jpeg'),
              ),
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                decoration: new BoxDecoration(color: const Color(0xffffffff).withOpacity(0.0)),
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

                  const Text('Stan Lee',
                    style: const TextStyle(
                      fontSize: 24,
                      color: const Color(0xff04ECFF),
                    )
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(MdiIcons.starOutline, color: const Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: const TextSpan(
                          children: const <TextSpan>[
                            const TextSpan(text: 'Born ',),

                            const TextSpan(
                              text: 'December 28, 1922',
                              style: const TextStyle(
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
                      const Icon(MdiIcons.graveStone, color: const Color(0xffffffff),),
                      
                      const SizedBox(width: 5,),

                      RichText(
                        text: const TextSpan(
                          children: const <TextSpan>[
                            const TextSpan(text: 'Died ',),

                            const TextSpan(
                              text: 'November 12, 2018',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  const Text('"I\'ve been the luckiest man in the world because I\'ve had friends, and to have the right friends is everything: people you can depend on, people who tell you the truth if you ask something."', textAlign: TextAlign.center, style: const TextStyle(color: const Color(0xffffffff),),),

                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 100,
                    child: TabBar(
                      controller: controller,
                      isScrollable: false,
                      labelColor: const Color(0xff04ECFF),
                      unselectedLabelColor: const Color(0xffCDEAEC),
                      indicatorColor: const Color(0xff04ECFF),
                      indicator: BoxDecoration(
                        color: Colors.transparent
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        const Icon(Icons.circle, size: 15,),

                        const Icon(Icons.circle, size: 15,),

                        const Icon(Icons.circle, size: 15,),
                      ],
                    ),
                  ),

                  MaterialButton(
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

                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



          // body: TabBarView(
          //   children: screens,
          // ),
          // body: BlocProvider(
          //   create: (BuildContext context) => BlocMiscStartNewlyInstalled(),
          //   child: BlocBuilder<BlocMiscStartNewlyInstalled, int>(
          //     builder: (context, content){
          //       return TabBarView(
          //         children: screens,
          //       );
          //     },
          //   ),
          // ),


    // return BlocProvider(
    //   create: (BuildContext context) => BlocMiscStartNewlyInstalled(),
    //   child: BlocBuilder<BlocMiscStartNewlyInstalled, int>(
    //     builder: (context, content){
    //       return RepaintBoundary(
    //         // child: IndexedStack(
    //         //       index: content,
    //         //       children: screens,
    //         //     ),
    //         child: DefaultTabController(
    //           length: 3,
    //           child: Scaffold(
    //             backgroundColor: const Color(0xffeeeeee),
    //             body: Container(
    //               height: SizeConfig.screenHeight,
    //               child: TabBarView(
    //                 children: screens,
    //               ),
    //             ),
    //             // body: Stack(
    //             //   children: [
    //             //     Container(
    //             //       height: SizeConfig.screenHeight,
    //             //       // child: TabBarView(
    //             //       //   children: screens,
    //             //       // ),
    //             //       child: IndexedStack(
    //             //         index: content,
    //             //         children: screens,
    //             //       ),
    //             //     ),
    //             //   ],
    //             // ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );