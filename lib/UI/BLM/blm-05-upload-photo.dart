// import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/UI/Home/home-01-home.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class BLMUploadPhoto extends StatefulWidget{

//   BLMUploadPhotoState createState() => BLMUploadPhotoState();
// }

// class BLMUploadPhotoState extends State<BLMUploadPhoto>{

//   File _image;
//   final _picker = ImagePicker();

//   Future getImage() async{
//     final pickedFile = await _picker.getImage(source: ImageSource.gallery);

//     if(pickedFile != null){
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Scaffold(
//       body: Stack(
//         children: [

//           Container(
//             color: Color(0xffffffff),
//           ),

//           BlocBuilder<BlocShowMessage, bool>(
//             builder: (context, state){
//               return context.bloc<BlocShowMessage>().state 
//               ? Padding(
//                 padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8,),
//                 child: Align(
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     height: SizeConfig.blockSizeVertical * 5,
//                     width: SizeConfig.screenWidth / 1.2,
//                     child: Center(
//                       child: Text('Please upload a valid photo / image', 
//                         textAlign: TextAlign.center, 
//                         style: TextStyle(
//                           fontSize: SizeConfig.safeBlockHorizontal * 4,
//                           fontWeight: FontWeight.w300,
//                           color: Color(0xffffffff),
//                         ),
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       color: Color(0xff000000),
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                   ),
//                 ),
//               )
//               : Container();
//             },
//           ),

//           Padding(
//             padding: EdgeInsets.only(left: 20.0, right: 20.0),
//             child: Column(
//               children: [

//                 SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                 Center(
//                   child: Text('Upload Photo', 
//                     style: TextStyle(
//                       fontSize: SizeConfig.safeBlockHorizontal * 8,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xff000000),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                 GestureDetector(
//                   onTap: () async{
//                     context.bloc<BlocUpdateButtonText>().add();

//                     var choice = await showDialog(context: (context), builder: (build) => UploadFrom());

//                     if(choice == null){
//                       choice = 0;
//                     }else{
//                       if(choice == 1){

//                       }else{
//                         await getImage();
//                       }
//                     }

//                     context.bloc<BlocUpdateButtonText>().reset();
                    
//                   },
//                   child: Container(
//                     child: Column(
//                       children: [
//                         Expanded(
//                           flex: 4,
//                           child: Padding(
//                             padding: EdgeInsets.all(15.0),
//                             child: _image != null
//                             ? Stack(
//                               children: [
//                                 Container(color: Color(0xffffffff),),

//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Image.asset(_image.path),
//                                 ),
//                               ],
//                             )
//                             : Stack(
//                               children: [
//                                 Container(color: Color(0xffffffff),),

//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Icon(Icons.add, color: Color(0xffE3E3E3), size: SizeConfig.safeBlockVertical * 30,),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Center(
//                             child: Text('Select a photo',
//                               style: TextStyle(
//                                 fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                 fontWeight: FontWeight.w300,
//                                 color: Color(0xff000000),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     height: SizeConfig.blockSizeVertical * 50,
//                     width: SizeConfig.screenWidth / 1.2,
//                     color: Color(0xffF9F8EE),
//                   ),
//                 ),

//                 SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//                 BlocBuilder<BlocUpdateButtonText, int>(
//                   builder: (context, state){
//                     return context.bloc<BlocUpdateButtonText>().state != 0
//                     ? MaterialButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: (){
//                         context.bloc<BlocShowMessage>().showMessage();

//                         Duration duration = Duration(seconds: 2);

//                         Future.delayed(duration, (){
//                           context.bloc<BlocShowMessage>().showMessage();
//                         });
//                       },

//                       child: Text('Sign Up',
//                         style: TextStyle(
//                           fontSize: SizeConfig.safeBlockHorizontal * 5,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xffffffff),
//                         ),
//                       ),

//                       minWidth: SizeConfig.screenWidth / 2,
//                       height: SizeConfig.blockSizeVertical * 7,
//                       shape: StadiumBorder(),
//                       color: Color(0xff4EC9D4)
//                     )
//                     : MaterialButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: (){

//                         if(_image != null){
//                           context.bloc<BlocUpdateCubit>().modify(0); // RESETS THE UPDATE CUBIT TO ZERO
//                           context.bloc<BlocUpdateCubitBLM>().modify(0); // RESETS THE UPDATE CUBIT BLM TO ZERO
//                           context.bloc<BlocShowMessage>().reset();
//                           context.bloc<BlocUpdateButtonText>().reset();
                          
//                           Route newRoute = PageRouteBuilder(pageBuilder: (__, _, ___) => HomeScreen());
//                           Navigator.pushReplacement(context, newRoute);
                          
//                         }else{
//                           context.bloc<BlocShowMessage>().showMessage();

//                           Duration duration = Duration(seconds: 2);

//                           Future.delayed(duration, (){
//                             context.bloc<BlocShowMessage>().showMessage();
//                           });
//                         }
//                       },

//                       child: Text('Speak Now',
//                         style: TextStyle(
//                           fontSize: SizeConfig.safeBlockHorizontal * 5,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xffffffff),
//                         ),
//                       ),

//                       minWidth: SizeConfig.screenWidth / 2,
//                       height: SizeConfig.blockSizeVertical * 7,
//                       shape: StadiumBorder(),
//                       color: Color(0xff000000)
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// ====================================================================================================================================

import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/home-01-home.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


// class BLMUploadPhoto extends StatefulWidget{

//   BLMUploadPhotoState createState() => BLMUploadPhotoState();
// }


class BLMUploadPhoto extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateProfilePicture>(
          create: (context) => BlocUpdateProfilePicture(),
        ),
        BlocProvider<BlocShowMessage>(
          create: (context) => BlocShowMessage(),
        ),
      ], 
      child: Scaffold(
        body: Stack(
          children: [

            Container(color: Color(0xffffffff),),

            BlocBuilder<BlocShowMessage, bool>(
              builder: (context, state){
                return ((){
                  if(state){
                    return Padding(
                      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8,),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          width: SizeConfig.screenWidth / 1.2,
                          child: Center(
                            child: Text('Please upload a valid photo / image', 
                              textAlign: TextAlign.center, 
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w300,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff000000),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }
                }());
              },
            ),

            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Center(
                    child: Text('Upload Photo', 
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  // BlocBuilder<BlocUpdateProfilePicture, Future<File>>(
                  //   builder: (context, state){
                  //     return GestureDetector(
                  //       onTap: (){

                  //       },
                  //       child: Container(
                  //         child: Column(
                  //           children: [
                  //             Expanded(
                  //               flex: 4,
                  //               child: Padding(
                  //                 padding: EdgeInsets.all(15.0),
                  //                 child: StatelessElement != null
                  //                 ? Stack(
                  //                   children: [
                  //                     Container(color: Color(0xffffffff),),

                  //                     Align(
                  //                       alignment: Alignment.center,
                  //                       child: Image.asset(state.path),
                  //                     ),
                  //                   ],
                  //                 )
                  //                 : Stack(
                  //                   children: [
                  //                     Container(color: Color(0xffffffff),),

                  //                     Align(
                  //                       alignment: Alignment.center,
                  //                       child: Icon(Icons.add, color: Color(0xffE3E3E3), size: SizeConfig.safeBlockVertical * 30,),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Center(
                  //                 child: Text('Select a photo',
                  //                   style: TextStyle(
                  //                     fontSize: SizeConfig.safeBlockHorizontal * 4,
                  //                     fontWeight: FontWeight.w300,
                  //                     color: Color(0xff000000),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         height: SizeConfig.blockSizeVertical * 50,
                  //         width: SizeConfig.screenWidth / 1.2,
                  //         color: Color(0xffF9F8EE),
                  //       ),
                  //     );
                  //   },
                  // ),

                  // GestureDetector(
                  //   onTap: () async{
                  //     var choice = await showDialog(context: (context), builder: (build) => UploadFrom());
                      
                  //     if(choice == null){
                  //       choice = 0;
                  //     }else{
                  //       if(choice == 1){

                  //       }else{
                          
                  //       }
                  //     }
                  //   },
                  // ),

                  // GestureDetector(
                  //   onTap: () async{
                  //     // context.bloc<BlocUpdateButtonText>().add();

                  //     // var choice = await showDialog(context: (context), builder: (build) => UploadFrom());

                  //     // if(choice == null){
                  //     //   choice = 0;
                  //     // }else{
                  //     //   if(choice == 1){

                  //     //   }else{
                  //     //     await getImage();
                  //     //   }
                  //     // }



                  //     context.bloc<BlocUpdateButtonText>().reset();
                      
                  //   },
                  //   child: Container(),
                  //   // child: Container(
                  //   //   child: Column(
                  //   //     children: [
                  //   //       Expanded(
                  //   //         flex: 4,
                  //   //         child: Padding(
                  //   //           padding: EdgeInsets.all(15.0),
                  //   //           child: _image != null
                  //   //           ? Stack(
                  //   //             children: [
                  //   //               Container(color: Color(0xffffffff),),

                  //   //               Align(
                  //   //                 alignment: Alignment.center,
                  //   //                 child: Image.asset(_image.path),
                  //   //               ),
                  //   //             ],
                  //   //           )
                  //   //           : Stack(
                  //   //             children: [
                  //   //               Container(color: Color(0xffffffff),),

                  //   //               Align(
                  //   //                 alignment: Alignment.center,
                  //   //                 child: Icon(Icons.add, color: Color(0xffE3E3E3), size: SizeConfig.safeBlockVertical * 30,),
                  //   //               ),
                  //   //             ],
                  //   //           ),
                  //   //         ),
                  //   //       ),
                  //   //       Expanded(
                  //   //         child: Center(
                  //   //           child: Text('Select a photo',
                  //   //             style: TextStyle(
                  //   //               fontSize: SizeConfig.safeBlockHorizontal * 4,
                  //   //               fontWeight: FontWeight.w300,
                  //   //               color: Color(0xff000000),
                  //   //             ),
                  //   //           ),
                  //   //         ),
                  //   //       ),
                  //   //     ],
                  //   //   ),
                  //   //   height: SizeConfig.blockSizeVertical * 50,
                  //   //   width: SizeConfig.screenWidth / 1.2,
                  //   //   color: Color(0xffF9F8EE),
                  //   // ),
                  // ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                  BlocBuilder<BlocUpdateButtonText, int>(
                    builder: (context, state){
                      return context.bloc<BlocUpdateButtonText>().state != 0
                      ? MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          context.bloc<BlocShowMessage>().showMessage();

                          Duration duration = Duration(seconds: 2);

                          Future.delayed(duration, (){
                            context.bloc<BlocShowMessage>().showMessage();
                          });
                        },

                        child: Text('Sign Up',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),

                        minWidth: SizeConfig.screenWidth / 2,
                        height: SizeConfig.blockSizeVertical * 7,
                        shape: StadiumBorder(),
                        color: Color(0xff4EC9D4)
                      )
                      : MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){

                          // if(_image != null){
                          //   context.bloc<BlocUpdateCubit>().modify(0); // RESETS THE UPDATE CUBIT TO ZERO
                          //   context.bloc<BlocUpdateCubitBLM>().modify(0); // RESETS THE UPDATE CUBIT BLM TO ZERO
                          //   context.bloc<BlocShowMessage>().reset();
                          //   context.bloc<BlocUpdateButtonText>().reset();
                            
                          //   Route newRoute = PageRouteBuilder(pageBuilder: (__, _, ___) => HomeScreen());
                          //   Navigator.pushReplacement(context, newRoute);
                            
                          // }else{
                          //   context.bloc<BlocShowMessage>().showMessage();

                          //   Duration duration = Duration(seconds: 2);

                          //   Future.delayed(duration, (){
                          //     context.bloc<BlocShowMessage>().showMessage();
                          //   });
                          // }
                        },

                        child: Text('Speak Now',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),

                        minWidth: SizeConfig.screenWidth / 2,
                        height: SizeConfig.blockSizeVertical * 7,
                        shape: StadiumBorder(),
                        color: Color(0xff000000)
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

