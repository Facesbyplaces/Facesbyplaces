import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/home-03-feed.dart';
import 'package:facesbyplaces/UI/Home/home-09-memorial.dart';
import 'package:facesbyplaces/UI/Home/home-15-notifications.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home-04-search.dart';
import 'home-05-post.dart';
import 'home-10-create-memorial.dart';
import 'home-11-profile.dart';
import 'home-12-memorial-settings.dart';
import 'home-13-create-post.dart';
import 'home-14-memorial-list.dart';
import 'home-16-page-details.dart';
import 'home-17-user-profile.dart';

class HomeScreenExtended extends StatelessWidget{

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
        child: Scaffold(
          appBar: MiscMainAppBar(appBar: displayAppBar(),),

          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icons/background2.png'),
                colorFilter: ColorFilter.srgbToLinearGamma(),
              ),
            ),

            child: BlocBuilder<BlocHomeUpdateCubit, int>(
              builder: (context, state){
                return ((){
                  switch(state){
                    case 0: return HomeFeed(); break;
                    case 1: return HomeSearch(); break;
                    case 2: return HomePost(); break;
                    case 3: return HomeMemorialProfile(); break;
                    case 4: return HomeCreateMemorial(); break;
                    case 5: return HomeCreateMemorial2(); break;
                    case 6: return HomeCreateMemorial3(); break;
                    case 7: return HomeProfile(); break;
                    case 8: return HomeMemorialSettings(); break;
                    case 9: return HomeCreatePost(); break;
                    case 10: return HomeManage(); break;
                    case 11: return HomeNotifications(); break;
                    case 12: return HomePageDetails(); break;
                    case 13: return HomeCreateMemorial3(); break;
                    case 14: return HomeUserProfile(); break;
                  }
                }());
              },
            ),
          ),

          bottomSheet: BlocBuilder<BlocHomeUpdateCubit, int>(
            builder: (context, state){
              return ((){
                switch(state){
                  case 0: return MiscBottomSheet(); break;
                  case 1: return Container(height: 0,); break;
                  case 2: return Container(height: 0,); break;
                  case 3: return Container(height: 0,); break;
                  case 4: return Container(height: 0,); break;
                  case 5: return Container(height: 0,); break;
                  case 6: return Container(height: 0,); break;
                  case 7: return Container(height: 0,); break;
                  case 8: return Container(height: 0,); break;
                  case 9: return Container(height: 0,); break;
                  case 10: return MiscBottomSheet(); break;
                  case 11: return MiscBottomSheet(); break;
                  case 12: return Container(height: 0,); break;
                  case 13: return Container(height: 0,); break;
                  case 14: return Container(height: 0,); break;
                }
              }());
            },
          ),

        ),
      ),
    );
  }

  displayAppBar(){
    return BlocBuilder<BlocHomeUpdateCubit, int>(
      builder: (context, state){
        return ((){
          switch(state){
            case 0: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                title: Text('FacesByPlaces.com',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xffffffff),
                  ),
                ),
                leading: IconButton(
                  icon: Image.asset('assets/icons/profile1.png'),
                  onPressed: (){},
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search, 
                      color: Color(0xffffffff), 
                      size: SizeConfig.blockSizeVertical * 4,
                    ), 
                    onPressed: (){
                      context.bloc<BlocHomeUpdateCubit>().modify(1);
                    },
                  ),
                ], 
                backgroundColor: Color(0xff4EC9D4), 
                color: Color(0xffffffff),
              ); 
            break;
            case 1: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
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
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(0);
                  },
                ),
                actions: [], 
                backgroundColor: Color(0xff04ECFF),
                color: Color(0xffffffff),
              ); 
            break;
            case 2: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
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
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(0);
                    context.bloc<BlocHomeUpdateToggle>().reset();
                    context.bloc<BlocHomeUpdateToggleFeed>().updateToggle(0);
                    // BlocHomeUpdateToggleFeed
                  },
                ),
                actions: [], 
                backgroundColor: Color(0xff04ECFF),
                color: Color(0xffffffff),
              ); 
            break;
            case 3: return Container(height: 0,); break;
            case 4: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back, 
                    color: Color(0xffffffff),
                  ), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(0);
                  },
                ),
                title: Text('Cry out for the Victims',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff),
                  ),
                ),
                actions: [], 
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              ); 
            break;
            case 5: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back, 
                    color: Color(0xffffffff),
                  ), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(4);
                  },
                ),
                title: Text('Cry out for the Victims',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff),
                  ),
                ),
                actions: [], 
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              ); 
            break;
            case 6: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back, 
                    color: Color(0xffffffff),
                  ), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(5);
                  },
                ),
                title: Text('Cry out for the Victims',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff),
                  ),
                ),
                actions: [], 
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              ); 
            break;
            case 7: return Container(height: 0,); break;
            case 8: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateMemorialToggle>().updateToggle(0);
                    context.bloc<BlocHomeUpdateCubit>().modify(7);
                  },
                ),
                title: Text('Memorial Settings',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xffffffff),
                  ),
                ),
                actions: [], 
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              ); 
            break;
            case 9: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                title: Text('Create Post',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xffffffff),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(0);
                    // context.bloc<BlocHomeUpdateMemorialToggle>().updateToggle(0);
                    context.bloc<BlocHomeUpdateToggle>().reset();
                  },
                ),
                actions: [
                  GestureDetector(
                    onTap: (){
                      context.bloc<BlocHomeUpdateCubit>().modify(7);
                    }, 
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0), 
                      child: Center(
                        child: Text('Post', 
                        style: TextStyle(
                          color: Color(0xffffffff), 
                          fontSize: SizeConfig.safeBlockHorizontal * 5,),
                        ),
                      ),
                    ),
                  ),
                ], 
                backgroundColor: Color(0xff04ECFF),
                color: Color(0xffffffff),
              ); 
            break;
            case 10: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                title: Text('FacesByPlaces.com',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xffffffff),
                  ),
                ),
                leading: IconButton(
                  icon: Image.asset('assets/icons/profile1.png'),
                  onPressed: (){},
                ),
                actions: [
                  GestureDetector(
                    onTap: (){
                      context.bloc<BlocHomeUpdateCubit>().modify(7);
                    }, 
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0), 
                      child: Center(
                        child: Icon(
                          Icons.search, 
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ], 
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              ); 
            break;
            case 11: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                title: Text('Keeping a friend or family member legacy alive',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xffffffff),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(0);
                    // context.bloc<BlocHomeUpdateMemorialToggle>().updateToggle(0);
                    context.bloc<BlocHomeUpdateToggle>().reset();
                  },
                ),
                actions: [
                  GestureDetector(
                    onTap: (){
                      context.bloc<BlocHomeUpdateCubit>().modify(7);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0), 
                      child: Center(
                        child: Icon(
                          Icons.search, 
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ],
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              );
            break;
            case 12: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                title: Text('Memorial Settings',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xffffffff),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(8);
                    // context.bloc<BlocHomeUpdateMemorialToggle>().updateToggle(0);
                    context.bloc<BlocHomeUpdateToggle>().reset();
                  },
                ),
                actions: [
                  GestureDetector(
                    onTap: (){
                      // context.bloc<BlocHomeUpdateCubit>().modify(7);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0), 
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ],
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              );
            break;
            case 13: return 
              MiscAppBarTemplate(
                appBar: AppBar(), 
                title: Text('Page Image',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xffffffff),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                  onPressed: (){
                    context.bloc<BlocHomeUpdateCubit>().modify(8);
                    context.bloc<BlocHomeUpdateToggle>().reset();
                  },
                ),
                actions: [
                  GestureDetector(
                    onTap: (){
                      // context.bloc<BlocHomeUpdateCubit>().modify(7);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0), 
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ],
                backgroundColor: Color(0xff04ECFF), 
                color: Color(0xffffffff),
              );
            break;
            case 14: return Container(height: 0,); break;
          }
        }());
      },
    );
  }
}