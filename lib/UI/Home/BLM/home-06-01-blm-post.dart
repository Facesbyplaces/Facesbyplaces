import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/API/BLM/api-14-01-blm-search-posts.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'home-04-blm-search.dart';

class HomeBLMPostExtended extends StatelessWidget {

  String convertDate(String input){
    DateTime dateTime = DateTime.parse(input);

    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final BLMArguments newValue = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<APIBLMSearchPostMain>(
      future: apiBLMSearchPosts(newValue.title),
      builder: (context, searchPost){
        if(searchPost.hasData){
          if(searchPost.data.familyMemorialList.length != 0){
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              itemCount: searchPost.data.familyMemorialList.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    MiscBLMPost(
                      userId: searchPost.data.familyMemorialList[index].page.id,
                      postId: searchPost.data.familyMemorialList[index].id,
                      memorialId: searchPost.data.familyMemorialList[index].page.id,
                      memorialName: searchPost.data.familyMemorialList[index].page.name,
                      profileImage: searchPost.data.familyMemorialList[index].page.profileImage,
                      timeCreated: convertDate(searchPost.data.familyMemorialList[index].createAt),
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
                                  text: searchPost.data.familyMemorialList[index].body,
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


                        searchPost.data.familyMemorialList[index].imagesOrVideos != null
                        ? Container(
                          height: SizeConfig.blockSizeHorizontal * 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: searchPost.data.familyMemorialList[index].imagesOrVideos[0],
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
            );
          }else{
            return Center(child: Text('Post is empty.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),));
          }
        }else if(searchPost.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}