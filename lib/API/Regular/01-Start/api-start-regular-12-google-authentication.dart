import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api-start-regular-06-sign-in-google.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class RegularGoogleAuthentication {
  static Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      bool result = await apiRegularSignInWithGoogle(
        firstName: user.displayName!, 
        lastName: '', 
        email: user.email!, 
        username: user.email!,
        googleId: await user.getIdToken(),
        image: user.photoURL!,
      );

      if(result == true){
        Navigator.pushReplacementNamed(context, '/home/regular');
      }
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    context.loaderOverlay.show();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      FlutterClipboard.copy('${googleSignInAuthentication.idToken}').then(( value ) => print('Auth token copied!')); // verified on node

      bool result = await apiRegularSignInWithGoogle(
        firstName: googleSignInAccount.displayName!, 
        lastName: '', 
        email: googleSignInAccount.email, 
        username: googleSignInAccount.email,
        googleId: await FlutterClipboard.paste().then((value) {return value;}),
        image: googleSignInAccount.photoUrl!,
      );

      print('The sign in with google result is $result');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        print('The firebase error is $e');
        if (e.code == 'account-exists-with-different-credential') {
          await showDialog(
            context: context,
            builder: (_) => 
              AssetGiffyDialog(
              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
              title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
              entryAnimation: EntryAnimation.DEFAULT,
              description: const Text('The account already exists with a different credential.',
                textAlign: TextAlign.center,
              ),
              onlyOkButton: true,
              buttonOkColor: const Color(0xffff0000),
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
              title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
              entryAnimation: EntryAnimation.DEFAULT,
              description: const Text('Error occurred while accessing credentials. Try again.',
                textAlign: TextAlign.center,
              ),
              onlyOkButton: true,
              buttonOkColor: const Color(0xffff0000),
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
            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: const Text('Error occurred while accessing credentials. Try again.',
              textAlign: TextAlign.center,
            ),
            onlyOkButton: true,
            buttonOkColor: const Color(0xffff0000),
            onOkButtonPressed: () {
              Navigator.pop(context, true);
            },
          )
        );
      }
    }

    context.loaderOverlay.hide();

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
          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
          entryAnimation: EntryAnimation.DEFAULT,
          description: const Text('Error signing out. Try again.',
            textAlign: TextAlign.center,
          ),
          onlyOkButton: true,
          buttonOkColor: const Color(0xffff0000),
          onOkButtonPressed: () {
            Navigator.pop(context, true);
          },
        )
      );
    }
  }
}