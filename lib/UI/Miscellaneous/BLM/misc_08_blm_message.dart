import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMErrorMessageTemplate extends StatelessWidget{
  const MiscBLMErrorMessageTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 30,),

            Image.asset('assets/icons/app-icon.png', width: 300, height: 300,),

            const SizedBox(height: 100,),

            const Text('Error', textAlign: TextAlign.center,style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
            
            const SizedBox(height: 30,),

            const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontFamily: 'NexaRegular'),),

            const SizedBox(height: 30,),

            MaterialButton(
              child: const Text('Go back', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
              minWidth: SizeConfig.screenWidth! / 2,
              color: const Color(0xff888888),
              padding: EdgeInsets.zero,
              height: 50,
              onPressed: () async{
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}

class MiscBLMLoginToContinue extends StatelessWidget{
  const MiscBLMLoginToContinue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 30,),

            Image.asset('assets/icons/app-icon.png', width: 300, height: 300,),

            const SizedBox(height: 30,),

            const Text('FacesbyPlaces', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            
            const SizedBox(height: 30,),

            const Text('Sign in or sign up to get the most out of the FacesbyPlaces app; list of memorials nearby, posts and much more.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),

            const SizedBox(height: 100,),

            GestureDetector(
              child: const Text('Sign in or sign up to continue', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff4EC9D4)),),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/login', ModalRoute.withName('/login'));
              },
            ),

            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}