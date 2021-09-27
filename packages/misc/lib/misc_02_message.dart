part of misc;

class MiscLoginToContinue extends StatelessWidget{
  const MiscLoginToContinue({Key? key}) : super(key: key);

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

            const Text('FacesbyPlaces', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'NexaBold', fontSize: 32),),
            
            const SizedBox(height: 30,),

            const Text('Sign in or sign up to get the most out of the FacesbyPlaces app; list of memorials nearby, posts and much more.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'NexaRegular', fontSize: 24,),),

            const SizedBox(height: 100,),

            GestureDetector(
              child: const Text('Sign in or sign up to continue', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'NexaBold', fontSize: 24, color: Color(0xff4EC9D4)),),
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

class MiscErrorMessageTemplate extends StatelessWidget{
  const MiscErrorMessageTemplate({Key? key}) : super(key: key);

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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: const Color(0xff888888),
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