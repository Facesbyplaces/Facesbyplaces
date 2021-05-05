import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'api-start-blm-06-sign-in-with-google.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class BLMGoogleAuthentication {
  static Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      bool result = await apiBLMSignInWithGoogle(
        firstName: user.displayName!, 
        lastName: '', 
        email: user.email!, 
        username: user.email!,
        googleId: await user.getIdToken(),
        image: user.photoURL!,
      );

      if(result == true){
        Navigator.pushReplacementNamed(context, '/home/blm');
      }
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    context.showLoaderOverlay();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      FlutterClipboard.copy('${googleSignInAuthentication.idToken}').then(( value ) => print('copied!'));

      bool result = await apiBLMSignInWithGoogle(
        firstName: googleSignInAccount.displayName!, 
        lastName: '', 
        email: googleSignInAccount.email, 
        username: googleSignInAccount.email,
        googleId: await FlutterClipboard.paste().then((value) {return value;}),
        image: googleSignInAccount.photoUrl!,
      );

      print('The result is $result');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          await showDialog(
            context: context,
            builder: (_) => 
              AssetGiffyDialog(
              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
              entryAnimation: EntryAnimation.DEFAULT,
              description: Text('The account already exists with a different credential.',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              buttonOkColor: Colors.red,
              onOkButtonPressed: () {
                Navigator.pop(context, true);
              },
            )
          );
        }
        else if (e.code == 'invalid-credential') {
          await showDialog(
            context: context,
            builder: (_) => 
              AssetGiffyDialog(
              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
              entryAnimation: EntryAnimation.DEFAULT,
              description: Text('Error occurred while accessing credentials. Try again.',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onlyOkButton: true,
              buttonOkColor: Colors.red,
              onOkButtonPressed: () {
                Navigator.pop(context, true);
              },
            )
          );
        }
      } catch (e) {
        await showDialog(
          context: context,
          builder: (_) => 
            AssetGiffyDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: Text('Error occurred while accessing credentials. Try again.',
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            onlyOkButton: true,
            buttonOkColor: Colors.red,
            onOkButtonPressed: () {
              Navigator.pop(context, true);
            },
          )
        );
      }
    }

    context.hideLoaderOverlay();

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (_) => 
          AssetGiffyDialog(
          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
          entryAnimation: EntryAnimation.DEFAULT,
          description: Text('Error signing out. Try again.',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          onlyOkButton: true,
          buttonOkColor: Colors.red,
          onOkButtonPressed: () {
            Navigator.pop(context, true);
          },
        )
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}