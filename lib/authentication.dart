import 'API/Regular/01-Start/api-start-regular-06-sign-in-google.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'authentication-ui.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      bool result = await apiRegularSignInWithGoogle(
        firstName: user.displayName!, 
        lastName: '', 
        email: user.email!, 
        username: user.email!,
        // googleId: googleSignInAuthentication.idToken!.toString(),
        googleId: await user.getIdToken(),
        // googleId: newToken,
        // googleId: printWrapped(googleSignInAuthentication.idToken!),
        // googleId: newToken1 + newToken2,
        image: user.photoURL!,
      );

      if(result == true){
        Navigator.pushReplacementNamed(context, '/home/regular');
      }
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      print('The display name is ${googleSignInAccount.displayName}');
      print('The email is ${googleSignInAccount.email}');
      print('The id is ${googleSignInAccount.id}');
      print('The photo is ${googleSignInAccount.photoUrl}');

      FlutterClipboard.copy('${googleSignInAuthentication.idToken}').then(( value ) => print('copied!'));

      

      // print('The access token is ${googleSignInAuthentication.accessToken}');
      // print('The id token is ${googleSignInAuthentication.idToken}');


      // String newToken = '';
      // String newToken1 = '';
      // String newToken2 = '';

      

      // void printWrapped(String text) {
      //   final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
      //   // pattern.allMatches(text).forEach((match) => print('sample' + '${match.group(0)}'));
      //   pattern.allMatches(text).forEach((match){
      //     print('sample ' + '${match.group(0)}');
      //     // newToken += match.group(0)!;
      //     if(newToken1 == ''){
      //       newToken1 += match.group(0)!;
      //     }else if(newToken2 == ''){
      //       newToken2 += match.group(0)!;
      //     }
      //     // print('The newToken ${match.groupCount} is $newToken');
      //   });
      // }

      // String printWrapped(String text) {
      //   String newToken = '';

      //   final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
      //   pattern.allMatches(text).forEach((match){
      //     print('sample ' + '${match.group(0)}');
      //     // newToken += match.group(0)!;
      //     // print('The newToken ${match.groupCount} is $newToken');
      //     newToken += match.group(0)!;
      //   });
      //   return newToken;
      // }

      // printWrapped(googleSignInAuthentication.idToken!.t);
      

      // String newToken = googleSignInAuthentication.idToken!;

      // print('The newToken is $newToken');

      bool result = await apiRegularSignInWithGoogle(
        firstName: googleSignInAccount.displayName!, 
        lastName: '', 
        email: googleSignInAccount.email, 
        username: googleSignInAccount.email,
        // googleId: googleSignInAuthentication.idToken!.toString(),
        googleId: await FlutterClipboard.paste().then((value) {return value;}),
        // googleId: newToken,
        // googleId: printWrapped(googleSignInAuthentication.idToken!),
        // googleId: newToken1 + newToken2,
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

        // String newToken = await userCredential.user!.getIdToken();

        // print('The newToken is $newToken');

      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(content: 'The account already exists with a different credential',),
          );
        }
        else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(content: 'Error occurred while accessing credentials. Try again.',),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(content: 'Error occurred while accessing credentials. Try again.',),
        );
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
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