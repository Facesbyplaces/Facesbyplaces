import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeNotificationsTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [

        Container(
          height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 13),
          color: Color(0xffffffff),
          child: Column(
            children: [
              Container(
                color: Color(0xffffffff),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Jason Enriquez ',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'liked your posts\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: '30 mins ago',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                              TextSpan(
                                text: '\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: .5))
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),

              Container(
                color: Color(0xffffffff),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Joan Oliver ',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'commented on your post\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'an hour ago\n\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                              TextSpan(
                                text: 'What a heartwarming story 😇. Hope we can read more of your journey together.\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: .5))
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),

              Container(
                color: Color(0xffffffff),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Mike Perez ',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'likes your comment on\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'In Memory of John Doe ',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'post\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'an hour ago\n\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                              TextSpan(
                                text: 'My condolences to your family😭\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: .5))
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),

              Container(
                color: Color(0xffffffff),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Steve Wilson ',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'made you a manager of\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'Mark Jacksons Memorial Page\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: '30 mins ago\n\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: .5))
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),

              Container(
                color: Color(0xffffffff),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Steve Wilson ',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'remove you as a manager of ',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: 'Mark Jacksons Memorial Page\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              TextSpan(
                                text: '30 mins ago\n\n',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: .5))
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

