import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-12-appbar.dart';
import 'package:flutter/material.dart';

class HomePageDetails extends StatelessWidget{

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key3 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key4 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key5 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key6 = GlobalKey<MiscInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: MiscAppBarTemplate(
            appBar: AppBar(), 
            title: Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            leadingAction: (){Navigator.pop(context);},
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
          ),
          body: Stack(
            children: [

              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [

                    MiscInputFieldTemplate(key: _key1, labelText: 'Page Name'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key2, labelText: 'Relationship'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key3, labelText: 'DOB'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key4, labelText: 'RIP'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key5, labelText: 'DOB'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscInputFieldTemplate(key: _key6, labelText: 'Cemetery'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}