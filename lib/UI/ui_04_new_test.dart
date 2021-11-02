

import 'package:flutter/material.dart';
import 'dart:async';

class Foo extends StatefulWidget {
  @override
  _FooState createState() => _FooState();
}

class _FooState extends State<Foo> {
  StreamController<String> streamController = StreamController<String>();

  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    streamController.add("Loading");
    await Future.delayed(Duration(seconds: 1));
    streamController.add("Done");
  }

  // @override
  // void didUpdateWidget(Foo oldWidget) {
  //   if (oldWidget != widget) {
  //     load();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
    void dispose() {
      streamController.close();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Text(snapshot.data!);
        } else if (snapshot.hasError) {
          return new Text("Error");
        } else {
          return new Text("Nothing");
        }
      },
    );
  }
}