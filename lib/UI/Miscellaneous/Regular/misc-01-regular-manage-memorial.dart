import 'package:facesbyplaces/UI/Home/Regular/View-Memorial/home-01-regular-view-managed-memorial.dart';
import 'package:facesbyplaces/API/Regular/api-19-regular-leave-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'misc-08-regular-dialog.dart';

class MiscRegularManageMemorialTab extends StatefulWidget{
  final int index;
  final int tab;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;

  MiscRegularManageMemorialTab({
    this.index, 
    this.tab,
    this.memorialName = '',
    this.description = '',
    this.image = 'assets/icons/graveyard.png',
    this.memorialId,
    this.managed,
  });

  MiscRegularManageMemorialTabState createState() => MiscRegularManageMemorialTabState(index: index, tab: tab, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed);
}

class MiscRegularManageMemorialTabState extends State<MiscRegularManageMemorialTab>{

  final int index;
  final int tab;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;
  final bool managed;

  MiscRegularManageMemorialTabState({
    this.index, 
    this.tab,
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

        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId,)));
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
                  bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Are you sure you want to leave this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                  if(confirmResult){
                    String result = await apiRegularLeavePage(memorialId);

                    if(result != 'Success'){
                      await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: result));
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
