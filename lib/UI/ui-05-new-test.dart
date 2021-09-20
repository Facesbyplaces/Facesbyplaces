// ignore_for_file: file_names
import 'package:flutter/material.dart';

class NewTest extends StatefulWidget{

  NewTestState createState() => NewTestState();
}

class NewTestState extends State<NewTest>{

  List<String> items = [
    'Home Help',
    'Carpentry/Wodowork',
    'Mechanic/Car Help',
    'Electrical',
    'Plumbing',
    'Computer/Electronics',
    'Lawn/Garden',
    'Childcare/Family',
    'Packing and Moving',
    'Extra Pair of Hands',
    'Web Design and Tech',
    'Artistic or Creative',
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Wrap(
            spacing: 5.0,
            children: List.generate(
              items.length,
              (index) => TextButton.icon(
                onPressed: (){}, 
                icon: Icon(Icons.person), 
                label: Text(items[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}