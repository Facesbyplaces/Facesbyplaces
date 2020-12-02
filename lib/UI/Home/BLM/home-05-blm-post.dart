import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home-06-01-blm-post.dart';
import 'home-06-02-blm-suggested.dart';
import 'home-06-03-blm-nearby.dart';
import 'home-06-04-blm.dart';

class HomeBLMPost extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    // final value = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider<BlocHomeBLMUpdateToggleFeed>(
              create: (context) => BlocHomeBLMUpdateToggleFeed(),
            ),
            BlocProvider<BlocHomeBLMUpdateListSuggested>(
              create: (context) => BlocHomeBLMUpdateListSuggested(),
            ),
            BlocProvider<BlocHomeBLMUpdateListNearby>(
              create: (context) => BlocHomeBLMUpdateListNearby(),
            ),
            BlocProvider<BlocHomeBLMUpdateListBLM>(
              create: (context) => BlocHomeBLMUpdateListBLM(),
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              title: TextFormField(
                onChanged: (search){

                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Color(0xffffffff),
                  focusColor: Color(0xffffffff),
                  hintText: 'Search Memorial',
                  hintStyle: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffffffff)),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffffffff)),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffffffff)),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Color(0xff04ECFF),
            ),
            body: Container(
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
              child: Column(
                children: [

                  MiscBLMTabs(),

                  Container(
                    child: BlocBuilder<BlocHomeBLMUpdateToggleFeed, int>(
                      builder: (context, state){
                        return ((){
                          switch(state){
                            case 0: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
                            case 1: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
                            case 2: return 
                            Container(
                              height: SizeConfig.blockSizeVertical * 5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                    Icon(Icons.location_pin, color: Color(0xff979797),),

                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                    Text('4015 Oral Lake Road, New York', style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                                  ],
                                ),
                              ),
                            ); break;
                            case 3: return 
                            Container(
                              height: SizeConfig.blockSizeVertical * 5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                    Icon(Icons.location_pin, color: Color(0xff979797),),

                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                    Text('4015 Oral Lake Road, New York', style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                                  ],
                                ),
                              ),
                            ); break;
                          }
                        }());
                      },
                    ),
                  ),

                  Expanded(
                    child: BlocBuilder<BlocHomeBLMUpdateToggleFeed, int>(
                      builder: (context, state){
                        return ((){
                          switch(state){
                            case 0: return HomeBLMPostExtended(); break;
                            case 1: return HomeBLMSuggested(); break;
                            case 2: return HomeBLMNearby(); break;
                            case 3: return HomeBLMBLM(); break;
                          }
                        }());
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}