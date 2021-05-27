import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularErrorMessageTemplate extends StatelessWidget{

  const MiscRegularErrorMessageTemplate();

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

            Text('Error', textAlign: TextAlign.center,style: TextStyle(
                fontSize:
                SizeConfig.blockSizeVertical! * 3.16,
                fontFamily: 'NexaRegular'),),
            
            const SizedBox(height: 30,),

            Text('Something went wrong. Please try again.', textAlign: TextAlign.center,  style: TextStyle(
                fontSize:
                SizeConfig.blockSizeVertical! * 2.87,
                fontFamily: 'NexaRegular'),),

            const SizedBox(height: 30,),

            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () async{
                Navigator.pop(context);
              },
              child: Text('Go back',
                style: TextStyle(
                  fontSize:
                  SizeConfig.blockSizeVertical! * 3.16,
                    fontFamily: 'NexaRegular',
                  color: const Color(0xffffffff),
                ),
              ),
              minWidth: SizeConfig.screenWidth! / 2,
              height: 45,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: const Color(0xff888888),
            ),

            const SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}

class MiscRegularLoginToContinue extends StatelessWidget{

  const MiscRegularLoginToContinue();

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

            const Text('FacesbyPlaces', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            
            const SizedBox(height: 30,),

            const Text('Sign in or sign up to get the most out of the FacesbyPlaces app; list of memorials nearby, posts and much more.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16),),

            const SizedBox(height: 100,),

            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/login', ModalRoute.withName('/login'));
              },
              child: const Text('Sign in or sign up to continue', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff4EC9D4)),),
            ),

            const SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}