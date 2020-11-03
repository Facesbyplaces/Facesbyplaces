import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeMemorialProfile extends StatelessWidget{

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: [
            
            Container(height: SizeConfig.screenHeight / 3, decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background3.png'),),),),

            Column(
              children: [
                Container(
                  height: SizeConfig.screenHeight / 3.5,
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, top: 20.0),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: (){Navigator.pop(context);},
                      icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,),
                    ),
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

                      Center(child: Text('Karen Cruz', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

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
                        child: Text('John was a US military personnel. We had always wished he did not take on being a military, but it was his dream so we had to let him do it. '
                        'He was awarded 5 times during his service. He\'s a good son and father to his son and daughter. Rest in peace John.',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){},
                                child: CircleAvatar(
                                  radius: SizeConfig.blockSizeVertical * 3,
                                  backgroundColor: Color(0xffE67E22),
                                  child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 3,),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    
                                  },
                                  child: Text('Join',
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

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

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

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

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
                        height: SizeConfig.blockSizeVertical * 12,
                        padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            return Container(
                              width: SizeConfig.blockSizeVertical * 10,
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

                      Container(height: SizeConfig.blockSizeVertical * 1, color: Color(0xffeeeeee),),

                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: SizeConfig.blockSizeVertical * 5,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage('assets/icons/profile1.png'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text('Cristel Jane & Family',
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
                                                child: Text('30 minutes ago',
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

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: RichText(
                                        maxLines: 4,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          text: 'Visiting Christel\'s resting place.Hope you\'re doing good their bestfriend.',
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
                                              text: 'Daniel Denneson & Freya Jackson',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Icon(Icons.place, color: Color(0xff2ECC71),),
                                          Text(
                                            'Golden New Cemetery',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                    Container(
                                      height: SizeConfig.blockSizeVertical * 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/icons/profile_post5.png'),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ),

                          Container(
                            width: SizeConfig.screenWidth,
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 38,
                              child: Row(
                                children: [
                                  Icon(Icons.favorite, color: Color(0xffE74C3C),),

                                  Text('14.5K'),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Icon(Icons.mode_comment_outlined, color: Color(0xff000000),),

                                  Text('1.8K'),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                        ],
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
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 10,
                        backgroundColor: Color(0xff04ECFF),
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
      ),
    );
  }
}
