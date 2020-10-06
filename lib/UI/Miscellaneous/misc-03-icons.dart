import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscIconToggle extends StatelessWidget {
  final IconData icon;
  final String text;

  MiscIconToggle({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      alignment: Alignment.center,
      width: SizeConfig.screenWidth / 4,
      child: Column(
        children: [
          Icon(icon, size: SizeConfig.blockSizeVertical * 5,),

          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

          Center(
            child: Text(text,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 3,
                color: Color(0xffB1B1B1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MiscIconToggleFeed extends StatelessWidget {
//   // final IconData icon;
//   final String text;

//   MiscIconToggleFeed({this.text});

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Container(
//       alignment: Alignment.center,
//       width: SizeConfig.screenWidth / 4,
//       child: Column(
//         children: [

//           // Container(
//           //   // padding: EdgeInsets.only(left: 20.0, right: 20.0),
//           //   child: Align(
//           //     alignment: Alignment.center,
//           //     child: Text(text,
//           //       style: TextStyle(
//           //         // decoration: TextDecoration.underline,
//           //         fontSize: SizeConfig.safeBlockHorizontal * 4,
//           //         fontWeight: FontWeight.bold,
//           //       ),
//           //     ),
//           //   ),
//           //   decoration: BoxDecoration(
//           //     border: Border(bottom: BorderSide(width: 5)),
//           //     // top: BorderSide.none, left: BorderSide.none, right: BorderSide.none, 
//           //   ),
//           // ),

//           Align(
//             alignment: Alignment.center,
//             child: Text(text,
//               style: TextStyle(
//                 fontSize: SizeConfig.safeBlockHorizontal * 4,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }