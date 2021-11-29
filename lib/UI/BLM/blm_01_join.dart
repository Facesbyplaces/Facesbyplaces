import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:misc/misc.dart';

class BLMJoin extends StatelessWidget{
  const BLMJoin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xff000000), size: 35,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        const SizedBox(height: 50,),
                        
                        SizedBox(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),

                        const SizedBox(height: 30),

                        const Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: 28, color: Color(0xff04ECFF), fontFamily: 'NexaBold',),),),

                        const SizedBox(height: 50),

                        const Center(child: Text('Changes are being made on this section. To create and join a memorial, click the button below.', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff000000),),),),

                        const SizedBox(height: 50),

                        const Expanded(child: SizedBox()),

                        MiscButtonTemplate(
                          buttonText: 'Join',
                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                          width: SizeConfig.screenWidth! / 1.8,
                          height: 50,
                          buttonColor: const Color(0xff4EC9D4),
                          onPressed: (){
                            // Navigator.pushNamed(context, '/regular/login');
                            Navigator.pushReplacementNamed(context, '/home/regular');
                          },
                        ),

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
    );
  }
}