import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-11-regular-toggle-tabs.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-03-bloc-regular-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home-07-01-regular-post-extended.dart';
import 'home-07-02-regular-suggested.dart';
import 'home-07-03-regular-nearby.dart';
import 'home-07-04-regular-blm.dart';
import 'package:flutter/material.dart';

class HomeRegularPost extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
            BlocProvider<BlocHomeRegularUpdateToggleFeed>(
              create: (context) => BlocHomeRegularUpdateToggleFeed(),
            ),
            BlocProvider<BlocHomeRegularUpdateListSuggested>(
              create: (context) => BlocHomeRegularUpdateListSuggested(),
            ),
            BlocProvider<BlocHomeRegularUpdateListNearby>(
              create: (context) => BlocHomeRegularUpdateListNearby(),
            ),
            BlocProvider<BlocHomeRegularUpdateListBLM>(
              create: (context) => BlocHomeRegularUpdateListBLM(),
            ),
          ],
          child: Scaffold(
            // backgroundColor: Color(0xffeeeeee),
            appBar: AppBar(
              title: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Color(0xffffffff),
                  focusColor: Color(0xffffffff),
                  hintText: 'Search a Post',
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
                onPressed: (){Navigator.pop(context);},
              ),
              backgroundColor: Color(0xff04ECFF),
            ),
            body: BlocBuilder<BlocHomeRegularUpdateToggleFeed, int>(
              builder: (context, togglePost){
                return Column(
                  children: [

                    MiscRegularTabs(),

                    Container(
                      child: ((){
                        switch(togglePost){
                          // case 0: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
                          // case 0: return Container(
                          //   height: SizeConfig.blockSizeVertical * 2,
                          //   decoration: BoxDecoration(
                          //     // color: Color(0xffffffff),
                          //     color: Colors.transparent,
                          //     borderRadius: BorderRadius.all(Radius.circular(15),),
                          //     boxShadow: <BoxShadow>[
                          //       BoxShadow(
                          //         color: Colors.grey.withOpacity(0.5),
                          //         spreadRadius: 1,
                          //         blurRadius: 5,
                          //         offset: Offset(0, 0)
                          //       ),
                          //     ],
                          //   ),
                          // ); break;
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
                      }()),
                    ),

                    Expanded(
                      child: ((){
                        switch(togglePost){
                          case 0: return HomeRegularPostExtended(); break;
                          case 1: return HomeRegularSuggested(); break;
                          case 2: return HomeRegularNearby(); break;
                          case 3: return HomeRegularBLM(); break;
                        }
                      }()),
                    ),

                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}