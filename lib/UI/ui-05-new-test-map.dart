import 'dart:async';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class TestMap extends StatefulWidget {
  
  @override
  TestMapState createState() => TestMapState();
}

class TestMapState extends State<TestMap> {
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
  Widget build(BuildContext context) {
    return CustomPickerLocation(
      controller: controller,
      appBarPicker: AppBar(
        title: TextField(
          controller: textEditingController,
          onEditingComplete: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            suffix: ValueListenableBuilder<TextEditingValue>(
              valueListenable: textEditingController,
              builder: (ctx, text, child) {
                if (text.text.isNotEmpty) {
                  return child!;
                }
                return SizedBox.shrink();
              },
              child: InkWell(
                focusNode: FocusNode(),
                onTap: () {
                  textEditingController.clear();
                  controller.setSearchableText("");
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.black,
                ),
              ),
            ),
            focusColor: Colors.black,
            filled: true,
            hintText: "search",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            fillColor: Colors.grey[300],
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
      // topWidgetPicker: TopSearchWidget(),
      topWidgetPicker: TopWidgetPicker(),
      bottomWidgetPicker: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () async {
            // GeoPoint p = await controller.selectAdvancedPositionPicker();

            GeoPoint p = await controller.getCurrentPositionAdvancedPositionPicker();
            print('The geopoint latitude is ${p.latitude}');
            print('The geopoint longitude is ${p.longitude}');
            List<Placemark> placemarks = await placemarkFromCoordinates(p.latitude, p.longitude);

            print('The location is ${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea} ${placemarks[0].postalCode}, ${placemarks[0].country}');

            print('The placemark administrativeArea is ${placemarks[0].administrativeArea}');
            print('The placemark country is ${placemarks[0].country}');
            // print('The placemark isoCountryCode is ${placemarks[0].isoCountryCode}');
            print('The placemark locality is ${placemarks[0].locality}');
            print('The placemark name is ${placemarks[0].name}');
            print('The placemark postalCode is ${placemarks[0].postalCode}');
            print('The placemark street is ${placemarks[0].street}');
            // print('The placemark subAdministrativeArea is ${placemarks[0].subAdministrativeArea}');
            // print('The placemark subLocality is ${placemarks[0].subLocality}');
            // print('The placemark subThoroughfare is ${placemarks[0].subThoroughfare}');
            // print('The placemark thoroughfare is ${placemarks[0].thoroughfare}');
            Navigator.pop(context, p);
          },
          child: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}


class TopWidgetPicker extends StatefulWidget {
  @override
  
  TopWidgetPickerState createState() => TopWidgetPickerState();
}

class TopWidgetPickerState extends State<TopWidgetPicker> {
  late PickerMapController controller;
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = Key("streamAddressSug");

  @override
  void initState() {
    super.initState();
    controller = CustomPickerLocation.of(context);
    controller.searchableText.addListener(onSearchableTextChanged);
  }

  void onSearchableTextChanged() async {
    final v = controller.searchableText.value;
    if (v.length > 3 && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(Duration(seconds: 3), (timer) async {
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(
      addr,
      limitInformation: 5,
    );
    _futureSuggestionAddress.then((value) {
      streamSuggestion.sink.add(value);
    });
  }

  @override
  void dispose() {
    controller.searchableText.removeListener(onSearchableTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifierAutoCompletion,
      builder: (ctx, isVisible, child) {
        return AnimatedContainer(
          duration: Duration(
            milliseconds: 500,
          ),
          height: isVisible ? MediaQuery.of(context).size.height / 4 : 0,
          child: Card(
            child: child!,
          ),
        );
      },
      child: StreamBuilder<List<SearchInfo>>(
        stream: streamSuggestion.stream,
        key: streamKey,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemExtent: 50.0,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    snap.data![index].address.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  onTap: () async {
                    /// go to location selected by address
                    controller.goToLocation(
                      snap.data![index].point!,
                    );

                    /// hide suggestion card
                    notifierAutoCompletion.value = false;
                    await reInitStream();
                    FocusScope.of(context).requestFocus(
                      new FocusNode(),
                    );
                  },
                );
              },
              itemCount: snap.data!.length,
            );
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return Card(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}