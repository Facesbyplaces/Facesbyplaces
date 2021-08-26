import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeBLMCreateMemorialLocateMap extends StatefulWidget{
  const HomeBLMCreateMemorialLocateMap();
  
  @override
  HomeBLMCreateMemorialLocateMapState createState() => HomeBLMCreateMemorialLocateMapState();
}

class HomeBLMCreateMemorialLocateMapState extends State<HomeBLMCreateMemorialLocateMap>{
  late TextEditingController textEditingController = TextEditingController();
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: true,
  );

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(textOnChanged);
  }

  void textOnChanged() {
    controller.setSearchableText(textEditingController.text);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textOnChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return CustomPickerLocation(
      controller: controller,
      appBarPicker: AppBar(
        title: TextField(
          controller: textEditingController,
          onEditingComplete: () async{
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          decoration: InputDecoration(
            errorBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffff0000),),),
            prefixIcon: const Icon(Icons.search, color: const Color(0xff000000),),
            focusColor: const Color(0xff000000),
            enabledBorder: InputBorder.none,
            fillColor: Colors.grey[300],
            border: InputBorder.none,
            hintText: "search",
            filled: true,
            suffix: ValueListenableBuilder<TextEditingValue>(
              valueListenable: textEditingController,
              builder: (ctx, text, child){
                if(text.text.isNotEmpty){
                  return child!;
                }
                return SizedBox.shrink();
              },
              child: InkWell(
                onTap: (){
                  textEditingController.clear();
                  controller.setSearchableText("");
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Icon(Icons.close, size: 16, color: const Color(0xff000000),),
                focusNode: FocusNode(),
              ),
            ),
          ),
        ),
      ),
      topWidgetPicker: HomeBLMCreateMemorialLocateMapTopWidget(),
      bottomWidgetPicker: Container(
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.all(5),
        child: FloatingActionButton(
          onPressed: () async{
            GeoPoint p = await controller.getCurrentPositionAdvancedPositionPicker();
            print('The geopoint latitude is ${p.latitude}');
            print('The geopoint longitude is ${p.longitude}');
            Navigator.pop(context, p);
          },
          child: const Icon(Icons.location_pin),
        ),
      ),
    );
  }
}


class HomeBLMCreateMemorialLocateMapTopWidget extends StatefulWidget{
  const HomeBLMCreateMemorialLocateMapTopWidget();

  @override
  HomeBLMCreateMemorialLocateMapTopWidgetState createState() => HomeBLMCreateMemorialLocateMapTopWidgetState();
}

class HomeBLMCreateMemorialLocateMapTopWidgetState extends State<HomeBLMCreateMemorialLocateMapTopWidget>{
  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  late PickerMapController controller;
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  final Key streamKey = Key("streamAddressSug");
  Timer? _timerToStartSuggestionReq;
  String oldText = "";

  @override
  void initState(){
    super.initState();
    controller = CustomPickerLocation.of(context);
    controller.searchableText.addListener(onSearchableTextChanged);
  }

  void onSearchableTextChanged() async{
    final v = controller.searchableText.value;
    if(v.length > 3 && oldText != v){
      oldText = v;
      if(_timerToStartSuggestionReq != null && _timerToStartSuggestionReq!.isActive){
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq = Timer.periodic(Duration(seconds: 3), (timer) async{
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if(v.isEmpty){
      await reInitStream();
    }
  }

  Future reInitStream() async{
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState((){
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async{
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(addr, limitInformation: 5,);
    _futureSuggestionAddress.then((value){
      streamSuggestion.sink.add(value);
    });
  }

  @override
  void dispose(){
    controller.searchableText.removeListener(onSearchableTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder<bool>(
      valueListenable: notifierAutoCompletion,
      builder: (ctx, isVisible, child){
        return AnimatedContainer(
          duration: Duration(milliseconds: 500,),
          height: isVisible ? MediaQuery.of(context).size.height / 4 : 0,
          child: Card(child: child!,),
        );
      },
      child: StreamBuilder<List<SearchInfo>>(
        stream: streamSuggestion.stream,
        key: streamKey,
        builder: (ctx, snap){
          if(snap.hasData){
            return ListView.builder(
              itemExtent: 50.0,
              itemBuilder: (ctx, index){
                return ListTile(
                  title: Text(
                    snap.data![index].address.toString(),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                  onTap: () async{
                    /// go to location selected by address
                    controller.goToLocation(
                      snap.data![index].point!,
                    );

                    /// hide suggestion card
                    notifierAutoCompletion.value = false;
                    await reInitStream();
                    FocusScope.of(context).requestFocus(new FocusNode(),);
                  },
                );
              },
              itemCount: snap.data!.length,
            );
          }
          if(snap.connectionState == ConnectionState.waiting){
            return Card(child: Center(child: const CircularProgressIndicator(),),);
          }
          return const SizedBox();
        },
      ),
    );
  }
}