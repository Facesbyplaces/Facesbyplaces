import 'package:flutter/material.dart';

class HomeRegularUserPrivacySettings extends StatefulWidget{
  const HomeRegularUserPrivacySettings({Key? key}) : super(key: key);

  @override
  HomeRegularUserPrivacySettingsState createState() => HomeRegularUserPrivacySettingsState();
}

class HomeRegularUserPrivacySettingsState extends State<HomeRegularUserPrivacySettings>{

  @override
  Widget build(BuildContext context){
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
            backgroundColor: const Color(0xff04ECFF),
            centerTitle: false,
            title: const Text('Privacy Settings', textAlign: TextAlign.left, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff)),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraint){
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0xffffffff), image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/icons/background2.png', ), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                      child: SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(height: 50,),
                            
                            SizedBox(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),

                            const SizedBox(height: 30),

                            const Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: 28, color: Color(0xff04ECFF), fontFamily: 'NexaBold',),),),

                            const SizedBox(height: 50),

                            const Center(child: Text('Changes are being made on the Privacy Settings.', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff000000),),),),

                            const SizedBox(height: 50),

                            const Expanded(child: SizedBox()),

                            const SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}