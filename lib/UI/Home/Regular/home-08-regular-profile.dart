import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularProfile extends StatelessWidget{

  final List<String> images = ['assets/icons/regular-image1.png', 'assets/icons/regular-image2.png', 'assets/icons/regular-image3.png', 'assets/icons/regular-image4.png'];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: [
            
            Container(height: SizeConfig.screenHeight / 3, decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/regular-image1.png'),),),),

            Column(
              children: [
                Container(
                  height: SizeConfig.screenHeight / 3.5,
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
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
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, 'home/regular/home-09-regular-create-post');
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
                ), // INVISIBLE SPACE ABOVE THE BACKGROUND

                Container(
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    color: Color(0xffffffff),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical * 12,),

                      Center(child: Text('Sara Rosario Suarez', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Container(
                        width: SizeConfig.safeBlockHorizontal * 15,
                        height: SizeConfig.blockSizeVertical * 5,
                        child: Row(
                          children: [
                            Expanded(
                              child: CircleAvatar(
                                radius: SizeConfig.blockSizeVertical * 2,
                                backgroundColor: Color(0xffE67E22),
                                child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 2,),
                              ),
                            ),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            Expanded(
                              child: Text('45',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff000000),
                                ),
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
                            Container(
                              height: SizeConfig.blockSizeHorizontal * 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/icons/regular-image4.png'),
                                ),
                              ),
                            ),

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
                            Expanded(child: Container(),),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    Navigator.pushNamed(context, 'home/regular/home-10-regular-memorial-settings');
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
                                  color: Color(0xff04ECFF),
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
                                Image.asset('assets/icons/prayer_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                Text('Roman Catholic',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

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

                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

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

                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

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

                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                            Row(
                              children: [
                                Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                GestureDetector(
                                  onTap: (){},
                                  child: Text('New Town Cemetery',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                      color: Color(0xff3498DB),
                                    ),
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

                                  Text('Followers',
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

                      Container(height: SizeConfig.blockSizeVertical * 1, color: Color(0xffeeeeee),),

                      Column(
                        children: [
                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          Container(
                            padding: EdgeInsets.only(left: 20.0),
                            alignment: Alignment.centerLeft,
                            child: Text('Post',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.blockSizeVertical * 12,
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: ListView.separated(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                                return Container(
                                  width: SizeConfig.blockSizeVertical * 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
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

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        ],
                      ),

                      Container(
                        padding: EdgeInsets.all(10.0),
                        color: Color(0xffeeeeee),
                        child: Column(
                          children: [
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

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            MiscRegularPost(
                              contents: [
                                Container(
                                  height: SizeConfig.blockSizeHorizontal * 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/icons/regular-image2.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            

            Positioned(
              top: SizeConfig.screenHeight / 5,
              child: Container(
                height: SizeConfig.blockSizeVertical * 18,
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    Expanded(child: Container(),),
                    Expanded(
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 12,
                        backgroundColor: Color(0xff04ECFF),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                            child: CircleAvatar(
                            radius: SizeConfig.blockSizeVertical * 12,
                            backgroundImage: AssetImage('assets/icons/profile2.png'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container(),),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
