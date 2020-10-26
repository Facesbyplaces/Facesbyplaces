// import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
// import 'package:facesbyplaces/UI/Home/home-02-home-extended.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeScreen extends StatelessWidget{

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MultiBlocProvider(
//         providers: [
//           BlocProvider<BlocHomeUpdateCubit>(
//             create: (context) => BlocHomeUpdateCubit(),
//           ),
//           BlocProvider<BlocHomeUpdateToggle>(
//             create: (context) => BlocHomeUpdateToggle(),
//           ),
//           BlocProvider<BlocHomeUpdateToggleFeed>(
//             create: (context) => BlocHomeUpdateToggleFeed(),
//           ),
//           BlocProvider<BlocHomeUpdateListSuggested>(
//             create: (context) => BlocHomeUpdateListSuggested(),
//           ),
//           BlocProvider<BlocHomeUpdateListNearby>(
//             create: (context) => BlocHomeUpdateListNearby(),
//           ),
//           BlocProvider<BlocHomeUpdateListBLM>(
//             create: (context) => BlocHomeUpdateListBLM(),
//           ),
//           BlocProvider<BlocHomeUpdateMemorialToggle>(
//             create: (context) => BlocHomeUpdateMemorialToggle(),
//           ),
//         ],
//       child: HomeScreenExtended(),
//       ),
//     );
//   }
// }

// ========================================================================================


import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home-02-home-extended.dart';
import 'home-04-search.dart';
import 'home-05-01-post.dart';
import 'home-06-memorial.dart';
import 'home-07-create-memorial.dart';
import 'home-08-profile.dart';
import 'home-09-memorial-settings.dart';
import 'home-10-create-post.dart';
import 'home-11-page-details.dart';
import 'home-12-user-profile.dart';
import 'home-13-user-details.dart';

class HomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Faces by Places',
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BlocHomeUpdateCubit>(
            create: (context) => BlocHomeUpdateCubit(),
          ),
          BlocProvider<BlocHomeUpdateToggle>(
            create: (context) => BlocHomeUpdateToggle(),
          ),
          BlocProvider<BlocHomeUpdateListSuggested>(
            create: (context) => BlocHomeUpdateListSuggested(),
          ),
          BlocProvider<BlocHomeUpdateListNearby>(
            create: (context) => BlocHomeUpdateListNearby(),
          ),
          BlocProvider<BlocHomeUpdateListBLM>(
            create: (context) => BlocHomeUpdateListBLM(),
          ),
        ],
      child: HomeScreenExtended(),
      ),
      routes: <String, WidgetBuilder>{
        'home/': (BuildContext context) => HomeScreen(),
        'home/home-04-search': (BuildContext context) => HomeSearch(),
        'home/home-05-post': (BuildContext context) => HomePost(),
        'home/home-06-memorial': (BuildContext context) => HomeMemorialProfile(),
        'home/home-07-01-create-memorial': (BuildContext context) => HomeCreateMemorial(),
        'home/home-07-02-create-memorial': (BuildContext context) => HomeCreateMemorial2(),
        'home/home-07-03-create-memorial': (BuildContext context) => HomeCreateMemorial3(),
        'home/home-08-profile': (BuildContext context) => HomeProfile(),
        'home/home-09-memorial-settings': (BuildContext context) => HomeMemorialSettings(),
        'home/home-10-create-post': (BuildContext context) => HomeCreatePost(),
        'home/home-11-page-details': (BuildContext context) => HomePageDetails(),
        'home/home-12-memorial-list': (BuildContext context) => HomeUserProfile(),
        'home/home-13-user-details': (BuildContext context) => HomeUserProfileDetails(),
      },
    );
  }
}

              // context.bloc<BlocHomeUpdateCubit>().modify(4);