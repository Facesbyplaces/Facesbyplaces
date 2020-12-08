// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-13-blm-setting-detail.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';

// class HomeBLMMemorialSettingsPage extends StatelessWidget{

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return ListView(
//       physics: ClampingScrollPhysics(),
//       children: [

//         MiscBLMSettingDetailTemplate(
//           onTap: (){
//             Navigator.pushNamed(context, '/home/blm/home-11-blm-page-details');
//           },
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         MiscBLMSettingDetailTemplate(
//           onTap: (){
//             // Navigator.pushNamed(context, '/home/blm/home-07-03-blm-create-memorial');
//             Navigator.pushNamed(context, '/home/blm/home-21-blm-memorial-page-image');
//           }, 
//           titleDetail: 'Page Image', 
//           contentDetail: 'Update Page image and background image',
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         MiscBLMSettingDetailTemplate(onTap: (){
//           Navigator.pushNamed(context, '/home/blm/home-26-blm-page-managers');
//         }, 
//           titleDetail: 'Admins', 
//           contentDetail: 'Add or remove admins of this page',
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         MiscBLMSettingDetailTemplate(onTap: (){
//           Navigator.pushNamed(context, '/home/blm/home-27-blm-page-family');
//         }, 
//           titleDetail: 'Family', 
//           contentDetail: 'Add or remove family of this page',
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         MiscBLMSettingDetailTemplate(onTap: (){
//           Navigator.pushNamed(context, '/home/blm/home-28-blm-page-friends');
//         }, 
//           titleDetail: 'Friends', 
//           contentDetail: 'Add or remove friends of this page',
//         ),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Paypal', contentDetail: 'Manage cards that receives the memorial gifts.'),

//         Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//         MiscBLMSettingDetailTemplate(
//           onTap: () async{
//             bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(),);

//             if(confirmResult){

//               // context.showLoaderOverlay();
//               // // bool result = await apiBLMDeleteMemorial();
//               // context.hideLoaderOverlay();

//               // if(result){
//               //   Navigator.popUntil(context, ModalRoute.withName('/home/blm'));
//               // }else{
//               //   await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
//               // }
//             }
//           }, 
//           titleDetail: 'Delete Page', 
//           contentDetail: 'Completely remove the page. This is irreversible',
//         ),

//         SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//         Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

//         SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//       ],
//     );
//   }
// }
