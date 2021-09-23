import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/material.dart';

class HomeBLMCreatePostSearchLocation extends StatefulWidget{
  const HomeBLMCreatePostSearchLocation({Key? key}) : super(key: key);

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
  List<String> placeId = [];

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
                    preferredSize: const Size.fromHeight(70),
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
                                  icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                                  onPressed: (){
                                    Navigator.pop(context,);
                                  },
                                ),
                              ),

                              Expanded(
                                child: TextFormField(
                                  controller: controller,
                                  style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                    hintStyle: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                    prefixIcon: Icon(Icons.search, color: Color(0xff888888)),
                                    contentPadding: EdgeInsets.all(15.0),
                                    focusColor: Color(0xffffffff),
                                    fillColor: Color(0xffffffff),
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
                                      context.loaderOverlay.show();
                                      GooglePlace googlePlace = GooglePlace("AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg");
                                      var result = await googlePlace.autocomplete.get(newPlaces);
                                      context.loaderOverlay.hide();

                                      places.value = [];
                                      descriptionPlaces.value = [];
                                      locationPlaces.value = [];
                                      placeId = [];

                                      if(result != null){
                                        for(int i = 0; i < result.predictions!.length; i++){
                                          places.value.add('${result.predictions![i].terms![0].value}, ${result.predictions![i].terms![1].value}');
                                          placeId.add('${result.predictions![i].placeId}');
                                          descriptionPlaces.value.add('${result.predictions![i].description}');
                                        }

                                        empty.value = false;
                                      }
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(width: 20,),
                            ],
                          ),

                          const SizedBox(height: 5,),
                        ],
                      ),
                    ),
                  ),
                  body: SizedBox(
                    width: SizeConfig.screenWidth,
                    child: emptyListener
                    ? SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                          const Icon(Icons.place_rounded, size: 240, color: Color(0xff888888),),

                          const SizedBox(height: 20),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Search a location to add on your post', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                          ),

                          SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                        ],
                      ),
                    )
                    : ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: placesListener.length,
                      separatorBuilder: (context, index){
                        return const Divider(thickness: 1, color: Color(0xff888888),);
                      },
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text(placesListener[index], style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(descriptionPlacesListener[index], style: const TextStyle(fontSize: 14, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                              const SizedBox(height: 5,),

                              const Text('Click to add on your post', style: TextStyle(fontSize: 12, fontFamily: 'NexaRegular', color: Color(0xff888888),),),
                            ],
                          ),
                          onTap: () async{
                            context.loaderOverlay.show();
                            GooglePlace googlePlace = GooglePlace("AIzaSyCTPIQSGBS0cdzWRv9VGqrRuVwd2KuuhNg");
                            var newResult = await googlePlace.details.get(placeId[index]);
                            context.loaderOverlay.hide();

                            Navigator.pop(context, [placesListener[index], newResult!.result!.geometry!.location!.lat, newResult.result!.geometry!.location!.lng]);
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