import 'package:facesbyplaces/API/Regular/api-13-01-regular-search-posts.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularConnectionListFollowers extends StatefulWidget{

  HomeRegularConnectionListFollowersState createState() => HomeRegularConnectionListFollowersState();
}

class HomeRegularConnectionListFollowersState extends State<HomeRegularConnectionListFollowers>{

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
            Expanded(child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 5, backgroundImage: AssetImage('assets/icons/graveyard.png'), backgroundColor: Color(0xff888888),),),

            Text('Follower ${index + 1}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
          ],
        ),),
      ),
    );
  }
}