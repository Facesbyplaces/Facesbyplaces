import 'package:facesbyplaces/API/Regular/api-13-01-regular-search-suggested.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularConnectionListFriends extends StatefulWidget{

  HomeRegularConnectionListFriendsState createState() => HomeRegularConnectionListFriendsState();
}

class HomeRegularConnectionListFriendsState extends State<HomeRegularConnectionListFriends>{

  void initState(){
    super.initState();
    apiRegularSearchPosts('');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      padding: EdgeInsets.all(10.0),
      child: GridView.count(
        physics: ClampingScrollPhysics(),
        crossAxisSpacing: 2,
        mainAxisSpacing: 20,
        crossAxisCount: 4,
        children: List.generate(5, (index) => Column(
          children: [
            Expanded(child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 5,),),

            Text('Friend ${index + 1}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
          ],
        ),),
      ),
    );
  }
}