import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class TestImages extends StatefulWidget {
  @override

  TestImagesState createState() => TestImagesState();
}

class TestImagesState extends State<TestImages> {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Images'),
      ),
      backgroundColor: Colors.blue,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
          ),

          Positioned(
            left: SizeConfig.screenWidth! / 1.4,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xffffffff),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.transparent,
                foregroundImage: AssetImage('assets/icons/app-icon.png'),
              ),
            ),
          ),
        
          Positioned(
            left: SizeConfig.screenWidth! / 1.8,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xffffffff),
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.transparent,
                foregroundImage: AssetImage('assets/icons/app-icon.png'),
              ),
            ),
          ),

          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xffffffff),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.transparent,
              foregroundImage: AssetImage('assets/icons/app-icon.png'),
            ),
          ),
        ],
      ),
    );
  }
}