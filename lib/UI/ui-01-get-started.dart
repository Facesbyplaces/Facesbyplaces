// import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class UIGetStarted extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Stack(
//       children: [

//         Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               fit: BoxFit.cover,
//               image: AssetImage('assets/icons/background.png'),
//               colorFilter: ColorFilter.srgbToLinearGamma(),
//             ),
//           ),
//         ),

//         Column(
//           children: [

//             SizedBox(height: SizeConfig.blockSizeVertical * 15,),

//             Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 30,),),

//             SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//             Center(
//               child: Text('FacesByPlaces.com', 
//                 style: TextStyle(
//                   fontSize: SizeConfig.safeBlockHorizontal * 5,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff04ECFF),
//                 ),
//               ),
//             ),

//             SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//             Padding(
//               padding: EdgeInsets.only(left: 20.0, right: 20.0),
//               child: Center(
//                 child: Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations', 
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: SizeConfig.safeBlockHorizontal * 5,
//                     fontFamily: 'Roboto',
//                     color: Color(0xffffffff),
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//             MaterialButton(
//               onPressed: (){
//                 context.bloc<BlocUpdateCubit>().modify(1);
//               },
//               minWidth: SizeConfig.screenWidth / 1.5,
//               height: SizeConfig.blockSizeVertical * 7,
//               child: Text('Get Started',
//                 style: TextStyle(
//                   fontSize: SizeConfig.safeBlockHorizontal * 4,
//                   color: Color(0xffffffff),
//                 ),
//               ),
//               shape: StadiumBorder(),
//               color: Color(0xff04ECFF),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }



// ====================================================================================================================================



// import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class UIGetStarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [

        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/icons/background.png'),
              colorFilter: ColorFilter.srgbToLinearGamma(),
            ),
          ),
        ),

        Column(
          children: [

            SizedBox(height: SizeConfig.blockSizeVertical * 15,),

            Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 30,),),

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),

            Center(
              child: Text('FacesByPlaces.com', 
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff04ECFF),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Center(
                child: Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations', 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontFamily: 'Roboto',
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),

            MaterialButton(
              onPressed: (){
                // context.bloc<BlocUpdateCubit>().modify(1);
                Navigator.pushNamed(context, 'ui-02-login');
              },
              minWidth: SizeConfig.screenWidth / 1.5,
              height: SizeConfig.blockSizeVertical * 7,
              child: Text('Get Started',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  color: Color(0xffffffff),
                ),
              ),
              shape: StadiumBorder(),
              color: Color(0xff04ECFF),
            ),
          ],
        ),
      ],
    );
  }
}