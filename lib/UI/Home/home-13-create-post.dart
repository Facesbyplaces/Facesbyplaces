import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeCreatePost extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          
          child: Row(
            children: [
              Expanded(
                child: CircleAvatar(
                  radius: SizeConfig.blockSizeVertical * 3,
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 17,
                    child: Image.asset('assets/icons/profile1.png', fit: BoxFit.cover,),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text('Richard Nedd Memories',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xff000000),),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: Color(0xff000000),
                offset: Offset(0, 0),
                blurRadius: 5.0
              ),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.blockSizeVertical * 1,),

        Container(
          child: TextFormField(
            maxLines: 10,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffffffff),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffffffff)),
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffffffff)),
              ),
              focusedBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffffffff)),
              ),
            ),
          ),
        ),

        Container(
          height: SizeConfig.blockSizeVertical * 25,
          child: Image.asset('assets/icons/upload_background.png', fit: BoxFit.cover),
        ),

        Container(
          height: SizeConfig.blockSizeVertical * 20,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  color: Color(0xffffffff),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Add a location'),
                      ),
                      Expanded(
                        child: Icon(Icons.place, color: Color(0xff4EC9D4),)
                      ),
                    ],
                  ),
                ),
              ),

              Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  color: Color(0xffffffff),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Tag a person you are with'),
                      ),
                      Expanded(
                        child: Icon(Icons.person, color: Color(0xff4EC9D4),)
                      ),
                    ],
                  ),
                ),
              ),

              Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  color: Color(0xffffffff),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Upload a Video / Image'),
                      ),
                      Expanded(
                        child: Icon(Icons.image, color: Color(0xff4EC9D4),)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}