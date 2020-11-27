import 'package:facesbyplaces/API/BLM/api-07-01-blm-home-feed-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeBLMFeedTab extends StatefulWidget{

  HomeBLMFeedTabState createState() => HomeBLMFeedTabState();
}

class HomeBLMFeedTabState extends State<HomeBLMFeedTab>{

  void initState(){
    super.initState();
    apiBLMHomeFeedTab();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<APIBLMHomeTabFeedMain>(
      future: apiBLMHomeFeedTab(),
      builder: (context, feedTab){
        if(feedTab.hasData){
          if(feedTab.data.familyMemorialList.length == 0){
            return Column(
              children: [

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Welcome to\n', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                        TextSpan(text: 'Faces by Places', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                Container(
                  width: SizeConfig.screenWidth,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: SizeConfig.blockSizeVertical * 8,
                        child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8,),
                      ),

                      Positioned(
                        right: 0,
                        top: SizeConfig.blockSizeVertical * 8,
                        child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8, backgroundColor: Color(0xff04ECFF),),
                      ),

                      Positioned(
                        left: SizeConfig.blockSizeHorizontal * 12,
                        top: SizeConfig.blockSizeVertical * 6,
                        child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10,),
                      ),

                      Positioned(
                        right: SizeConfig.blockSizeHorizontal * 12,
                        top: SizeConfig.blockSizeVertical * 6,
                        child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10, backgroundColor: Color(0xff04ECFF),),
                      ),

                      Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Center(child: Text('Feed is empty', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Center(child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                MiscBLMButtonTemplate(
                  buttonText: 'Create', 
                  buttonTextStyle: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xffffffff),
                  ), 
                  onPressed: (){
                    Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
                  }, 
                  width: SizeConfig.screenWidth / 2, 
                  height: SizeConfig.blockSizeVertical * 7, 
                  buttonColor: Color(0xff04ECFF),
                ),
                
              ],
            );
          }else{
            return Container(
              height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(10.0),
                itemCount: feedTab.data.familyMemorialList.length,
                separatorBuilder: (context, index) => Divider(height: 0, color: Colors.transparent),
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      MiscBLMPost(
                        contents: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: feedTab.data.familyMemorialList[index].body,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                            ],
                          ),


                          feedTab.data.familyMemorialList[index].imagesOrVideos != null
                          ? Container(
                            height: SizeConfig.blockSizeHorizontal * 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(feedTab.data.familyMemorialList[index].imagesOrVideos[0]),
                              ),
                            ),
                          )
                          : Container(height: 0,),
                        ],
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                    ],
                  );
                }
              ),
            );
          }
        }else if(feedTab.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}