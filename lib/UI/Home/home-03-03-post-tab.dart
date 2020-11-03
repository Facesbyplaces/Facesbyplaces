import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/material.dart';

Future<void> share() async {
  await FlutterShare.share(
    title: 'Example share',
    text: 'Example share text',
    linkUrl: 'https://flutter.dev/',
    chooserTitle: 'Example Chooser Title'
  );
}

class HomePostTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        itemCount: 5,
        itemBuilder: (context, index){
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                height: SizeConfig.blockSizeVertical * 60,
                decoration: BoxDecoration(color: Color(0xffffffff), borderRadius: BorderRadius.all(Radius.circular(15),),),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                // Navigator.pushNamed(context, '/home/home-14-memorial-list');
                                Navigator.pushNamed(context, '/home/home-12-memorial-list');
                                
                                
                              },
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/icons/profile1.png'),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Align(alignment: Alignment.bottomLeft,
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
                              onPressed: share,
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
                                      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Color(0xff888888),),),

                                      Align(child: Text('+4', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 7, color: Color(0xffffffff),),),),
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

                                  Text('24.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
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

                                  Text('14.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
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
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 2,),
            ],
          );
        }
      ),
    );
  }
}