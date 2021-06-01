import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestPage extends StatefulWidget {
  final String title;
  TestPage({required this.title});

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  var _controller = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String apiKey = "AIzaSyDdGbn-l8EjoPZOqQoedcCzkTa-ubuL9Do";
    // String type = '(regions)';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$apiKey&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    print('The response is ${response.statusCode}');
    print('The response is ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Seek your location here",
                  focusColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.map),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: (){

                    },
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placeList[index]["description"]),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}