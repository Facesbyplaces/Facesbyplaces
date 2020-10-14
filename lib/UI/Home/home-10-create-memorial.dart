import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCreateMemorial extends StatelessWidget{

  static final GlobalKey<MiscInputFieldCreateMemorialState> _key1 = GlobalKey<MiscInputFieldCreateMemorialState>();
  static final GlobalKey<MiscInputFieldCreateMemorialState> _key2 = GlobalKey<MiscInputFieldCreateMemorialState>();
  static final GlobalKey<MiscInputFieldCreateMemorialState> _key3 = GlobalKey<MiscInputFieldCreateMemorialState>();
  static final GlobalKey<MiscInputFieldCreateMemorialState> _key4 = GlobalKey<MiscInputFieldCreateMemorialState>();
  static final GlobalKey<MiscInputFieldCreateMemorialState> _key5 = GlobalKey<MiscInputFieldCreateMemorialState>();
  static final GlobalKey<MiscInputFieldCreateMemorialState> _key6 = GlobalKey<MiscInputFieldCreateMemorialState>();
  static final GlobalKey<MiscInputFieldCreateMemorialState> _key7 = GlobalKey<MiscInputFieldCreateMemorialState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [
        Container(),

        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              MiscInputFieldCreateMemorial(key: _key1, hintText: 'Relationship', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscInputFieldCreateMemorial(key: _key2, hintText: 'Location of the incident', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscInputFieldCreateMemorial(key: _key3, hintText: 'Precinct / Station House (Optional)', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscInputFieldCreateMemorial(key: _key4, hintText: 'DOB', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscInputFieldCreateMemorial(key: _key5, hintText: 'RIP', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscInputFieldCreateMemorial(key: _key6, hintText: 'Country', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MiscInputFieldCreateMemorial(key: _key7, hintText: 'State', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  context.bloc<BlocHomeUpdateCubit>().modify(5);
                },
                child: Text('Next',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.w300,
                    color: Color(0xffffffff),
                  ),
                ),
                minWidth: SizeConfig.screenWidth / 2,
                height: SizeConfig.blockSizeVertical * 7,
                shape: StadiumBorder(),
                color: Color(0xff2F353D),
              ),

            ],
          ),
        ),
      ],
    );
  }
}

class HomeCreateMemorial2 extends StatelessWidget{

  static final GlobalKey<MiscInputFieldCreateMemorialState> _key1 = GlobalKey<MiscInputFieldCreateMemorialState>();
  static final TextEditingController _controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [
        Container(),

        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              MiscInputFieldCreateMemorial(key: _key1, hintText: 'Name of your Memorial Page', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Text('Share your Story',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff000000),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              TextFormField(
                controller: _controller1,
                cursorColor: Color(0xff000000),
                maxLines: 10,
                decoration: InputDecoration(
                  fillColor: Color(0xffffffff),
                  filled: true,
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000).withOpacity(.5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff000000),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff000000),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Text('Describe the events that happened to your love one.',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff000000),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 10,),

              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  context.bloc<BlocHomeUpdateCubit>().modify(6);
                },
                child: Text('Next',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.w300,
                    color: Color(0xffffffff),
                  ),
                ),
                minWidth: SizeConfig.screenWidth / 2,
                height: SizeConfig.blockSizeVertical * 7,
                shape: StadiumBorder(),
                color: Color(0xff2F353D),
              ),

            ],
          ),
        ),
      ],
    );
  }
}

class HomeCreateMemorial3 extends StatelessWidget{

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [
        Container(),

        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: ListView(
            shrinkWrap: true,
            children: [

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Text('Upload or Select an Image',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Container(
                height: SizeConfig.blockSizeVertical * 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/icons/upload_background.png'),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 7,
                        backgroundColor: Color(0xffffffff),
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 13,
                          child: Image.asset('assets/icons/profile1.png'),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: SizeConfig.blockSizeVertical * 5,
                      left: SizeConfig.screenWidth / 2,
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 3,
                        backgroundColor: Color(0xffffffff),
                        child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5,),
                      ),
                    ),

                    Positioned(
                      top: SizeConfig.blockSizeVertical * 1,
                      right: SizeConfig.blockSizeVertical * 1,
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 3,
                        backgroundColor: Color(0xffffffff),
                        child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5,),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Text('Upload the best photo of the person in the memorial page.',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff000000),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Text('Choose Background',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Container(
                height: SizeConfig.blockSizeVertical * 12,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return Container(
                      width: SizeConfig.blockSizeVertical * 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(images[index]),
                        ),
                      ),
                    );
                  }, 
                  separatorBuilder: (context, index){
                    return SizedBox(width: SizeConfig.blockSizeHorizontal * 5,);
                  },
                  itemCount: 4,
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Text('Upload your own or select from the pre-mades.',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                  fontWeight: FontWeight.w300,
                  color: Color(0xff000000),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 10,),

              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  context.bloc<BlocHomeUpdateCubit>().modify(7);
                },
                child: Text('Speak Out',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.w300,
                    color: Color(0xffffffff),
                  ),
                ),
                minWidth: SizeConfig.screenWidth / 2,
                height: SizeConfig.blockSizeVertical * 7,
                shape: StadiumBorder(),
                color: Color(0xff2F353D),
              ),

            ],
          ),
        ),
      ],
    );
  }
}