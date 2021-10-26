import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget{
  const UILogin01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint){
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 50,),

                      Image.asset('assets/icons/logo.png', height: 300, width: 300,),

                      const SizedBox(height: 20,),
                      
                      const Text('FacesByPlaces.com', style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaBold'),),

                      const SizedBox(height: 50,),
                      
                      const Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'NexaBold', fontSize: 22, color: Color(0xff000000),),),

                      const SizedBox(height: 50,),
                      
                      const Text('Black Lives Matter', style: TextStyle(fontSize: 22, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                      const SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MaterialButton(
                          color: const Color(0xffF2F2F2),
                          shape: const StadiumBorder(),
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                child: Center(child: Image.asset('assets/icons/fist.png',),),
                                backgroundColor: const Color(0xff000000),
                              ),

                              const Expanded(
                                child: Padding(
                                  child: Text('Speak for a loved one killed by law enforcement', style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaRegular'),),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ],
                          ),
                          onPressed: (){
                            Navigator.pushNamed(context, '/blm/join');
                          },
                        ),
                      ),

                      const SizedBox(height: 30,),

                      const Text('All Lives Matter', style: TextStyle(fontSize: 22, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                      const SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: MaterialButton(
                          color: const Color(0xffE6FDFF),
                          shape: const StadiumBorder(),
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: const [
                              CircleAvatar(
                                child: Icon(Icons.favorite, size: 50, color: Color(0xffffffff),),
                                backgroundColor: Color(0xff04ECFF),
                                minRadius: 35,
                              ),

                              Expanded(
                                child: Padding(
                                  child: Text('Remembering friends and family', style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaRegular'),),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ],
                          ),
                          onPressed: (){
                            Navigator.pushNamed(context, '/regular/join');
                          },
                        ),
                      ),

                      const SizedBox(height: 50,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(text: 'Already have an Account? ', style: TextStyle(fontSize: 22, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                            TextSpan(
                              style: const TextStyle(fontSize: 22, color: Color(0xff04ECFF), fontFamily: 'NexaRegular',),
                              text: 'Login',
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.pushNamed(context, '/regular/login');
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}