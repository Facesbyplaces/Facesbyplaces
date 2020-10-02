import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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