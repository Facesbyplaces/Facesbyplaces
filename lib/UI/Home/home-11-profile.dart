import 'dart:ui';

import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeProfile extends StatelessWidget{

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [
        Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/icons/background4.png'),
                ),
              ),
            ),

            Column(
              children: [

                Container(height: SizeConfig.screenHeight / 3.5, color: Colors.transparent,),

                Container(
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    color: Color(0xffffffff),
                  ),
                  child: Column(
                    children: [

                      SizedBox(height: SizeConfig.blockSizeVertical * 12,),

                      Center(
                        child: Text('Richard Nedd Memories',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Container(
                        width: SizeConfig.safeBlockHorizontal * 15,
                        height: SizeConfig.blockSizeVertical * 5,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: SizeConfig.blockSizeVertical * 2,
                              backgroundColor: Color(0xff000000),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Image.asset('assets/icons/fist.png'),
                              ),
                            ),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            Text('45',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Stack(
                          children: [
                            Image.asset('assets/icons/upload_background.png'),

                            Positioned(
                              top: SizeConfig.blockSizeVertical * 7,
                              left: SizeConfig.screenWidth / 2.8,
                              child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 10,),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    context.bloc<BlocHomeUpdateCubit>().modify(8);
                                  },
                                  child: Text('Manage',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  minWidth: SizeConfig.screenWidth / 2,
                                  height: SizeConfig.blockSizeVertical * 7,
                                  shape: StadiumBorder(),
                                  color: Color(0xff2F353D),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){},
                                child: CircleAvatar(
                                  radius: SizeConfig.blockSizeVertical * 3,
                                  backgroundColor: Color(0xff3498DB),
                                  child: Icon(Icons.share, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 3,),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          children: [

                            Row(
                              children: [
                                Icon(Icons.place, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                Text('New York',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Row(
                              children: [
                                Icon(Icons.star, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                Text('4/23/1995',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Row(
                              children: [
                                Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                Text('5/14/2019',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Container(
                        height: 50.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                  Text('26',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),

                                  Text('Post',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffaaaaaa),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                  Text('526',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),

                                  Text('Family',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffaaaaaa),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                  Text('526',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),

                                  Text('Friends',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffaaaaaa),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                  Text('14.4K',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),

                                  Text('Joined',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xffaaaaaa),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffffffff),),

                      Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0,),
                            alignment: Alignment.centerLeft,
                            child: Text('Post',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.blockSizeVertical * 15,
                        padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            return Container(
                              width: SizeConfig.blockSizeVertical * 13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(images[index]),
                                ),
                              ),
                            );
                          }, 
                          separatorBuilder: (context, index){
                            return SizedBox(width: SizeConfig.blockSizeHorizontal * 2,);
                          },
                          itemCount: 4,
                        ),
                      ),

                      Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            height: SizeConfig.blockSizeVertical * 60,
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage('assets/icons/profile1.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text('Black Lives Matter',
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
                                      Expanded(
                                        child: IconButton(
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.zero,
                                          onPressed: (){
                                            
                                          },
                                          icon: Icon(Icons.more_vert, color: Color(0xffaaaaaa)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
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
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage('assets/icons/blm2.png',),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage('assets/icons/blm3.png',),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                            Expanded(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      color: Color(0xff888888),
                                                    ),
                                                  ),

                                                  Align(
                                                    child: Text('+4',
                                                      style: TextStyle(
                                                        fontSize: SizeConfig.safeBlockHorizontal * 7,
                                                        color: Color(0xffffffff),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){},
                                          child: Row(
                                            children: [
                                              Image.asset('assets/icons/peace_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                              SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                              Text('24.3K',
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){},
                                          child: Row(
                                            children: [
                                              Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                              SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                              Text('14.3K',
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                          onTap: (){},
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Container(
              height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: (){
                          context.bloc<BlocHomeUpdateCubit>().modify(2);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                            Text('Back',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 20.0),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          context.bloc<BlocHomeUpdateCubit>().modify(9);
                        },
                        child: Text('Create Post',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: SizeConfig.screenHeight / 5,
              child: Container(
                height: SizeConfig.blockSizeVertical * 18,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 10,
                        backgroundColor: Color(0xff000000),
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 17,
                          child: Image.asset('assets/icons/profile1.png', fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}