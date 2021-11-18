// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// class UILogin01 extends StatelessWidget{
//   const UILogin01({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraint){
//           return SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minHeight: constraint.maxHeight),
//               child: IntrinsicHeight(
//                 child: SafeArea(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 50,),

//                       Image.asset('assets/icons/logo.png', height: 300, width: 300,),

//                       const SizedBox(height: 20,),
                      
//                       const Text('FacesByPlaces.com', style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaBold'),),

//                       const SizedBox(height: 50,),
                      
//                       const Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'NexaBold', fontSize: 22, color: Color(0xff000000),),),

//                       const SizedBox(height: 50,),
                      
//                       const Text('Black Lives Matter', style: TextStyle(fontSize: 22, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

//                       const SizedBox(height: 10,),

//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: MaterialButton(
//                           color: const Color(0xffF2F2F2),
//                           shape: const StadiumBorder(),
//                           padding: EdgeInsets.zero,
//                           child: Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 35,
//                                 child: Center(child: Image.asset('assets/icons/fist.png',),),
//                                 backgroundColor: const Color(0xff000000),
//                               ),

//                               const Expanded(
//                                 child: Padding(
//                                   child: Text('Speak for a loved one killed by law enforcement', style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaRegular'),),
//                                   padding: EdgeInsets.symmetric(horizontal: 10),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           onPressed: (){
//                             Navigator.pushNamed(context, '/blm/join');
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 30,),

//                       const Text('All Lives Matter', style: TextStyle(fontSize: 22, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

//                       const SizedBox(height: 10,),

//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: MaterialButton(
//                           color: const Color(0xffE6FDFF),
//                           shape: const StadiumBorder(),
//                           padding: EdgeInsets.zero,
//                           child: Row(
//                             children: const [
//                               CircleAvatar(
//                                 child: Icon(Icons.favorite, size: 50, color: Color(0xffffffff),),
//                                 backgroundColor: Color(0xff04ECFF),
//                                 minRadius: 35,
//                               ),

//                               Expanded(
//                                 child: Padding(
//                                   child: Text('Remembering friends and family', style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaRegular'),),
//                                   padding: EdgeInsets.symmetric(horizontal: 10),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           onPressed: (){
//                             Navigator.pushNamed(context, '/regular/join');
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 50,),

//                       RichText(
//                         text: TextSpan(
//                           children: <TextSpan>[
//                             const TextSpan(text: 'Already have an Account? ', style: TextStyle(fontSize: 22, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

//                             TextSpan(
//                               style: const TextStyle(fontSize: 22, color: Color(0xff04ECFF), fontFamily: 'NexaRegular',),
//                               text: 'Login',
//                               recognizer: TapGestureRecognizer()
//                               ..onTap = (){
//                                 Navigator.pushNamed(context, '/regular/login');
//                               },
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 10,),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




// import 'package:flutter/gestures.dart';
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
                  child: Align(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),

                        Image.asset('assets/icons/logo.png', height: 150, width: 150,),

                        const SizedBox(height: 30,),

                        // const Text('Keeping friends and family\n Legacy and memories alive', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, color: Color(0xff2F353D), fontFamily: 'NexaBold'),),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text('Keeping the legacy and memories of family and friends alive', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, color: Color(0xff2F353D), fontFamily: 'NexaBold'),),
                        ),

                        const SizedBox(height: 50,),

                        const Text('Memorial', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                        const SizedBox(height: 10,),

                        // MaterialButton(
                        //   padding: EdgeInsets.zero,
                        //   color: const Color(0xff000000),
                        //   child: Image.asset('assets/icons/fist.png', width: 80, height: 80,),
                        //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        //   onPressed: (){
                        //     Navigator.pushNamed(context, '/blm/join');
                        //   },
                        // ),

                       MaterialButton(
                          padding: EdgeInsets.zero,
                          color: const Color(0xff000000),
                          child: const Icon(Icons.search, size: 80, color: Color(0xffffffff),),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: (){
                            Navigator.pushNamed(context, '/blm/join');
                          },
                        ),

                        const SizedBox(height: 10,),

                        const Text('Resources', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                        const SizedBox(height: 30,),

                        const Text('Create', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                        const SizedBox(height: 10,),

                        MaterialButton(
                          padding: EdgeInsets.zero,
                          color: const Color(0xff04ECFF),
                          child: const Icon(Icons.favorite, size: 80, color: Color(0xffffffff),),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: (){
                            // Navigator.pushNamed(context, '/regular/join');
                            Navigator.pushReplacementNamed(context, '/home/regular');
                          },
                        ),

                        const SizedBox(height: 10,),

                        const Text('Memorial', style: TextStyle(fontSize: 28, color: Color(0xff000000), fontFamily: 'NexaRegular'),),
                        
                        const Expanded(child: SizedBox()),

                        const SizedBox(height: 50,),

                        // RichText(
                        //   text: TextSpan(
                        //     children: <TextSpan>[
                        //       const TextSpan(text: 'Already have an Account? ', style: TextStyle(fontSize: 22, color: Color(0xff000000), fontFamily: 'NexaRegular'),),

                        //       TextSpan(
                        //         style: const TextStyle(fontSize: 22, color: Color(0xff04ECFF), fontFamily: 'NexaRegular',),
                        //         text: 'Login',
                        //         recognizer: TapGestureRecognizer()
                        //         ..onTap = (){
                        //           Navigator.pushNamed(context, '/regular/login');
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // const SizedBox(height: 10,),
                      ],
                    ),
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