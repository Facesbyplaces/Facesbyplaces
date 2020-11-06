import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-12-appbar.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class HomeRegularCreateMemorial3 extends StatelessWidget{

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeBackgroundImage>(
          create: (context) => BlocHomeBackgroundImage(),
        ),
      ],
      child: Scaffold(
        appBar: MiscAppBarTemplate(appBar: AppBar(), leadingAction: (){Navigator.pop(context);},),
        body: Stack(
          children: [

            MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Text('Upload or Select an Image', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Container(
                    height: SizeConfig.blockSizeVertical * 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/icons/upload_background.png'),
                      ),
                    ),
                    child: Stack(
                      children: [

                        Center(
                          child: CircleAvatar(
                            radius: SizeConfig.blockSizeVertical * 7,
                            backgroundColor: Color(0xffffffff),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: SizeConfig.blockSizeVertical * 7,
                                backgroundImage: AssetImage('assets/icons/profile1.png'),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: SizeConfig.blockSizeVertical * 5,
                          left: SizeConfig.screenWidth / 2,
                          child: CircleAvatar(
                            radius: SizeConfig.blockSizeVertical * 3,
                            backgroundColor: Color(0xffffffff),
                            child: CircleAvatar(
                              radius: SizeConfig.blockSizeVertical * 3,
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
                            ),
                          ),
                        ),

                        Positioned(
                          top: SizeConfig.blockSizeVertical * 1,
                          right: SizeConfig.blockSizeVertical * 1,
                          child: CircleAvatar(
                            radius: SizeConfig.blockSizeVertical * 3,
                            backgroundColor: Color(0xffffffff),
                            child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Text('Choose Background', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  BlocBuilder<BlocHomeBackgroundImage, int>(
                    builder: (context, state){
                      return Container(
                        height: SizeConfig.blockSizeVertical * 12,
                        child: ListView.separated(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            return ((){
                              if(index == 4){
                                return GestureDetector(
                                  onTap: (){
                                    context.bloc<BlocHomeBackgroundImage>().updateToggle(index);
                                  },
                                  child: Container(
                                    width: SizeConfig.blockSizeVertical * 12,
                                    height: SizeConfig.blockSizeVertical * 12,    
                                    child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffcccccc),
                                      border: Border.all(color: Color(0xff000000),),
                                    ),
                                  ),
                                );
                              }else{
                                return GestureDetector(
                                  onTap: (){
                                    context.bloc<BlocHomeBackgroundImage>().updateToggle(index);
                                  },
                                  child: state == index
                                  ? Container(
                                    padding: EdgeInsets.all(5),
                                    width: SizeConfig.blockSizeVertical * 12,
                                    height: SizeConfig.blockSizeVertical * 12,
                                    decoration: BoxDecoration(
                                      color: Color(0xff04ECFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: SizeConfig.blockSizeVertical * 10,
                                      height: SizeConfig.blockSizeVertical * 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: AssetImage(images[index]),
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(
                                    padding: EdgeInsets.all(5),
                                    width: SizeConfig.blockSizeVertical * 12,
                                    height: SizeConfig.blockSizeVertical * 12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: SizeConfig.blockSizeVertical * 10,
                                      height: SizeConfig.blockSizeVertical * 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: AssetImage(images[index]),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }());
                          }, 
                          separatorBuilder: (context, index){
                            return SizedBox(width: SizeConfig.blockSizeHorizontal * 3,);
                          },
                          itemCount: 5,
                        ),
                      );
                    }
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                  MiscButtonTemplate(onPressed: (){Navigator.pushNamed(context, '/home/home-08-profile');}, width: SizeConfig.screenWidth / 2, height: SizeConfig.blockSizeVertical * 7),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}