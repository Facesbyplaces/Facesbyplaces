// import 'API/Regular/01-Start/api-start-regular-06-sign-in-google.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:clipboard/clipboard.dart';

// class Authentication {
//   static Future<FirebaseApp> initializeFirebase({required BuildContext context}) async {
//     FirebaseApp firebaseApp = await Firebase.initializeApp();

//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       bool result = await apiRegularSignInWithGoogle(
//         firstName: user.displayName!, 
//         lastName: '', 
//         email: user.email!, 
//         username: user.email!,
//         googleId: await user.getIdToken(),
//         image: user.photoURL!,
//       );

//       if(result == true){
//         Navigator.pushReplacementNamed(context, '/home/regular');
//       }
//     }

//     return firebaseApp;
//   }

//   static Future<User?> signInWithGoogle({required BuildContext context}) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;

//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

//     if (googleSignInAccount != null) {
//       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//       FlutterClipboard.copy('${googleSignInAuthentication.idToken}').then(( value ) => print('copied!'));

//       bool result = await apiRegularSignInWithGoogle(
//         firstName: googleSignInAccount.displayName!, 
//         lastName: '', 
//         email: googleSignInAccount.email, 
//         username: googleSignInAccount.email,
//         googleId: await FlutterClipboard.paste().then((value) {return value;}),
//         image: googleSignInAccount.photoUrl!,
//       );

//       print('The result is $result');

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       try {
//         final UserCredential userCredential = await auth.signInWithCredential(credential);
//         user = userCredential.user;

//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'account-exists-with-different-credential') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             Authentication.customSnackBar(content: 'The account already exists with a different credential',),
//           );
//         }
//         else if (e.code == 'invalid-credential') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             Authentication.customSnackBar(content: 'Error occurred while accessing credentials. Try again.',),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           Authentication.customSnackBar(content: 'Error occurred while accessing credentials. Try again.',),
//         );
//       }
//     }

//     return user;
//   }

//   static Future<void> signOut({required BuildContext context}) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         Authentication.customSnackBar(
//           content: 'Error signing out. Try again.',
//         ),
//       );
//     }
//   }

//   static SnackBar customSnackBar({required String content}) {
//     return SnackBar(
//       backgroundColor: Colors.black,
//       content: Text(
//         content,
//         style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
//       ),
//     );
//   }
// }