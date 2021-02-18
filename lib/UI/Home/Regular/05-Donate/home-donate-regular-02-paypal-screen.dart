import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularPaypal extends StatefulWidget{

  HomeRegularPaypalState createState() => HomeRegularPaypalState();
}

class HomeRegularPaypalState extends State<HomeRegularPaypal>{

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

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
            backgroundColor: Color(0xffECF0F1),
            title: Text('Paypal', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/paypal.png'),
                    ),
                  ),
                ),

                Text('Log in with Paypal', style: TextStyle(fontSize: 16, color: Color(0xff000000)),),

                SizedBox(height: 40),

                TextFormField(
                  controller: controller1,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color(0xff000000),
                  decoration: InputDecoration(
                    fillColor: Color(0xffffffff),
                    filled: true,
                    alignLabelWithHint: true,
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 16, color: Color(0xff888888)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                TextFormField(
                  controller: controller2,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  cursorColor: Color(0xff000000),
                  decoration: InputDecoration(
                    fillColor: Color(0xffffffff),
                    filled: true,
                    alignLabelWithHint: true,
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 16, color: Color(0xff888888)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){},
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, 
                      color: Color(0xffffffff),
                    ), 
                  ),
                  minWidth: SizeConfig.screenWidth,
                  height: 70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  color: Color(0xff0070BA),
                ),

                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

