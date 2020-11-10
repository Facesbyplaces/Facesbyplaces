import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomePostTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(10.0),
        itemCount: 5,
        itemBuilder: (context, index){
          return Column(
            children: [
              SizedBox(height: SizeConfig.blockSizeVertical * 1,),

              MiscBLMPost(
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

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  Container(
                    height: SizeConfig.blockSizeVertical * 25,
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

                ],
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 1,),
            ],
          );

        }
      ),
    );
  }
}