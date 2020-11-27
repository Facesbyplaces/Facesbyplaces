// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/API/BLM/api-14-01-blm-search-posts.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'home-04-blm-search.dart';

class HomeBLMPostExtended extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final BLMArguments newValue = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<APIBLMSearchPostMain>(
      future: apiBLMSearchPosts(newValue.title),
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
    // return ListView.builder(
    //   physics: ClampingScrollPhysics(),
    //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
    //   itemCount: 5,
    //   itemBuilder: (context, index){
    //     return Column(
    //       children: [
    //         SizedBox(height: SizeConfig.blockSizeVertical * 1,),

    //         MiscBLMPost(
    //           contents: [
    //             Align(
    //               alignment: Alignment.topLeft,
    //               child: RichText(
    //                 maxLines: 4,
    //                 overflow: TextOverflow.clip,
    //                 textAlign: TextAlign.left,
    //                 text: TextSpan(
    //                   text: 'He was someone who was easy to go with. We had a lot of memories together. '
    //                   'We\'ve been travelling all around the world together ever since we graduated college. We will surely miss you Will ❤️❤️❤️',
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.w300,
    //                     color: Color(0xff000000),
    //                   ),
    //                 ),
    //               ),
    //             ),

    //             SizedBox(height: SizeConfig.blockSizeVertical * 1,),

    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: RichText(
    //                 maxLines: 1,
    //                 overflow: TextOverflow.clip,
    //                 textAlign: TextAlign.left,
    //                 text: TextSpan(
    //                   children: <TextSpan>[
    //                     TextSpan(
    //                       text: 'with ',
    //                       style: TextStyle(
    //                         fontSize: SizeConfig.safeBlockHorizontal * 3,
    //                         fontWeight: FontWeight.w300,
    //                         color: Color(0xffaaaaaa),
    //                       ),
    //                     ),

    //                     TextSpan(
    //                       text: 'William Shaw & John Howard',
    //                       style: TextStyle(
    //                         fontWeight: FontWeight.bold,
    //                         color: Color(0xff000000),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),

    //             SizedBox(height: SizeConfig.blockSizeVertical * 1,),

    //             Container(
    //               height: SizeConfig.blockSizeVertical * 25,
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                     flex: 2,
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(10.0),
    //                         image: DecorationImage(
    //                           fit: BoxFit.cover,
    //                           image: AssetImage('assets/icons/blm2.png',),
    //                         ),
    //                       ),
    //                     ),
    //                   ),

    //                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                      
    //                   Expanded(
    //                     child: Column(
    //                       children: [
    //                         Expanded(
    //                           child: Container(
    //                             decoration: BoxDecoration(
    //                               borderRadius: BorderRadius.circular(10.0),
    //                               image: DecorationImage(
    //                                 fit: BoxFit.cover,
    //                                 image: AssetImage('assets/icons/blm3.png',),
    //                               ),
    //                             ),
    //                           ),
    //                         ),

    //                         SizedBox(height: SizeConfig.blockSizeVertical * 1,),

    //                         Expanded(
    //                           child: Stack(
    //                             children: [
    //                               Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Color(0xff888888),),),

    //                               Align(child: Text('+4', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 7, color: Color(0xffffffff),),),),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //         SizedBox(height: SizeConfig.blockSizeVertical * 1,),
    //       ],
    //     );
    //   }
    // );
  }
}