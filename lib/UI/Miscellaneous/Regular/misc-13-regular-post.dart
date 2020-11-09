// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';
// import 'misc-04-regular-dropdown.dart';

// class MiscRegularPost extends StatelessWidget{

//   @override
//   Widget build(BuildContext context){
//     return Container(
//       // padding: EdgeInsets.all(10.0),
//       padding: EdgeInsets.only(left: 10.0, right: 10.0,),
//       // height: SizeConfig.blockSizeVertical * 60,
//       decoration: BoxDecoration(
//         color: Color(0xffffffff),
//         borderRadius: BorderRadius.all(Radius.circular(15),),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 0)
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             height: SizeConfig.blockSizeVertical * 10,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: (){
                    
//                   },
//                   child: CircleAvatar(backgroundImage: AssetImage('assets/icons/profile2.png'),),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(left: 10.0),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Align(alignment: Alignment.bottomLeft,
//                             child: Text('Sara Rosario Suarez Sara Rosario Suarez',
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff000000),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Text('an hour ago',
//                               maxLines: 1,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xffaaaaaa)
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 MiscRegularDropDownTemplate(),
//               ],
//             ),
//           ),
//           // Column(
//           //   children: [
//           //     Align(
//           //       alignment: Alignment.topLeft,
//           //       child: RichText(
//           //         maxLines: 4,
//           //         overflow: TextOverflow.clip,
//           //         textAlign: TextAlign.left,
//           //         text: TextSpan(
//           //           text: 'He was someone who was easy to go with. We had a lot of memories together. '
//           //           'We\'ve been travelling all around the world together ever since we graduated college. We will surely miss you Will ❤️❤️❤️',
//           //           style: TextStyle(
//           //             fontWeight: FontWeight.w300,
//           //             color: Color(0xff000000),
//           //           ),
//           //         ),
//           //       ),
//           //     ),

//           //     SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//           //     Align(
//           //       alignment: Alignment.centerLeft,
//           //       child: RichText(
//           //         maxLines: 1,
//           //         overflow: TextOverflow.clip,
//           //         textAlign: TextAlign.left,
//           //         text: TextSpan(
//           //           children: <TextSpan>[
//           //             TextSpan(
//           //               text: 'with ',
//           //               style: TextStyle(
//           //                 fontSize: SizeConfig.safeBlockHorizontal * 3,
//           //                 fontWeight: FontWeight.w300,
//           //                 color: Color(0xffaaaaaa),
//           //               ),
//           //             ),

//           //             TextSpan(
//           //               text: 'William Shaw & John Howard',
//           //               style: TextStyle(
//           //                 fontWeight: FontWeight.bold,
//           //                 color: Color(0xff000000),
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ),

//           //     SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//           //   ],
//           // ),

//           Expanded(child: Container(child: Text('an hour ago',
//                               maxLines: 1,
//                               style: TextStyle(
//                                 fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color(0xffaaaaaa)
//                               ),
//                             ),),),

//           // Column(
//           //   children: [
//           //     Align(
//           //       alignment: Alignment.topLeft,
//           //       child: RichText(
//           //         maxLines: 4,
//           //         overflow: TextOverflow.clip,
//           //         textAlign: TextAlign.left,
//           //         text: TextSpan(
//           //           text: 'He was someone who was easy to go with. We had a lot of memories together. '
//           //           'We\'ve been travelling all around the world together ever since we graduated college. We will surely miss you Will ❤️❤️❤️',
//           //           style: TextStyle(
//           //             fontWeight: FontWeight.w300,
//           //             color: Color(0xff000000),
//           //           ),
//           //         ),
//           //       ),
//           //     ),

//           //     SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//           //     Align(
//           //       alignment: Alignment.centerLeft,
//           //       child: RichText(
//           //         maxLines: 1,
//           //         overflow: TextOverflow.clip,
//           //         textAlign: TextAlign.left,
//           //         text: TextSpan(
//           //           children: <TextSpan>[
//           //             TextSpan(
//           //               text: 'with ',
//           //               style: TextStyle(
//           //                 fontSize: SizeConfig.safeBlockHorizontal * 3,
//           //                 fontWeight: FontWeight.w300,
//           //                 color: Color(0xffaaaaaa),
//           //               ),
//           //             ),

//           //             TextSpan(
//           //               text: 'William Shaw & John Howard',
//           //               style: TextStyle(
//           //                 fontWeight: FontWeight.bold,
//           //                 color: Color(0xff000000),
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ),

//           //     SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//           //   ],
//           // ),
//           // Expanded(
//           //   child: Row(
//           //     children: [
//           //       Expanded(
//           //         flex: 2,
//           //         child: Container(
//           //           decoration: BoxDecoration(
//           //             borderRadius: BorderRadius.circular(10.0),
//           //             image: DecorationImage(
//           //               fit: BoxFit.cover,
//           //               image: AssetImage('assets/icons/blm2.png',),
//           //             ),
//           //           ),
//           //         ),
//           //       ),

//           //       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                
//           //       Expanded(
//           //         child: Column(
//           //           children: [
//           //             Expanded(
//           //               child: Container(
//           //                 decoration: BoxDecoration(
//           //                   borderRadius: BorderRadius.circular(10.0),
//           //                   image: DecorationImage(
//           //                     fit: BoxFit.cover,
//           //                     image: AssetImage('assets/icons/blm3.png',),
//           //                   ),
//           //                 ),
//           //               ),
//           //             ),

//           //             SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//           //             Expanded(
//           //               child: Stack(
//           //                 children: [
//           //                   Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Color(0xff888888),),),

//           //                   Align(child: Text('+4', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 7, color: Color(0xffffffff),),),),
//           //                 ],
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),

//           Container(
//             height: SizeConfig.blockSizeVertical * 10,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: (){},
//                   child: Row(
//                     children: [
//                       Icon(Icons.favorite_rounded, color: Color(0xffE74C3C),),

//                       SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                       Text('24.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                     ],
//                   ),
//                 ),

//                 SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                 GestureDetector(
//                   onTap: (){},
//                   child: Row(
//                     children: [
//                       Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

//                       SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                       Text('14.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: (){},
//                     child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }




import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'misc-04-regular-dropdown.dart';

class MiscRegularPost extends StatelessWidget{

  final List<Widget> contents;

  MiscRegularPost({this.contents});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0,),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.all(Radius.circular(15),),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 0)
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: CircleAvatar(backgroundImage: AssetImage('assets/icons/profile2.png'),),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(alignment: Alignment.bottomLeft,
                            child: Text('Sara Rosario Suarez Sara Rosario Suarez',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('an hour ago',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffaaaaaa)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MiscRegularDropDownTemplate(),
              ],
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              // children: [

              //   Container(
              //     height: SizeConfig.blockSizeHorizontal * 50,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //       image: DecorationImage(
              //         fit: BoxFit.cover,
              //         image: AssetImage('assets/icons/regular-image4.png'),
              //       ),
              //     ),
              //   ),

              // ],
              children: contents,
            ),
          ),

          Container(
            height: SizeConfig.blockSizeVertical * 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){},
                  child: Row(
                    children: [
                      Icon(Icons.favorite_rounded, color: Color(0xffE74C3C),),

                      SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                      Text('24.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                    ],
                  ),
                ),

                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                GestureDetector(
                  onTap: (){},
                  child: Row(
                    children: [
                      Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

                      SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                      Text('14.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){},
                    child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}