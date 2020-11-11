import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/API/Regular/api-07-03-regular-home-post-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeRegularPostTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<bool>(
      future: apiRegularHomePostTab(),
      builder: (context, postTab){
        if(postTab.hasData){
          return Container(
            height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(10.0),
              itemCount: 5,
              separatorBuilder: (context, index) => Divider(height: 0, color: Colors.transparent),
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
            ),
          );
        }else if(postTab.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}