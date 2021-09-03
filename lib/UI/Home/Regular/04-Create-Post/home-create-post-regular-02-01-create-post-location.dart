// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:osm_nominatim/osm_nominatim.dart';
// import 'package:flutter/material.dart';

// class HomeRegularCreatePostSearchLocation extends StatefulWidget{
//   const HomeRegularCreatePostSearchLocation();
  
//   @override
//   HomeRegularCreatePostSearchLocationState createState() => HomeRegularCreatePostSearchLocationState();
// }

// class HomeRegularCreatePostSearchLocationState extends State<HomeRegularCreatePostSearchLocation>{
//   ValueNotifier<List<String>> places = ValueNotifier<List<String>>([]);
//   ValueNotifier<List<String>> descriptionPlaces = ValueNotifier<List<String>>([]);
//   ValueNotifier<List<List<double>>> locationPlaces = ValueNotifier<List<List<double>>>([]);
//   ValueNotifier<bool> empty = ValueNotifier<bool>(true);
//   TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     return WillPopScope(
//       onWillPop: () async{
//         return Navigator.canPop(context);
//       },
//       child: GestureDetector(
//         onTap: (){
//           FocusNode currentFocus = FocusScope.of(context);
//           if(!currentFocus.hasPrimaryFocus){
//             currentFocus.unfocus();
//           }
//         },
//         child: ValueListenableBuilder(
//           valueListenable: places,
//           builder: (_, List<String> placesListener, __) => ValueListenableBuilder(
//             valueListenable: descriptionPlaces,
//             builder: (_, List<String> descriptionPlacesListener, __) => ValueListenableBuilder(
//               valueListenable: locationPlaces,
//               builder: (_, List<List<double>> locationPlacesListener, __) => ValueListenableBuilder(
//                 valueListenable: empty,
//                 builder: (_, bool emptyListener, __) => Scaffold(
//                   appBar: AppBar(
//                     backgroundColor: const Color(0xff04ECFF),
//                     leading: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),),
//                       onPressed: (){
//                         Navigator.pop(context, '');
//                       },
//                     ),
//                     title: TextFormField(
//                       controller: controller,
//                       style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
//                       decoration: InputDecoration(
//                         focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
//                         enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
//                         border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
//                         hintStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
//                         prefixIcon: const Icon(Icons.search, color: const Color(0xff888888)),
//                         contentPadding: const EdgeInsets.all(15.0),
//                         focusColor: const Color(0xffffffff),
//                         fillColor: const Color(0xffffffff),
//                         hintText: 'Search Location',
//                         filled: true,
//                       ),
//                       onChanged: (newPlaces) async{
//                         if(newPlaces == ''){
//                           empty.value = true;
//                           places.value = [];
//                           descriptionPlaces.value = [];
//                           locationPlaces.value = [];
//                         }else{
//                           empty.value = false;

//                           context.loaderOverlay.show();
//                           List<Place> searchResult = await Nominatim.searchByName(
//                             query: '$newPlaces',
//                             limit: 5,
//                             addressDetails: true,
//                             extraTags: true,
//                             nameDetails: true,
//                           );
//                           context.loaderOverlay.hide();

//                           places.value = [];
//                           descriptionPlaces.value = [];
//                           locationPlaces.value = [];

//                           for(int i = 0; i < searchResult.length; i++){
//                             places.value.add(searchResult[i].nameDetails!['name'] ?? '');
//                             descriptionPlaces.value.add(searchResult[i].displayName);
//                             locationPlaces.value.add([searchResult[i].lat, searchResult[i].lon]);
//                           }
//                         }
//                       },
//                     ),
//                   ),
//                   body: Container(
//                     width: SizeConfig.screenWidth,
//                     child: emptyListener
//                     ? SingleChildScrollView(
//                       physics: const ClampingScrollPhysics(),
//                       child: Column(
//                         children: [
//                           SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

//                           const Icon(Icons.place_rounded, size: 240, color: const Color(0xff888888),),

//                           const SizedBox(height: 20),

//                           Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

//                           SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
//                         ],
//                       ),
//                     )
//                     : ListView.separated(
//                       physics: const ClampingScrollPhysics(),
//                       itemCount: placesListener.length,
//                       separatorBuilder: (context, index){
//                         return const Divider(thickness: 1, color: const Color(0xff888888),);
//                       },
//                       itemBuilder: (context, index){
//                         return ListTile(
//                           title: Text(placesListener[index], style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
//                           subtitle: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(descriptionPlacesListener[index], style: TextStyle(fontSize: 14, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

//                               SizedBox(height: 5,),

//                               Text('Click to add on your post', style: TextStyle(fontSize: 12, fontFamily: 'NexaRegular', color: const Color(0xff888888),),),
//                             ],
//                           ),
//                           onTap: (){
//                             Navigator.pop(context, [placesListener[index], locationPlacesListener[index][0], locationPlacesListener[index][1]]);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/material.dart';

class HomeRegularCreatePostSearchLocation extends StatefulWidget{
  const HomeRegularCreatePostSearchLocation();
  
  @override
  HomeRegularCreatePostSearchLocationState createState() => HomeRegularCreatePostSearchLocationState();
}

class HomeRegularCreatePostSearchLocationState extends State<HomeRegularCreatePostSearchLocation>{
  ValueNotifier<List<String>> places = ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>> descriptionPlaces = ValueNotifier<List<String>>([]);
  ValueNotifier<List<List<double>>> locationPlaces = ValueNotifier<List<List<double>>>([]);
  ValueNotifier<bool> empty = ValueNotifier<bool>(true);
  TextEditingController controller = TextEditingController();

  // GooglePlace googlePlace = GooglePlace("AIzaSyDwu4SiF_dg2PaDxyv4AunjO2ixKlr-AeA");
  List<AutocompletePrediction> predictions = [];

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
        child: ValueListenableBuilder(
          valueListenable: places,
          builder: (_, List<String> placesListener, __) => ValueListenableBuilder(
            valueListenable: descriptionPlaces,
            builder: (_, List<String> descriptionPlacesListener, __) => ValueListenableBuilder(
              valueListenable: locationPlaces,
              builder: (_, List<List<double>> locationPlacesListener, __) => ValueListenableBuilder(
                valueListenable: empty,
                builder: (_, bool emptyListener, __) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xff04ECFF),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),),
                      onPressed: (){
                        Navigator.pop(context, '');
                      },
                    ),
                    title: TextFormField(
                      controller: controller,
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                        enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                        border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                        hintStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
                        prefixIcon: const Icon(Icons.search, color: const Color(0xff888888)),
                        contentPadding: const EdgeInsets.all(15.0),
                        focusColor: const Color(0xffffffff),
                        fillColor: const Color(0xffffffff),
                        hintText: 'Search Location',
                        filled: true,
                      ),
                      onChanged: (newPlaces) async{
                        if(newPlaces == ''){
                          empty.value = true;
                          places.value = [];
                          descriptionPlaces.value = [];
                          locationPlaces.value = [];
                        }else{
                          // empty.value = false;

                          // context.loaderOverlay.show();

                          // var googlePlace = GooglePlace("AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg");
                          // GooglePlace searchResult = await googlePlace.autocomplete.get("1600 Amphitheatre");
                          // // List<Place> searchResult = await Nominatim.searchByName(
                          // //   query: '$newPlaces',
                          // //   limit: 5,
                          // //   addressDetails: true,
                          // //   extraTags: true,
                          // //   nameDetails: true,
                          // // );
                          // context.loaderOverlay.hide();

                          // places.value = [];
                          // descriptionPlaces.value = [];
                          // locationPlaces.value = [];

                          // for(int i = 0; i < searchResult.length; i++){
                          //   places.value.add(searchResult[i].nameDetails!['name'] ?? '');
                          //   descriptionPlaces.value.add(searchResult[i].displayName);
                          //   locationPlaces.value.add([searchResult[i].lat, searchResult[i].lon]);
                          // }
                          GooglePlace googlePlace = GooglePlace("AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg");


                          print('The api key is ${googlePlace.apiKEY}');
                          print('The newPlaces is $newPlaces');

                          

                          var result = await googlePlace.autocomplete.get(newPlaces);
                          
                          if (result != null && result.predictions != null) {

                            setState(() {
                              predictions = result.predictions!;
                              print('The result is ${result.status}');
                              print('The result is ${result.predictions}');
                              // print('The predictions is ${predictions[0].description}');

                              
                            });
                          }
                        }
                      },
                    ),
                  ),
                  body: Container(
                    width: SizeConfig.screenWidth,
                    child: emptyListener
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
                      itemCount: placesListener.length,
                      separatorBuilder: (context, index){
                        return const Divider(thickness: 1, color: const Color(0xff888888),);
                      },
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text(placesListener[index], style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(descriptionPlacesListener[index], style: TextStyle(fontSize: 14, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                              SizedBox(height: 5,),

                              Text('Click to add on your post', style: TextStyle(fontSize: 12, fontFamily: 'NexaRegular', color: const Color(0xff888888),),),
                            ],
                          ),
                          onTap: (){
                            Navigator.pop(context, [placesListener[index], locationPlacesListener[index][0], locationPlacesListener[index][1]]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}