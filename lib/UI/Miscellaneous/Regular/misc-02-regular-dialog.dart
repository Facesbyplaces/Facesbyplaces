
import 'package:flutter/material.dart';

import '../../../Configurations/size_configuration.dart';

class MiscRegularUploadFromDialog extends StatelessWidget{

  final String choice_1;
  final String choice_2;

  const MiscRegularUploadFromDialog({this.choice_1 = 'Camera', this.choice_2 = 'Gallery'});

  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose file to Upload:',
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaLight',
                color: Color(0xff000000),),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 1);
              },
              child: Text(choice_1,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xffC1C1C1),),
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 2);
              },
              child: Text(choice_2,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xffC1C1C1),),
              ),
            ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 2.64,
                fontFamily: 'NexaBold',
                color: Color(0xff000000),),
            ),

            const SizedBox(height: 20,),

           Padding(
             padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 11.0, right: SizeConfig.blockSizeHorizontal! * 11.0),
             child:  Text(content,
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: SizeConfig.blockSizeVertical! * 2.11,
                 fontFamily: 'NexaRegular',
                 color: Color(0xff000000),),
             ),
           ),

            const SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context, true);
                    },
                    child: Text(confirm_1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.64,
                        fontFamily: 'NexaBold',
                        color: confirmColor_1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context, false);
                    },
                    child: Text(confirm_2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.64,
                        fontFamily: 'NexaBold',
                        color: confirmColor_2,
                      ),
                    ),
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

class MiscRegularRelationshipFromDialog extends StatelessWidget{

  const MiscRegularRelationshipFromDialog();

  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose the relationship of this person:',
            textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.blockSizeVertical! * 2.64,
                fontFamily: 'NexaBold',
                color: Color(0xff000000),),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Father');
              },
              child: Text('Father',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Mother');
              },
              child: Text('Mother',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Sister');
              },
              child: Text('Sister',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Brother');
              },
              child: Text('Brother',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Aunt');
              },
              child: Text('Aunt',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Uncle');
              },
              child: Text('Uncle',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Nephew');
              },
              child: Text('Nephew',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Grandfather');
              },
              child: Text('Grandfather',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Grandmother');
              },
              child: Text('Grandmother',
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaRegular',
                  color: Color(0xff000000).withOpacity(0.5),),
              ),
            ),

            const SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}