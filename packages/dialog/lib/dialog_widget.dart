part of dialog;

class CustomDialog extends StatefulWidget{
  final Widget imageWidget;
  final AnimationEntry animationEntry;
  final double cornerRadius;
  final Text title;
  final Text description;
  final bool onlyOkButton;
  final bool onlyCancelButton;
  final VoidCallback? okButton;
  // final void Function() okButton;
  // final Function() okButton;
  final VoidCallback? cancelButton;
  final Text okButtonText;
  final Text cancelButtonText;
  const CustomDialog({Key? key, required this.imageWidget, this.animationEntry = AnimationEntry.standard, this.cornerRadius = 5.0, required this.title, required this.description, this.onlyOkButton = false, this.onlyCancelButton = false, this.okButton, this.cancelButton, this.okButtonText = const Text('OK', style: TextStyle(color: Colors.green)), this.cancelButtonText = const Text('CANCEL', style: TextStyle(color: Colors.red)),}) : super(key: key);

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> with TickerProviderStateMixin{
  // AnimationController animationController = AnimationController(vsync: CustomDialogState());
  AnimationController? animationController;
  Animation<Offset>? animationOffsetEntry;
  // Animation<Offset> animationEntry =           Tween<Offset>(begin: widget.entryAnimation, end: Offset(0.0, 0.0)).animate(
  //       CurvedAnimation(
  //         parent: _animationController,
  //         curve: Curves.easeIn,
  //       ),

  // get _entryAnimation{

  // }

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
    // if (!_isDefaultEntryAnimation) {
    //   _animationController = AnimationController(
    //     vsync: this,
    //     duration: Duration(milliseconds: 300),
    //   );
    //   _entryAnimation =
    //       Tween<Offset>(begin: _start, end: Offset(0.0, 0.0)).animate(
    //     CurvedAnimation(
    //       parent: _animationController,
    //       curve: Curves.easeIn,
    //     ),
    //   )..addListener(() => setState(() {}));
    //   _animationController.forward();
    // }

    if(!isStandardAnimationEntry){
      print('here here here');
      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
      // animationOffsetEntry = Tween<Offset>(begin: entryAnimation, end: const Offset(0.0, 0.0)).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeIn,))
      animationOffsetEntry = Tween<Offset>(begin: entryAnimation, end: const Offset(0.0, 0.0)).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeIn,)
      ..addListener(() {
        setState(() {});
        animationController!.forward();
      }));
        // ..addListener(() {
        //   setState(() {});
        //   animationController!.forward();
        // });
      // animationEntry = Tween<Offset>(begin: entryAnimation, end: const Offset(0.0, 0.0)).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeIn,));
    }

    // if(!isStandardAnimationEntry){
    //   animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300),);
    //   animationOffsetEntry = Tween<Offset>(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0)).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeIn,)..addListener(() => setState(() {}));
    //   _animationController.forward();
    // }
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
            // borderRadius: BorderRadius.horizontal(left: Radius.circular(widget.cornerRadius), right: Radius.circular(widget.cornerRadius)),
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
                child: widget.title,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.description,
              ),
              // _buildButtonsBar(context)
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
                child: widget.title,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: widget.description,
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
        mainAxisAlignment: !widget.onlyOkButton
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: [
          if (!widget.onlyOkButton)...[
            // FlatButton(onPressed: onPressed, child: child)
            TextButton(
              child: widget.okButtonText,
              onPressed: widget.okButton ?? () => Navigator.of(context).pop(),
            ),
          ]

          else if (!widget.onlyCancelButton)...[
            // FlatButton(onPressed: onPressed, child: child)
            TextButton(
              child: widget.cancelButtonText,
              onPressed: widget.cancelButton ?? () => Navigator.of(context).pop(),
            ),
          ]



          // if (!widget.onlyOkButton) ...[
          //   RaisedButton(
          //     color: widget.buttonCancelColor,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(widget.buttonRadius)),
          //     onPressed: widget.onCancelButtonPressed ??
          //         () => Navigator.of(context).pop(),
          //     child: widget.buttonCancelText ??
          //         Text(
          //           'Cancel',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //   )
          // ],
          // if (!widget.onlyCancelButton) ...[
          //   RaisedButton(
          //     color: widget.buttonOkColor,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(widget.buttonRadius)),
          //     onPressed: widget.onOkButtonPressed,
          //     child: widget.buttonOkText ??
          //         Text(
          //           'OK',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //   ),
          // ],
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
      child: Container(transform: !isStandardAnimationEntry ? Matrix4.translationValues(entryAnimation.value.dx * width, entryAnimation.value.dy * width, 0,) : null,
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * (isPortrait ? 0.8 : 0.6),
        child: Material(type: MaterialType.card, shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(widget.cornerRadius)),
          elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
          child: isPortrait
              ? portraitDialog(context, widget.imageWidget)
              : landscapeDialog(context, widget.imageWidget),
        ),
      ),
    );
  }
}