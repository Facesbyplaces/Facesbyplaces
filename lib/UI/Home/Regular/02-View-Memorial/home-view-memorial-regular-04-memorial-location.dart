// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';
// import 'package:maps/maps.dart';

// class HomeRegularMemorialLocation extends StatefulWidget{

//   HomeRegularMemorialLocationState createState() => HomeRegularMemorialLocationState();
// }

// class HomeRegularMemorialLocationState extends State<HomeRegularMemorialLocation>{

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
//         centerTitle: true,
//         backgroundColor: Color(0xff04ECFF),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//           onPressed: (){
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       // body: Map(
//       //   controller: controller,
//       //   builder: (context, x, y, z){
//       //     final url ='https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

//       //     return CachedNetworkImage(
//       //       imageUrl: url,
//       //       fit: BoxFit.cover,
//       //     );
//       //   },
//       // ),
//       body: MapWidget(
//         location: MapLocation(
//           query: 'Paris',
//         ),
//         // markers: [
//         //   MapMarker(
//         //     query: 'Eiffel Tower',
//         //   ),
//         // ],
//       ),
//     );
//   }
// }
