import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularSearch extends StatelessWidget{

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
              onFieldSubmitted: (String value){
                Navigator.pushNamed(context, '/home/regular/home-06-regular-post');
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                filled: true,
                fillColor: Color(0xffffffff),
                focusColor: Color(0xffffffff),
                hintText: 'Search a Post',
                hintStyle: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
            ),
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              height: SizeConfig.screenHeight,
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 25,),

                  GestureDetector(onTap: (){}, child: Center(child: CircleAvatar(maxRadius: SizeConfig.blockSizeVertical * 10, backgroundColor: Color(0xffEFFEFF), child: Icon(Icons.search, color: Color(0xff4EC9D4), size: SizeConfig.blockSizeVertical * 15),),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Text('Enter a memorial page name to start searching', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}