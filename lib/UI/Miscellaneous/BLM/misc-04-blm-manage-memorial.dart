import 'package:facesbyplaces/Bloc/bloc-03-bloc-blm-misc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiscBLMManageMemorialTab extends StatelessWidget{

  final int index;
  final int tab;
  final String memorialName;
  final String description;
  final String image;
  final int memorialId;

  MiscBLMManageMemorialTab({
    this.index, 
    this.tab,
    this.memorialName = '',
    this.description = '',
    this.image = 'assets/icons/graveyard.png',
    this.memorialId,
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return BlocProvider(
      create: (BuildContext context) => BlocMiscBLMManageMemorialButton(),
      child: BlocBuilder<BlocMiscBLMManageMemorialButton, bool>(
        builder: (context, manageButton){
          return GestureDetector(
            onTap: () async{

              print('The memorialId is $memorialId');

              final sharedPrefs = await SharedPreferences.getInstance();
              sharedPrefs.setInt('blm-user-memorial-id', memorialId);

              Navigator.pushNamed(context, '/home/blm/home-12-blm-profile');
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
                      textColor: ((){
                        if(manageButton == true){
                          return Color(0xffffffff);
                        }else{
                          return Color(0xff4EC9D4);
                        }
                      }()),
                      splashColor: Color(0xff4EC9D4),
                      onPressed: (){
                        context.bloc<BlocMiscBLMManageMemorialButton>().modify(!manageButton);
                      },
                      child: ((){
                        if(manageButton == true){
                          return Text('Leave',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                            ),
                          );
                        }else{
                          return Text('Manage',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                            ),
                          );
                        }
                      }()),
                      height: SizeConfig.blockSizeVertical * 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: ((){
                          if(manageButton == true){
                            return BorderSide(color: Color(0xff04ECFF));
                          }else{
                            return BorderSide(color: Color(0xff4EC9D4));
                          }
                        }())
                      ),
                      color: ((){
                        if(manageButton == true){
                          return Color(0xff04ECFF);
                        }else{
                          return Color(0xffffffff);
                        }
                      }()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
