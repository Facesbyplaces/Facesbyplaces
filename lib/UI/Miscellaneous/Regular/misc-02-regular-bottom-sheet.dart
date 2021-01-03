// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// class MiscRegularBottomSheet extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
//     return BlocBuilder<BlocHomeRegularUpdateToggle, List<bool>>(
//       builder: (context, state){
//         return Container(
//           height: ScreenUtil().setHeight(65),
//           alignment: Alignment.center,
//           width: SizeConfig.screenWidth,
//           child: ToggleButtons(
//             borderWidth: 0,
//             renderBorder: false,
//             selectedColor: Color(0xff04ECFF),
//             fillColor: Colors.transparent,
//             color: Color(0xffB1B1B1),
//             children: [

//               Container(
//                 width: SizeConfig.screenWidth / 4,
//                 child: Column(
//                   children: [
//                     Icon(MdiIcons.fire, size: ScreenUtil().setHeight(25),),
//                     SizedBox(height: SizeConfig.blockSizeVertical * 1),
//                     Text('Feed', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
//                   ],
//                 ),
//               ),

//               Container(
//                 width: SizeConfig.screenWidth / 4,
//                 child: Column(
//                   children: [
//                     Icon(MdiIcons.graveStone, size: ScreenUtil().setHeight(25),),
//                     SizedBox(height: SizeConfig.blockSizeVertical * 1),
//                     Text('Memorials', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
//                   ],
//                 ),
//               ),

//               Container(
//                 width: SizeConfig.screenWidth / 4,
//                 child: Column(
//                   children: [
//                     Icon(MdiIcons.post, size: ScreenUtil().setHeight(25),),
//                     SizedBox(height: SizeConfig.blockSizeVertical * 1),
//                     Text('Post', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
//                   ],
//                 ),
//               ),

//               Container(
//                 width: SizeConfig.screenWidth / 4,
//                 child: Column(
//                   children: [
//                     Icon(MdiIcons.heart, size: ScreenUtil().setHeight(25),),
//                     SizedBox(height: SizeConfig.blockSizeVertical * 1),
//                     Text('Notification', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
//                   ],
//                 ),
//               ),

//             ],
//             onPressed: (int index) async{
//               context.bloc<BlocHomeRegularUpdateToggle>().updateToggle(index);
//               switch(index){
//                 case 0: context.bloc<BlocHomeRegularUpdateCubit>().modify(0); break;
//                 case 1: context.bloc<BlocHomeRegularUpdateCubit>().modify(1); break;
//                 case 2: context.bloc<BlocHomeRegularUpdateCubit>().modify(2); break;
//                 case 3: context.bloc<BlocHomeRegularUpdateCubit>().modify(3); break;
//               }
//             },
//             isSelected: context.bloc<BlocHomeRegularUpdateToggle>().state,
//           ),
          
//           decoration: BoxDecoration(
//             color: Color(0xffffffff),
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 blurRadius: 5,
//                 spreadRadius: 1,
//                 offset: Offset(0, 0)
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class MiscRegularBottomSheetComment extends StatefulWidget{
  MiscRegularBottomSheetComment({Key key}) : super(key: key);

  MiscRegularBottomSheetCommentState createState() => MiscRegularBottomSheetCommentState();
}

class MiscRegularBottomSheetCommentState extends State<MiscRegularBottomSheetComment>{

  TextEditingController controller;

  void initState(){
    super.initState();
    controller = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Row(
      children: [

        CircleAvatar(backgroundColor: Color(0xff888888),),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: controller,
              cursorColor: Color(0xff000000),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                fillColor: Color(0xffBDC3C7),
                filled: true,
                labelText: 'Say something...',
                labelStyle: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4, 
                  color: Color(0xffffffff),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffBDC3C7),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffBDC3C7),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),

        Container(
          child: Text('Post',
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              fontWeight: FontWeight.bold, 
              color: Color(0xff000000),
            ),
          ),
        ),
      ],
    );
  }
}