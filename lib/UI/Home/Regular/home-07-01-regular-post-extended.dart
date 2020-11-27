import 'package:facesbyplaces/API/Regular/api-13-01-regular-search-suggested.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'home-05-regular-search.dart';

class HomeRegularPostExtended extends StatefulWidget{

  HomeRegularPostExtendedState createState() => HomeRegularPostExtendedState();
}

class HomeRegularPostExtendedState extends State<HomeRegularPostExtended>{

  void initState(){
    super.initState();
    apiRegularSearchPosts('');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final ScreenArguments newValue = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<APIRegularSearchPostMain>(
      future: apiRegularSearchPosts(newValue.title),
      builder: (context, searchPost){
        if(searchPost.hasData){
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            itemCount: searchPost.data.familyMemorialList.length,
            itemBuilder: (context, index){
              return Column(
                children: [
                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  MiscRegularPost(
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
        }else if(searchPost.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}