import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/API/BLM/api-05-blm-create-memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeBLMCreateMemorial3 extends StatelessWidget{

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeBLMBackgroundImage>(
          create: (context) => BlocHomeBLMBackgroundImage(),
        ),
        BlocProvider<BlocShowLoading>(
          create: (context) => BlocShowLoading(),
        ),
      ],
      child: BlocBuilder<BlocShowLoading, bool>(
        builder: (context, loading){
          return ((){
            switch(loading){
              case false: return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xff04ECFF),
                  title: Text('Cry out for the Victims', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
                  centerTitle: true,
                  leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);}),
                ),
                body: Stack(
                  children: [

                    MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
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

                          BlocBuilder<BlocHomeBLMBackgroundImage, int>(
                            builder: (context, state){
                              return Container(
                                height: SizeConfig.blockSizeVertical * 12,
                                child: ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    return ((){
                                      if(index == 4){
                                        return GestureDetector(
                                          onTap: (){
                                            context.bloc<BlocHomeBLMBackgroundImage>().updateToggle(index);
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
                                            context.bloc<BlocHomeBLMBackgroundImage>().updateToggle(index);
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
                                                  fit: BoxFit.cover,
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
                                                  fit: BoxFit.cover,
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

                          MiscBLMButtonTemplate(
                            onPressed: () async{

                              context.bloc<BlocShowLoading>().modify(true);
                              bool result = await apiBLMCreateMemorial();
                              context.bloc<BlocShowLoading>().modify(false);

                              if(result){
                                Navigator.pushReplacementNamed(context, '/home/blm/home-12-blm-profile');
                              }else{
                                await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                              }
                                
                            }, 
                            width: SizeConfig.screenWidth / 2, 
                            height: SizeConfig.blockSizeVertical * 7,
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ); break;
              case true: return Scaffold(body: Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)),); break;
            }
          }());
          
        },
      ),
    );
  }
}