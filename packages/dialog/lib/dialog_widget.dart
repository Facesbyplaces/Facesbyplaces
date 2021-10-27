part of dialog;

class CustomDialog extends StatefulWidget{
  final Widget image;
  final AnimationEntry animationEntry;
  final double cornerRadius;
  final double buttonRadius;
  final String title;
  final String description;
  final bool includeOkButton;
  final bool includeCancelButton;
  final VoidCallback? okButton;
  final VoidCallback? cancelButton;
  final Color okButtonColor;
  final Color cancelButtonColor;
  final Text okButtonText;
  final Text cancelButtonText;
  const CustomDialog({Key? key, required this.image, this.animationEntry = AnimationEntry.standard, this.cornerRadius = 5.0, this.buttonRadius = 5.0, required this.title, required this.description, this.includeOkButton = false, this.includeCancelButton = false, this.okButton, this.cancelButton, this.okButtonColor = const Color(0xff4caf50), this.cancelButtonColor = const Color(0xfff44336), this.okButtonText = const Text('OK', style: TextStyle(color: Color(0xffffffff))), this.cancelButtonText = const Text('CANCEL', style: TextStyle(color: Color(0xffffffff))),}) : super(key: key);

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> with TickerProviderStateMixin{
  AnimationController? animationController;
  Animation<Offset>? animationOffsetEntry;

  get entryAnimation{
    switch(widget.animationEntry){
      case AnimationEntry.standard: 
        break;
      case AnimationEntry.top: 
        return const Offset(0.0, -1.0);
      case AnimationEntry.topLeft: 
        return const Offset(-1.0, -1.0);
      case AnimationEntry.topRight:
        return const Offset(1.0, -1.0);
      case AnimationEntry.left:
        return const Offset(-1.0, 0.0);
      case AnimationEntry.right:
        return const Offset(1.0, 0.0);
      case AnimationEntry.bottom:
        return const Offset(0.0, 1.0);
      case AnimationEntry.bottomLeft:
        return const Offset(-1.0, 1.0);
      case AnimationEntry.bottomRight:
        return const Offset(1.0, 1.0);
    }
  }

  get isStandardAnimationEntry => widget.animationEntry == AnimationEntry.standard;

  @override
  void initState(){
    super.initState();
    if(!isStandardAnimationEntry){
      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300),);
      animationOffsetEntry = Tween<Offset>(begin: entryAnimation, end: const Offset(0.0, 0.0)).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeIn,),
      )..addListener(() => setState(() {}));
      animationController!.forward();
    }
  }

  @override
  void dispose(){
    animationController?.dispose();
    super.dispose();
  }

  Widget portraitDialog(BuildContext context, Widget imageWidget){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(widget.cornerRadius), topLeft: Radius.circular(widget.cornerRadius)),
            child: imageWidget
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                  ),
                ),
              ),

              buttonsBar(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget landscapeDialog(BuildContext context, Widget imageWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(widget.cornerRadius), bottomLeft: Radius.circular(widget.cornerRadius)),
            child: imageWidget,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(widget.description, overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
              ),

              buttonsBar(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buttonsBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: widget.includeOkButton && widget.includeCancelButton ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
        children: [
          if(widget.includeOkButton)...[
            MaterialButton(
              color: widget.okButtonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.buttonRadius)),
              child: widget.okButtonText,
              onPressed: widget.okButton ?? () => Navigator.of(context).pop(true),
            ),
          ],

          if(widget.includeCancelButton)...[
            MaterialButton(
              color: widget.cancelButtonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.buttonRadius)),
              child: widget.cancelButtonText,
              onPressed: widget.cancelButton ?? () => Navigator.of(context).pop(false),
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final width = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(transform: !isStandardAnimationEntry ? Matrix4.translationValues(animationOffsetEntry!.value.dx * width, animationOffsetEntry!.value.dy * width, 0,) : null,
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * (isPortrait ? 0.8 : 0.6),
        child: Material(type: MaterialType.card, shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(widget.cornerRadius)),
          elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
          child: isPortrait ? portraitDialog(context, widget.image) : landscapeDialog(context, widget.image),
        ),
      ),
    );
  }
}