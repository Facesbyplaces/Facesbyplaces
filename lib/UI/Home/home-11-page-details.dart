import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:flutter/material.dart';

class HomePageDetails extends StatelessWidget{

  final GlobalKey<MiscInputFieldCreateMemorialState> _key1 = GlobalKey<MiscInputFieldCreateMemorialState>();
  final GlobalKey<MiscInputFieldCreateMemorialState> _key2 = GlobalKey<MiscInputFieldCreateMemorialState>();
  final GlobalKey<MiscInputFieldCreateMemorialState> _key3 = GlobalKey<MiscInputFieldCreateMemorialState>();
  final GlobalKey<MiscInputFieldCreateMemorialState> _key4 = GlobalKey<MiscInputFieldCreateMemorialState>();
  final GlobalKey<MiscInputFieldCreateMemorialState> _key5 = GlobalKey<MiscInputFieldCreateMemorialState>();
  final GlobalKey<MiscInputFieldCreateMemorialState> _key6 = GlobalKey<MiscInputFieldCreateMemorialState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Memorial Settings',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * 4,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, 'home/home-09-memorial-settings');
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.0), 
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Color(0xff04ECFF), 
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xffF5F5F5),
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                MiscInputFieldCreateMemorial(key: _key1, hintText: 'Page Name', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputFieldCreateMemorial(key: _key2, hintText: 'Relationship', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputFieldCreateMemorial(key: _key3, hintText: 'DOB', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputFieldCreateMemorial(key: _key4, hintText: 'RIP', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputFieldCreateMemorial(key: _key5, hintText: 'Birthplace', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputFieldCreateMemorial(key: _key6, hintText: 'Cemetery', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              ],
            ),
          ),
        ],
      ),
    );
  }
}