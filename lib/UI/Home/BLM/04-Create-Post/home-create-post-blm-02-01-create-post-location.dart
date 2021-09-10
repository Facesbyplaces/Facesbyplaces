import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/material.dart';

class HomeBLMCreatePostSearchLocation extends StatefulWidget{
  const HomeBLMCreatePostSearchLocation();

  @override
  HomeBLMCreatePostSearchLocationState createState() => HomeBLMCreatePostSearchLocationState();
}

class HomeBLMCreatePostSearchLocationState extends State<HomeBLMCreatePostSearchLocation>{
  ValueNotifier<List<String>> places = ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>> descriptionPlaces = ValueNotifier<List<String>>([]);
  ValueNotifier<List<List<double>>> locationPlaces = ValueNotifier<List<List<double>>>([]);
  ValueNotifier<bool> empty = ValueNotifier<bool>(true);
  TextEditingController controller = TextEditingController();
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
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(70),
                      child: AppBar(
                      leading: Container(),
                      backgroundColor: const Color(0xff04ECFF),
                      flexibleSpace: Column(
                        children: [
                          const Spacer(),

                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 35,),
                                  onPressed: (){
                                    Navigator.pop(context,);
                                    // Navigator.pop(context, ['San Francisco', 37.78583400000001, -122.406417]);
                                  },
                                ),
                              ),

                              Expanded(
                                child: TextFormField(
                                  controller: controller,
                                  style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                                  decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                                    enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                                    border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                                    hintStyle: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
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
                                      empty.value = false;

                                      context.loaderOverlay.show();
                                      GooglePlace googlePlace = GooglePlace("AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg");
                                      var result = await googlePlace.autocomplete.get(newPlaces);
                                      context.loaderOverlay.hide();

                                      places.value = [];
                                      descriptionPlaces.value = [];
                                      locationPlaces.value = [];

                                      if(result != null){
                                        for(int i = 0; i < result.predictions!.length; i++){
                                          places.value.add('${result.predictions![i].terms![0].value}, ${result.predictions![i].terms![1].value}');
                                          descriptionPlaces.value.add('${result.predictions![i].description}');
                                          locationPlaces.value.add([37.79170209999999, -122.4041937]);
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(width: 20,),
                            ],
                          ),

                          SizedBox(height: 5,),
                        ],
                      ),
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

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Search a location to add on your post', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
                          ),

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