import 'package:cached_network_image/cached_network_image.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/API/BLM/api-07-03-blm-home-post-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeBLMPostTab extends StatefulWidget{

  HomeBLMPostTabState createState() => HomeBLMPostTabState();
}

class HomeBLMPostTabState extends State<HomeBLMPostTab>{

  void initState(){
    super.initState();
    apiBLMHomePostTab();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<APIBLMHomeTabPostMain>(
      future: apiBLMHomePostTab(),
      builder: (context, postTab){
        if(postTab.hasData){
          return Container(
            height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(10.0),
              itemCount: postTab.data.familyMemorialList.length,
              separatorBuilder: (context, index) => Divider(height: 0, color: Colors.transparent),
              itemBuilder: (context, index){
                return Column(
                  children: [
                    MiscBLMPost(
                      userId: postTab.data.familyMemorialList[index].page.id,
                      postId: postTab.data.familyMemorialList[index].id,
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
                                  text: postTab.data.familyMemorialList[index].body,
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


                        postTab.data.familyMemorialList[index].imagesOrVideos != null
                        ? Container(
                          height: SizeConfig.blockSizeHorizontal * 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: postTab.data.familyMemorialList[index].imagesOrVideos[0],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Icon(Icons.error),
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
        }else if(postTab.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}