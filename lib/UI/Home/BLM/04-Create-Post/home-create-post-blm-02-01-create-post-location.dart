import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeBLMCreatePostSearchLocation extends StatefulWidget{

  @override
  HomeBLMCreatePostSearchLocationState createState() => HomeBLMCreatePostSearchLocationState();
}

class HomeBLMCreatePostSearchLocationState extends State<HomeBLMCreatePostSearchLocation>{
  TextEditingController controller = TextEditingController();
  List<String> places = [];
  bool empty = true;

  @override
  Widget build(BuildContext context){
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
            backgroundColor: const Color(0xff04ECFF),
            title: TextFormField(
              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
                prefixIcon: const Icon(Icons.search, color: const Color(0xff888888)),
                contentPadding: const EdgeInsets.all(15.0),
                focusColor: const Color(0xffffffff),
                fillColor: const Color(0xffffffff),
                hintText: 'Search Location',
                filled: true,
                border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
              ),
              onChanged: (newPlaces){
                if(newPlaces == ''){
                  setState((){
                    empty = true;
                    places = [];
                  });
                } else {
                  setState((){
                    empty = false;
                    places.add(newPlaces);
                  });
                }
              },
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),),
              onPressed: (){
                Navigator.pop(context, '');
              },
            ),
          ),
          body: Container(
            width: SizeConfig.screenWidth,
            child: empty
            ? SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                  const Icon(Icons.place_rounded, size: 240, color: const Color(0xff888888),),

                  const SizedBox(height: 20,),

                  Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            )
            : ListView.separated(
              physics: const ClampingScrollPhysics(),
              separatorBuilder: (context, index){
                return const Divider(thickness: 1, color: const Color(0xff888888),);
              },
              itemCount: places.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(places[index], style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),),

                        Expanded(child: Text('Additional user information', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),),

                        Expanded(child: Text('Click to add on your post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context, places[index]);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}