import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularPageFriends extends StatefulWidget{

  HomeRegularPageFriendsState createState() => HomeRegularPageFriendsState();
}

class HomeRegularPageFriendsState extends State<HomeRegularPageFriends>{

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
            BlocProvider<BlocShowLoading>(create: (context) => BlocShowLoading(),)
          ],
          child: BlocBuilder<BlocShowLoading, bool>(
            builder: (context, loading){
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xff04ECFF),
                  title: Text('Page Friends', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
                  centerTitle: true,
                  leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                  actions: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, 'home/regular/home-26-regular-search-user');
                      },
                      child: Center(child: Text('Add Friends', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),),
                    ),
                  ],
                ),
                body: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: SizeConfig.blockSizeVertical * 5,
                            backgroundColor: Color(0xff888888),
                            backgroundImage: AssetImage('assets/icons/graveyard.png'),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Danielle Roberts', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                                Text('Mother', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
                              ],
                            ),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                          MaterialButton(
                            minWidth: SizeConfig.screenWidth / 3.5,
                            padding: EdgeInsets.zero,
                            textColor: Color(0xffffffff),
                            splashColor: Color(0xff04ECFF),
                            onPressed: () async{

                            },
                            child: Text('Remove', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                            height: SizeConfig.blockSizeVertical * 5,
                            shape: StadiumBorder(
                              side: BorderSide(color: Color(0xffE74C3C)),
                            ),
                              color: Color(0xffE74C3C),
                          ),
 

                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index){
                    return Divider(height: SizeConfig.blockSizeVertical * 2,);
                  },
                  itemCount: 4,
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}