import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-11-regular-toggle-tabs.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'home-20-01-regular-connection-list-family.dart';
import 'home-20-02-regular-connection-list-friends.dart';
import 'home-20-03-regular-connection-list-followers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularConnectionList extends StatelessWidget{

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
          ],
          child: Scaffold(
            appBar: AppBar(
              title: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Color(0xffffffff),
                  focusColor: Color(0xffffffff),
                  hintText: 'Search Family',
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

                    MiscRegularConnectionTabs(),

                    Expanded(
                      child: ((){
                        switch(togglePost){
                          case 0: return HomeRegularConnectionListFamily(); break;
                          case 1: return HomeRegularConnectionListFriends(); break;
                          case 2: return HomeRegularConnectionListFollowers(); break;
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