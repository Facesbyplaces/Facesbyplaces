import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-appbar.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomePageDetails extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
          appBar: MiscBLMAppBarTemplate(
            appBar: AppBar(), 
            title: Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            leadingAction: (){Navigator.pop(context);},
            actions: [
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/home/blm/home-09-blm-memorial-settings');
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
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [

                    MiscBLMInputFieldTemplate(key: _key1, labelText: 'Page Name'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key2, labelText: 'Relationship'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key3, labelText: 'DOB'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key4, labelText: 'RIP'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key5, labelText: 'DOB'),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    MiscBLMInputFieldTemplate(key: _key6, labelText: 'Cemetery'),

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