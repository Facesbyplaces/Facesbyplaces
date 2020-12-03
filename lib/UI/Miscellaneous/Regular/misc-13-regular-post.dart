import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../ui-01-get-started.dart';
import 'misc-04-regular-dropdown.dart';
import 'misc-07-regular-button.dart';
import 'misc-08-regular-dialog.dart';
import 'misc-09-regular-extra.dart';

class MiscRegularPost extends StatelessWidget{

  final List<Widget> contents;
  final int userId;
  final int postId;
  final int memorialId;
  final dynamic profileImage;
  final String memorialName;
  final String timeCreated;

  MiscRegularPost({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = ''});

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
                  onTap: () async{
                    // print('The memorialId is $memorialId');

                    // final sharedPrefs = await SharedPreferences.getInstance();
                    // sharedPrefs.setInt('regular-user-memorial-id', memorialId);

                    Navigator.pushNamed(context, 'home/regular/home-13-regular-memorial', arguments: memorialId);

                  },
                  child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: profileImage != null ? NetworkImage(profileImage) : AssetImage('assets/icons/graveyard.png')),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(alignment: Alignment.bottomLeft,
                            child: Text(memorialName,
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
                            child: Text(timeCreated,
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
                MiscRegularDropDownTemplate(userId: userId, postId: postId,),
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

                      Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
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

                      Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async{
                      await FlutterShare.share(
                        title: 'Share',
                        text: 'Share the link',
                        linkUrl: 'https://flutter.dev/',
                        chooserTitle: 'Share link'
                      );
                    },
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


class MiscRegularUserProfileDraggableSwitchTabs extends StatefulWidget {

  @override
  MiscRegularUserProfileDraggableSwitchTabsState createState() => MiscRegularUserProfileDraggableSwitchTabsState();
}

class MiscRegularUserProfileDraggableSwitchTabsState extends State<MiscRegularUserProfileDraggableSwitchTabs> {

  double height;
  Offset position;
  int currentIndex = 0;
  List<Widget> children;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
    children = [MiscRegularDraggablePost(), MiscRegularDraggableMemorials()];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Positioned(
      left: position.dx,
      top: position.dy - SizeConfig.blockSizeVertical * 10,
      child: Draggable(
        feedback: draggable(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          if(offset.dy > 100 && offset.dy < (SizeConfig.screenHeight - 100)){
            setState(() {
              position = offset;
            });
          }
        },
        child: draggable(),
        childWhenDragging: Container(),
        axis: Axis.vertical,
      ),
    );
  }

  draggable(){
    return Material(
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffaaaaaa),
              offset: Offset(0, 0),
              blurRadius: 5.0
            ),
          ],
        ),
        child: Column(
          children: [

            Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 8,
              child: DefaultTabController(
                length: 2,
                initialIndex: currentIndex,
                child: TabBar(
                  isScrollable: false,
                  labelColor: Color(0xff04ECFF),
                  unselectedLabelColor: Color(0xffCDEAEC),
                  indicatorColor: Color(0xff04ECFF),
                  onTap: (int number){
                    setState(() {
                      currentIndex = number;
                    });
                  },
                  tabs: [

                    Container(
                      width: SizeConfig.screenWidth / 2.5,
                      child: Center(
                        child: Text('Post',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: SizeConfig.screenWidth / 2.5,
                      child: Center(
                        child: Text('Memorials',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Container(
              width: SizeConfig.screenWidth,
              height: (SizeConfig.screenHeight - position.dy),
              child: IndexedStack(
                index: currentIndex,
                children: children,
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),
            
          ],
        ),
      ),
    );
  }
}


class MiscRegularDraggablePost extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      itemCount: 5,
      itemBuilder: (context, index){
        return ((){
          if(index == 0){
            return Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                MiscRegularPost(
                  contents: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        maxLines: 4,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: 'He was someone who was easy to go with. We had a lot of memories together. '
                          'We\'ve been travelling all around the world together ever since we graduated college. We will surely miss you Will ❤️❤️❤️',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'with ',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3,
                                fontWeight: FontWeight.w300,
                                color: Color(0xffaaaaaa),
                              ),
                            ),

                            TextSpan(
                              text: 'William Shaw & John Howard',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                
                SizedBox(height: SizeConfig.blockSizeVertical * 1,),
              ],
            );
          }else if(index == 3){
            return Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                MiscRegularPost(
                  contents: [
                    Container(
                      height: SizeConfig.blockSizeHorizontal * 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/icons/regular-image4.png'),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 1,),
              ],
            );
          }else{
            return Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                MiscRegularPost(
                  contents: [
                    Container(
                      height: SizeConfig.blockSizeHorizontal * 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/icons/regular-image4.png'),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 1,),
              ],
            );
          }
        }());
      }
    );
  }
}


class MiscRegularDraggableMemorials extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return ListView.separated(
      physics: ClampingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index){
        if(index == 0){
          return Container(
            height: SizeConfig.blockSizeVertical * 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            color: Color(0xffffffff),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Owned',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
              ),
            ),
          );
        }else if(index == 3){
          return Container(
            height: SizeConfig.blockSizeVertical * 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            color: Color(0xffffffff),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Followed',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
              ),
            ),
          );
        }else{
          return MiscRegularUserProfileDraggableTabsList(index: index, tab: 0,);
        }
      },
      separatorBuilder: (context, index){
        return Divider(height: 1, color: Colors.grey,);
      },
    );
  }
}

class MiscRegularUserProfileDetailsDraggable extends StatefulWidget {

  @override
  MiscRegularUserProfileDetailsDraggableState createState() => MiscRegularUserProfileDetailsDraggableState();
}

class MiscRegularUserProfileDetailsDraggableState extends State<MiscRegularUserProfileDetailsDraggable> {

  double height;
  Offset position;
  int currentIndex = 0;
  List<Widget> children;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: draggable(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          if(offset.dy > 10 && offset.dy < (SizeConfig.screenHeight - 100)){
            setState(() {
              position = offset;
            });
          }
        },
        child: draggable(),
        childWhenDragging: Container(),
        axis: Axis.vertical,
      ),
    );
  }

  draggable(){
    return Material(
      color: Colors.transparent,
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
        ),
        child: Column(
          children: [

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),

            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'home/regular/home-16-regular-user-update-details');
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Update Details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Update your account details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'home/regular/home-17-regular-change-password');
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Password',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Change your login password',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, 'home/regular/home-18-regular-other-details');
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Other Info',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Optional informations you can share',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            Container(
              height: SizeConfig.blockSizeVertical * 10,
              color: Color(0xffffffff),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Privacy Settings',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Control what others see',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          fontWeight: FontWeight.w300,
                          color: Color(0xffBDC3C7),
                        ),
                      ),
                    ),
                  ),

                  Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),),
                ]
              ),
            ),

            Expanded(child: Container(),),

            MiscRegularButtonTemplate(
              buttonText: 'Logout',
              buttonTextStyle: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 5, 
                fontWeight: FontWeight.bold, 
                color: Color(0xffffffff),
              ), 
              onPressed: () async{

                bool logoutResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

                if(logoutResult){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UIGetStarted()), (route) => false);
                }

              }, 
              width: SizeConfig.screenWidth / 2, 
              height: SizeConfig.blockSizeVertical * 7, 
              buttonColor: Color(0xff04ECFF),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),
            
            Text('V.1.1.0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff888888),),),

            Expanded(child: Container(),),

          ],
        ),
      ),
    );
  }
}
