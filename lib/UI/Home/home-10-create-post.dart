import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-12-appbar.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeCreatePost extends StatelessWidget{

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();

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
            title: Text('Create Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            leadingAction: (){Navigator.pop(context);},
            actions: [
              GestureDetector(
                onTap: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/home/home-08-profile', ModalRoute.withName('/home/'));
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
            shrinkWrap: true,
            children: [

              Container(
                height: SizeConfig.blockSizeVertical * 10,
                
                child: Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 3,
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 17,
                          child: Image.asset('assets/icons/profile1.png', fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Richard Nedd Memories',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.arrow_drop_down, color: Color(0xff000000),),
                        ),
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

              SizedBox(height: SizeConfig.blockSizeVertical * 1,),

              Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscInputFieldTemplate(key: _key1, labelText: 'Speak out...', maxLines: 10),),

              Container(height: SizeConfig.blockSizeVertical * 25, child: Image.asset('assets/icons/upload_background.png', fit: BoxFit.cover),),

              Container(
                height: SizeConfig.blockSizeVertical * 20,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        color: Color(0xffffffff),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Add a location'),
                            ),
                            Expanded(
                              child: Icon(Icons.place, color: Color(0xff4EC9D4),)
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        color: Color(0xffffffff),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Tag a person you are with'),
                            ),
                            Expanded(
                              child: Icon(Icons.person, color: Color(0xff4EC9D4),)
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        color: Color(0xffffffff),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Upload a Video / Image'),
                            ),
                            Expanded(
                              child: Icon(Icons.image, color: Color(0xff4EC9D4),)
                            ),
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