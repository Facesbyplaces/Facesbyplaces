import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:flutter/material.dart';

class RegularJoin extends StatelessWidget {
  const RegularJoin();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        body: Stack(
          children: [

            const MiscRegularBackgroundTemplate(),

            Positioned(
              top: 50,
              left: 30,
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  icon: const Icon(
                    Icons.arrow_back, 
                    color: const Color(0xff000000), 
                    size: 30,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 30),

                  Container(child: Image.asset('assets/icons/logo.png', height: 150, width: 150,),),

                  const SizedBox(height: 150),
                  
                  const Center(child: const Text('All Lives Matter', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),),

                  const SizedBox(height: 20),

                  MiscRegularButtonTemplate(
                    buttonText: 'Next', 
                    buttonTextStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold, 
                      color: const Color(0xffffffff),
                    ), 
                    onPressed: (){
                      Navigator.pushNamed(context, '/regular/login');
                    }, 
                    width: 150,
                    height: 45,
                    buttonColor: const Color(0xff04ECFF),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}