import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularCreatePostSearch extends StatefulWidget{

  @override
  HomeRegularCreatePostSearchState createState() => HomeRegularCreatePostSearchState();
}

class HomeRegularCreatePostSearchState extends State<HomeRegularCreatePostSearch>{
  
  TextEditingController controller = TextEditingController();
  List<String> places;
  bool empty;

  void initState(){
    super.initState();
    places = [];
    empty = true;
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
        child: Scaffold(
          appBar: AppBar(
            title: TextFormField(
              onChanged: (newPlaces){
                if(newPlaces == ''){
                  setState(() {
                    empty = true;
                    places = [];
                  });
                }else{
                  setState(() {
                    empty = false;
                    places.add(newPlaces);
                  });
                }                
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                filled: true,
                fillColor: Color(0xffffffff),
                focusColor: Color(0xffffffff),
                hintText: 'Search Location',
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
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: empty
          ? SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              height: SizeConfig.screenHeight - kToolbarHeight,
              child: Column(
                children: [
                  Expanded(child: Container(),),

                  Icon(Icons.place_rounded, size: SizeConfig.blockSizeVertical * 30, color: Color(0xff888888),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

                  Expanded(child: Container(),),
                ],
              ),
            ),
          )
          : ListView.separated(
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  Navigator.pop(context, places[index]);
                },
                child: Container(
                  height: SizeConfig.blockSizeVertical * 10,
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(places[index], style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Colors.black),),),

                      Expanded(child: Text('Additional user information', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff000000),),),),

                      Expanded(child: Text('Click to add on your post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, color: Color(0xff888888),),),),
                    ],
                  ),
                ),
              );
            }, 
            separatorBuilder: (context, index){
              return Divider(thickness: SizeConfig.blockSizeVertical * .1, color: Color(0xff888888),);
            },
            itemCount: places.length,
          ),
        ),
      ),
    );
  }
}

