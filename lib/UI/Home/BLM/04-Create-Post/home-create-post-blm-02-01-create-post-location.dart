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
              decoration: const InputDecoration(
                contentPadding: const EdgeInsets.all(15.0),
                filled: true,
                fillColor: const Color(0xffffffff),
                focusColor: const Color(0xffffffff),
                hintText: 'Search Location',
                hintStyle: const TextStyle(
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.search, color: const Color(0xff888888)),
                border: const OutlineInputBorder(
                  borderSide: const BorderSide(color: const Color(0xffffffff)),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                enabledBorder:  const OutlineInputBorder(
                  borderSide: const BorderSide(color: const Color(0xffffffff)),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                focusedBorder:  const OutlineInputBorder(
                  borderSide: const BorderSide(color: const Color(0xffffffff)),
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
              ),
            ),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
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

                  const SizedBox(height: 20,),

                  const Text('Search a location to add on your post', style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            )
            : ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.pop(context, places[index]);
                  },
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(places[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000)),),),

                        Expanded(child: const Text('Additional user information', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),),),

                        Expanded(child: const Text('Click to add on your post', style: const TextStyle(fontSize: 12, color: const Color(0xff888888),),),),
                      ],
                    ),
                  ),
                );
              }, 
              separatorBuilder: (context, index){
                return const Divider(thickness: 1, color: const Color(0xff888888),);
              },
              itemCount: places.length,
            ),
          ),
        ),
      ),
    );
  }
}