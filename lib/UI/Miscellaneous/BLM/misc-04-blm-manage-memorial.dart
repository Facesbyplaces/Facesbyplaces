import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-21-blm-leave-page.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:flutter/material.dart';
import 'misc-02-blm-dialog.dart';

class MiscBLMManageMemorialTab extends StatefulWidget{
  final int index;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;

  MiscBLMManageMemorialTab({
    this.index, 
    this.memorialName = '',
    this.description = '',
    this.image = 'assets/icons/graveyard.png',
    this.memorialId,
    this.managed,
  });


  MiscBLMManageMemorialTabState createState() => MiscBLMManageMemorialTabState(index: index, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed);
}

class MiscBLMManageMemorialTabState extends State<MiscBLMManageMemorialTab>{

  final int index;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;

  MiscBLMManageMemorialTabState({
    this.index, 
    this.memorialName,
    this.description,
    this.image,
    this.memorialId,
    this.managed,
  });

  bool manageButton;

  void initState(){
    super.initState();
    manageButton = managed;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId,)));
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 15,
        color: Color(0xffffffff),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 10.0), child: CircleAvatar(maxRadius: SizeConfig.blockSizeVertical * 5, backgroundColor: Color(0xff4EC9D4), backgroundImage: AssetImage(image),),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(memorialName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15.0),
              child: MaterialButton(
                elevation: 0,
                padding: EdgeInsets.zero,
                textColor: manageButton ? Color(0xffffffff) : Color(0xff4EC9D4),
                splashColor: Color(0xff4EC9D4),
                onPressed: () async{

                  if(manageButton == true){
                    bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Are you sure you want to leave this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                    if(confirmResult){
                      String result = await apiBLMLeavePage(memorialId);

                      if(result != 'Success'){
                        await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: result));
                      }
                    }
                  }

                },
                child: manageButton ? Text('Leave', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4,),) : Text('Manage', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4,),),
                height: SizeConfig.blockSizeVertical * 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: manageButton ? BorderSide(color: Color(0xff04ECFF)) : BorderSide(color: Color(0xff4EC9D4)),
                ),
                color: manageButton ? Color(0xff04ECFF) : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}