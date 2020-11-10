import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'misc-04-regular-dropdown.dart';

class MiscRegularPost extends StatelessWidget{

  final List<Widget> contents;

  MiscRegularPost({this.contents});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0,),
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.all(Radius.circular(15),),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 0)
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: CircleAvatar(backgroundImage: AssetImage('assets/icons/profile2.png'),),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(alignment: Alignment.bottomLeft,
                            child: Text('Sara Rosario Suarez Sara Rosario Suarez',
                              overflow: TextOverflow.ellipsis,
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
                            child: Text('an hour ago',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffaaaaaa)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MiscRegularDropDownTemplate(),
              ],
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: contents,
            ),
          ),

          Container(
            height: SizeConfig.blockSizeVertical * 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){},
                  child: Row(
                    children: [
                      Icon(Icons.favorite_rounded, color: Color(0xffE74C3C),),

                      SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                      Text('24.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                    ],
                  ),
                ),

                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                GestureDetector(
                  onTap: (){},
                  child: Row(
                    children: [
                      Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

                      SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                      Text('14.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){},
                    child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}