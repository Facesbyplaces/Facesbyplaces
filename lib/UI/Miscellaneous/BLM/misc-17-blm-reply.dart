import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMShowReply extends StatelessWidget{

  final String image;
  final String firstName;
  final String lastName;
  final String commentBody;
  final String createdAt;
  final int numberOfLikes;

  MiscBLMShowReply({this.image, this.firstName, this.lastName, this.commentBody, this.createdAt, this.numberOfLikes});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Column(
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 5,
          child: Row(
            children: [
              SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

              CircleAvatar(
                backgroundImage: image != null ? NetworkImage(image) : AssetImage('assets/icons/app-icon.png'),
                backgroundColor: Color(0xff888888),
              ),

              SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

              Expanded(
                child: Text(firstName + ' ' + lastName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

              SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

              Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

            ],
          ),
        ),

        Row(
          children: [
            SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  commentBody,
                  style: TextStyle(
                    color: Color(0xffffffff),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff4EC9D4),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: SizeConfig.blockSizeVertical * 1,),

        Row(
          children: [

            SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

            Text(convertDate(createdAt)),

            SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

            GestureDetector(
              onTap: (){
                
              },
              child: Text('Reply',),
            ),

          ],
        ),

        SizedBox(height: SizeConfig.blockSizeVertical * 1,),

      ],
    );
  }
}

