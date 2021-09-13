import '../../../Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMUploadFromDialog extends StatelessWidget{
  final String choice_1;
  final String choice_2;
  const MiscBLMUploadFromDialog({this.choice_1 = 'Camera', this.choice_2 = 'Gallery'});

  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose file to Upload:', style: const TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: const Color(0xff000000),),),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text(choice_1, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xffC1C1C1),),),
              onTap: (){
                Navigator.pop(context, 1);
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text(choice_2, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xffC1C1C1),),),
              onTap: (){
                Navigator.pop(context, 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MiscBLMRelationshipFromDialog extends StatelessWidget{
  const MiscBLMRelationshipFromDialog();

  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose the relationship of this person:', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Father', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Father');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Mother', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Mother');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Sister', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Sister');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Brother', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Brother');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Aunt', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Aunt');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Uncle', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Uncle');
              },
            ),

            SizedBox(height: 40,),

            GestureDetector(
              child: Text('Nephew', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Nephew');
              },
            ),

            SizedBox(height: 40,),

            GestureDetector(
              child: Text('Grandfather', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Grandfather');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Grandmother', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Grandmother');
              },
            ),

            const SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}

class MiscBLMConfirmDialog extends StatelessWidget{
  final String title;
  final String content;
  final String confirm_1;
  final String confirm_2;
  final Color confirmColor_1;
  final Color confirmColor_2;
  const MiscBLMConfirmDialog({
    this.title = 'Confirm Delete',
    this.content = 'Are you sure you want to delete "Mark Jacksons Memorial"?',
    this.confirm_1 = 'Yes',
    this.confirm_2 = 'No',
    this.confirmColor_1 = const Color(0xffFF0000),
    this.confirmColor_2 = const Color(0xff04ECFF),
  });

  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000),),),

            const SizedBox(height: 20,),

            Text(content, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

            const SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Text(confirm_1, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: confirmColor_1,),),
                    onTap: (){
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Text(confirm_2, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: confirmColor_2,)),
                    onTap: (){
                      Navigator.pop(context, false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}