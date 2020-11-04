import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-15-dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home-05-02-suggested.dart';
import 'home-05-03-nearby.dart';
import 'home-05-04-blm.dart';

class HomePost extends StatelessWidget{

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
            BlocProvider<BlocHomeUpdateToggleFeed>(
              create: (context) => BlocHomeUpdateToggleFeed(),
            ),
            BlocProvider<BlocHomeUpdateListSuggested>(
              create: (context) => BlocHomeUpdateListSuggested(),
            ),
            BlocProvider<BlocHomeUpdateListNearby>(
              create: (context) => BlocHomeUpdateListNearby(),
            ),
            BlocProvider<BlocHomeUpdateListBLM>(
              create: (context) => BlocHomeUpdateListBLM(),
            ),
          ],
          child: Scaffold(
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
            body: Container(
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
              child: Column(
                children: [

                  MiscTabs(),

                  Container(
                    child: BlocBuilder<BlocHomeUpdateToggleFeed, int>(
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
                    child: BlocBuilder<BlocHomeUpdateToggleFeed, int>(
                      builder: (context, state){
                        return ((){
                          switch(state){
                            case 0: return HomePostExtended(); break;
                            case 1: return HomeSuggested(); break;
                            case 2: return HomeNearby(); break;
                            case 3: return HomeBLM(); break;
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

class HomePostExtended extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      itemCount: 5,
      itemBuilder: (context, index){
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              height: SizeConfig.blockSizeVertical * 60,
              decoration: BoxDecoration(color: Color(0xffffffff), borderRadius: BorderRadius.all(Radius.circular(15),),),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){Navigator.pushNamed(context, '/home/home-12-user-profile');},
                          child: CircleAvatar(backgroundImage: AssetImage('assets/icons/profile1.png'),),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(alignment: Alignment.bottomLeft,child: Text('Black Lives Matter', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),
                                ),
                                Expanded(
                                  child: Align(alignment: Alignment.topLeft, child: Text('an hour ago', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w400, color: Color(0xffaaaaaa),),),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MiscDropDownTemplate(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
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
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Color(0xff888888),
                                      ),
                                    ),

                                    Align(
                                      child: Text('+4',
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 7,
                                          color: Color(0xffffffff),
                                        ),
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
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset('assets/icons/peace_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                Text('24.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                Text('14.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: (){},
                            child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2,),
          ],
        );
      }
    );
  }
}