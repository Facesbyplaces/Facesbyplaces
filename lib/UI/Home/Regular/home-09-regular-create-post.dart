import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularCreatePost extends StatelessWidget{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldDropDownState> _key2 = GlobalKey<MiscRegularInputFieldDropDownState>();

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
          appBar: AppBar(
            title: Text('Create Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            backgroundColor: Color(0xff04ECFF),
            actions: [
              GestureDetector(
                onTap: (){
                  Navigator.popAndPushNamed(context, '/home/regular');
                }, 
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0), 
                  child: Center(
                    child: Text('Post', 
                    style: TextStyle(
                      color: Color(0xffffffff), 
                      fontSize: SizeConfig.safeBlockHorizontal * 5,),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            physics: ClampingScrollPhysics(),
            children: [

              Container(
                height: SizeConfig.blockSizeVertical * 10,
                
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 3,
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 17,
                          child: Image.asset('assets/icons/profile2.png', fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0,),
                        child: MiscRegularInputFieldDropDownUser(key: _key2,),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0)
                    ),
                  ],
                ),
              ),

              Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscRegularInputFieldTemplate(key: _key1, labelText: 'Speak out...', maxLines: 10),),

              Container(height: SizeConfig.blockSizeVertical * 25, child: Image.asset('assets/icons/upload_background.png', fit: BoxFit.cover),),

              Container(
                height: SizeConfig.blockSizeVertical * 20,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                        color: Color(0xffffffff),
                        child: Row(
                          children: [
                            Expanded(child: Text('Add a location'),),
                            Icon(Icons.place, color: Color(0xff4EC9D4),)
                          ],
                        ),
                      ),
                    ),

                    Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                        color: Color(0xffffffff),
                        child: Row(
                          children: [
                            Expanded(child: Text('Tag a person you are with'),),
                            Icon(Icons.person, color: Color(0xff4EC9D4),)
                          ],
                        ),
                      ),
                    ),

                    Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                        color: Color(0xffffffff),
                        child: Row(
                          children: [
                            Expanded(child: Text('Upload a Video / Image'),),
                            Icon(Icons.image, color: Color(0xff4EC9D4),)
                          ],
                        ),
                      ),
                    ),

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