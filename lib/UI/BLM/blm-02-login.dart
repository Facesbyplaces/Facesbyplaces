import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BLMLogin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icons/background2.png'),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    alignment: Alignment.centerLeft,
                    child: Text('Login', 
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000)
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: (){},
                            minWidth: SizeConfig.screenWidth / 1.5,
                            height: SizeConfig.blockSizeVertical * 8,
                            shape: StadiumBorder(),
                            color: Color(0xff3A559F),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: SizeConfig.blockSizeVertical * 5,
                                    child: Image.asset('assets/icons/facebook.png'),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text('Facebook',
                                      style: TextStyle(
                                        color: Color(0xffffffff)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 10,),

                        Expanded(
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: (){},
                            minWidth: SizeConfig.screenWidth / 1.5,
                            height: SizeConfig.blockSizeVertical * 8,
                            shape: StadiumBorder(),
                            color: Color(0xffF5F5F5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    height: SizeConfig.blockSizeVertical * 5,
                                    child: Image.asset('assets/icons/google.png'),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10,),
                                    child: Text('Google',
                                      style: TextStyle(
                                        color: Color(0xff000000)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Center(
                    child: Text('or log in with email', 
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000)
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      cursorColor: Color(0xff000000),
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      obscureText: true,
                      cursorColor: Color(0xff000000),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){},
                    child: Text('Login',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff),
                      ),
                    ),
                    minWidth: SizeConfig.screenWidth / 2,
                    height: SizeConfig.blockSizeVertical * 8,
                    shape: StadiumBorder(),
                    color: Color(0xff4EC9D4),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Don\'t have an Account? ', 
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            color: Color(0xff000000),
                          ),
                        ),

                        TextSpan(
                          text: 'Sign Up', 
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff85DBF1),
                          ),
                          recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.pushNamed(context, 'blm/blm-03-register');
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}