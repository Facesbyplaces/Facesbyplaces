part of misc;

class MiscUploadFromDialog extends StatelessWidget{
  final String choice_1;
  final String choice_2;
  const MiscUploadFromDialog({Key? key, this.choice_1 = 'Camera', this.choice_2 = 'Gallery'}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose file to Upload:', style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xff000000),),),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text(choice_1, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffC1C1C1),),),
              onTap: (){
                Navigator.pop(context, 1);
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text(choice_2, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffC1C1C1),),),
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

class MiscRelationshipFromDialog extends StatelessWidget{
  const MiscRelationshipFromDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose the relationship of this person:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff000000),),
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Father', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Father');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Mother', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Mother');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Sister', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Sister');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Brother', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Brother');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Son', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Son');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Daughter', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Daughter');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Aunt', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Aunt');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Uncle', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Uncle');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Nephew', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Nephew');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Grandfather', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
              onTap: (){
                Navigator.pop(context, 'Grandfather');
              },
            ),

            const SizedBox(height: 40,),

            GestureDetector(
              child: Text('Grandmother', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000).withOpacity(0.5),),),
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

class MiscConfirmDialog extends StatelessWidget{
  final String title;
  final String content;
  final String confirm_1;
  final String confirm_2;
  final Color confirmColor_1;
  final Color confirmColor_2;
  const MiscConfirmDialog({
    Key? key,
    this.title = 'Confirm Delete',
    this.content = 'Are you sure you want to delete "Mark Jacksons Memorial"?',
    this.confirm_1 = 'Yes',
    this.confirm_2 = 'No',
    this.confirmColor_1 = const Color(0xffFF0000),
    this.confirmColor_2 = const Color(0xff04ECFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff000000),),),

            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
            ),

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
                    child: Text(confirm_2, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: confirmColor_2,),),
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