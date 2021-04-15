// import 'package:facesbyplaces/authentication.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             bottom: 20.0,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Flexible(
//                       flex: 1,
//                       child: Image.asset(
//                         'assets/icons/cover-icon.png',
//                         height: 160,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'FlutterFire',
//                       style: TextStyle(
//                         color: Colors.yellow,
//                         fontSize: 40,
//                       ),
//                     ),
//                     Text(
//                       'Authentication',
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontSize: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               FutureBuilder(
//                 future: Authentication.initializeFirebase(context: context),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Error initializing Firebase');
//                   } else if (snapshot.connectionState == ConnectionState.done) {
//                     return GoogleSignInButton();
//                   }
//                   return CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.orange,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class GoogleSignInButton extends StatefulWidget {
//   @override
//   _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
// }

// class _GoogleSignInButtonState extends State<GoogleSignInButton> {
//   bool _isSigningIn = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: _isSigningIn
//       ? CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//         )
//       : OutlinedButton(
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.white),
//           shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(40),
//             ),
//           ),
//         ),
//         onPressed: () async {
//           setState(() {
//             _isSigningIn = true;
//           });
          
//           User? user = await Authentication.signInWithGoogle(context: context);

//           setState(() {
//             _isSigningIn = false;
//           });

//           if (user != null) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => UserInfoScreen(user: user,),
//               ),
//             );
//           }

//           setState(() {
//             _isSigningIn = false;
//           });
//         },
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image(
//                 image: AssetImage("assets/icons/cover-icon.png"),
//                 height: 35.0,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Text(
//                   'Sign in with Google',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class UserInfoScreen extends StatefulWidget {
//   const UserInfoScreen({Key? key, required User user}) : _user = user, super(key: key);
//   final User _user;

//   @override
//   _UserInfoScreenState createState() => _UserInfoScreenState();
// }

// class _UserInfoScreenState extends State<UserInfoScreen> {
//   late User _user;
//   bool _isSigningOut = false;

//   Route _routeToSignInScreen() {
//     return PageRouteBuilder(
//       pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         var begin = Offset(-1.0, 0.0);
//         var end = Offset.zero;
//         var curve = Curves.ease;

//         var tween =
//             Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//         return SlideTransition(
//           position: animation.drive(tween),
//           child: child,
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     _user = widget._user;

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.blueGrey,
//         title: Text('User Landing')
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             bottom: 20.0,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(),
//               _user.photoURL != null
//                   ? ClipOval(
//                       child: Material(
//                         color: Colors.grey.withOpacity(0.3),
//                         child: Image.network(
//                           _user.photoURL!,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       ),
//                     )
//                   : ClipOval(
//                       child: Material(
//                         color: Colors.grey.withOpacity(0.3),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Icon(
//                             Icons.person,
//                             size: 60,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//               SizedBox(height: 16.0),
//               Text(
//                 'Hello',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 26,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 _user.displayName!,
//                 style: TextStyle(
//                   color: Colors.yellow,
//                   fontSize: 26,
//                 ),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 '( ${_user.email!} )',
//                 style: TextStyle(
//                   color: Colors.orange,
//                   fontSize: 20,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               SizedBox(height: 24.0),
//               Text(
//                 'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
//                 style: TextStyle(
//                     color: Colors.grey.withOpacity(0.8),
//                     fontSize: 14,
//                     letterSpacing: 0.2),
//               ),
//               SizedBox(height: 16.0),
//               _isSigningOut
//                   ? CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     )
//                   : ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(
//                           Colors.redAccent,
//                         ),
//                         shape: MaterialStateProperty.all(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                       onPressed: () async {
//                         setState(() {
//                           _isSigningOut = true;
//                         });
//                         await Authentication.signOut(context: context);
//                         setState(() {
//                           _isSigningOut = false;
//                         });
//                         Navigator.of(context)
//                             .pushReplacement(_routeToSignInScreen());
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
//                         child: Text(
//                           'Sign Out',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 2,
//                           ),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }