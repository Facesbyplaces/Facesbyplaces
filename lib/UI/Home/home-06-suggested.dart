import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeSuggested extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 13),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index){
          return Container(
            height: SizeConfig.blockSizeVertical * 15,
            color: Color(0xffffffff),
            child: Row(
              children: [
                Expanded(
                  child: CircleAvatar(
                    maxRadius: SizeConfig.blockSizeVertical * 5,
                    backgroundImage: AssetImage('assets/icons/profile1.png'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text('Memorial',
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
                          child: Text('Memorial',
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        
                      },
                      child: Text('Join',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          color: Color(0xff4EC9D4),
                        ),
                      ),
                      minWidth: SizeConfig.screenWidth / 2,
                      height: SizeConfig.blockSizeVertical * 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      color: Color(0xffffffff),
                    ),
                    
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index){
          return Divider(height: 1, color: Colors.grey,);
        },
      ),
    );
  }
}