import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularCreatePostSearchLocation extends StatefulWidget{
  
  @override
  HomeRegularCreatePostSearchLocationState createState() => HomeRegularCreatePostSearchLocationState();
}

class HomeRegularCreatePostSearchLocationState extends State<HomeRegularCreatePostSearchLocation>{
  TextEditingController controller = TextEditingController();
  List<String> places = [];
  bool empty = true;

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async {
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
                  setState((){
                    empty = true;
                    places = [];
                  });
                }else{
                  setState((){
                    empty = false;
                    places.add(newPlaces);
                  });
                }
              },
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 2.11,
                fontFamily: 'NexaRegular',
                color: const Color(0xff000000),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15.0),
                filled: true,
                fillColor: const Color(0xffffffff),
                focusColor: const Color(0xffffffff),
                hintText: 'Search Location',
                hintStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
                prefixIcon: const Icon(Icons.search, color: const Color(0xff888888)),
                border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            backgroundColor: const Color(0xff04ECFF),
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

                  const SizedBox(height: 20),

                  Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            )
            : ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemCount: places.length,
              separatorBuilder: (context, index){
                return const Divider(thickness: 1, color: const Color(0xff888888),);
              },
              itemBuilder: (context, index){
                return GestureDetector(
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            places[index],
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Additional user information',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Click to add on your post',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.11,
                              fontFamily: 'NexaRegular',
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
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