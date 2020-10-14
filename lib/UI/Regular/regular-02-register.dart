import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegularRegister extends StatelessWidget{

  static final GlobalKey<MiscInputFieldState> _key1 = GlobalKey<MiscInputFieldState>();
  static final GlobalKey<MiscInputFieldState> _key2 = GlobalKey<MiscInputFieldState>();
  static final GlobalKey<MiscInputFieldState> _key3 = GlobalKey<MiscInputFieldState>();
  static final GlobalKey<MiscInputFieldState> _key4 = GlobalKey<MiscInputFieldState>();
  static final GlobalKey<MiscInputFieldState> _key5 = GlobalKey<MiscInputFieldState>();
  static final GlobalKey<MiscInputFieldState> _key6 = GlobalKey<MiscInputFieldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SingleChildScrollView(
      child: Stack(
        children: [

          Container(
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icons/background2.png'),
                colorFilter: ColorFilter.srgbToLinearGamma(),
              ),
            ),
          ),


          Container(
            height: SizeConfig.screenHeight / 6,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icons/regular-background.png'),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: (){
                      context.bloc<UpdateCubitRegular>().modify(0);
                    },
                    icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5),
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                MiscInputField(key: _key1, hintText: 'Your Name', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),
                
                SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                
                MiscInputField(key: _key2, hintText: 'Last Name', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputField(key: _key3, hintText: 'Mobile #', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputField(key: _key4, hintText: 'Email Address', obscureText: false, type: TextInputType.emailAddress, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputField(key: _key5, hintText: 'Username', obscureText: false, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: false,),

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                MiscInputField(key: _key6, hintText: 'Password', obscureText: true, type: TextInputType.text, maxLines: 1, readOnly: false, includeSuffixIcon: true,),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                
                MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    if(_key1.currentState.controller.text != '' && _key2.currentState.controller.text != '' && _key3.currentState.controller.text != '' &&
                      _key4.currentState.controller.text != '' && _key5.currentState.controller.text != '' && _key6.currentState.controller.text != ''
                    ){
                      context.bloc<BlocUpdateCubitBLM>().modify(3);
                    }
                  },
                  child: Text('Next',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                  minWidth: SizeConfig.screenWidth / 2,
                  height: SizeConfig.blockSizeVertical * 7,
                  shape: StadiumBorder(),
                  color: Color(0xff4EC9D4),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Already have an account? ', 
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          color: Color(0xff000000),
                        ),
                      ),

                      TextSpan(
                        text: 'Login', 
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          color: Color(0xff04ECFF),
                        ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = (){
                          
                        }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),        
        ],
      ),
    );
  }
}