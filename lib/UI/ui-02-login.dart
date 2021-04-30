import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Regular/regular-01-join.dart';

class UILogin01 extends StatelessWidget {

  const UILogin01();

  @override
  Widget build(BuildContext context) {
    // SizeConfig.init(context);
    return RepaintBoundary(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [

              const SizedBox(height: 100,),

              Image.asset('assets/icons/logo.png', height: 200, width: 200,),

              const Text('FacesByPlaces.com', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

              const SizedBox(height: 100,),

              const Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),

              const SizedBox(height: 100,),

              const Text('Black Lives Matter', style: const TextStyle(fontSize: 18, color: const Color(0xff000000),),),

              const SizedBox(height: 5),

              MaterialButton(
                padding: EdgeInsets.zero,
                minWidth: SizeConfig.screenWidth! / 1.5,
                height: 35,
                child: Row(
                  children: [
                    CircleAvatar(
                      minRadius: 35,
                      backgroundColor: const Color(0xff000000),
                      child: Center(child: Image.asset('assets/icons/fist.png', height: 20,),),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
                        alignment: Alignment.centerLeft,
                        child: const Text('Speak for a loved one killed by law enforcement', 
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xff000000),),
                        ),
                      ),
                    ),
                  ],
                ),
                shape: const StadiumBorder(),
                color: const Color(0xffF2F2F2),
                onPressed: (){
                  // Navigator.pushNamed(context, '/blm/join');
                },
              ),

              const SizedBox(height: 10),

              const Text('All Lives Matter', style: TextStyle(fontSize: 18, color: const Color(0xff000000),),),

              const SizedBox(height: 5),

              MaterialButton(
                padding: EdgeInsets.zero,
                minWidth: SizeConfig.screenWidth! / 1.5,
                height: 35,
                child: Row(
                  children: [
                    CircleAvatar(
                      minRadius: 35,
                      backgroundColor: const Color(0xff04ECFF),
                      child: const Center(child: const Icon(Icons.favorite, size: 20, color: const Color(0xffffffff),)),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
                        alignment: Alignment.centerLeft,
                        child: const Text('Remembering friends and family',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: const Color(0xff000000),),
                        ),
                      ),
                    ),
                  ],
                ),
                shape: const StadiumBorder(),
                color: const Color(0xffE6FDFF),
                onPressed: (){
                  // Navigator.pushNamed(context, '/regular/join');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegularJoin()));
                },
              ),
              
              const SizedBox(height: 5),

              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Already have an account? ', 
                      style: const TextStyle(
                        fontSize: 16,
                        color: const Color(0xff000000),
                      ),
                    ),

                    TextSpan(
                      text: 'Login', 
                      style: const TextStyle(
                        fontSize: 16,
                        color: const Color(0xff04ECFF),
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        // Navigator.pushNamed(context, '/regular/login');
                      }
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100,),

            ],
          ),
        ),
      ),
    );
  }
}