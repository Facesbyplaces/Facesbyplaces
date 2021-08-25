import '../../../Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularUploadFromDialog extends StatelessWidget{
  final String choice_1;
  final String choice_2;
  const MiscRegularUploadFromDialog({this.choice_1 = 'Camera', this.choice_2 = 'Gallery'});

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
            Text('Choose file to Upload:', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaLight', color: const Color(0xff000000),),),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text(choice_1, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffC1C1C1),),),
              onTap: (){
                Navigator.pop(context, 1);
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text(choice_2, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffC1C1C1),),),
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

class MiscRegularRelationshipFromDialog extends StatelessWidget{
  const MiscRegularRelationshipFromDialog();

  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose the relationship of this person:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Father', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Father');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Mother', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Mother');
              },
            ),

            SizedBox(height: 40,),

            GestureDetector(
              child: Text('Sister', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Sister');
              },
            ),

            SizedBox(height: 40,),

            GestureDetector(
              child: Text('Brother', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Brother');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Aunt', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Aunt');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Uncle', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Uncle');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Nephew', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Nephew');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Grandfather', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Grandfather');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Grandmother', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
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

class MiscRegularConfirmDialog extends StatelessWidget{
  final String title;
  final String content;
  final String confirm_1;
  final String confirm_2;
  final Color confirmColor_1;
  final Color confirmColor_2;
  const MiscRegularConfirmDialog({
    this.title = 'Confirm Delete',
    this.content = 'Are you sure you want to delete "Mark Jacksons Memorial"?',
    this.confirm_1 = 'Yes',
    this.confirm_2 = 'No',
    this.confirmColor_1 = const Color(0xffFF0000),
    this.confirmColor_2 = const Color(0xff04ECFF),
  });

  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10),),),
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),

            const SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 11.0, right: SizeConfig.blockSizeHorizontal! * 11.0),
              child: Text(content, textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
            ),

            const SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Text(confirm_1, textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: confirmColor_1,),),
                    onTap: (){
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Text(confirm_2, textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: confirmColor_2,),),
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