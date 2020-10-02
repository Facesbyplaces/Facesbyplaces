// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main(){
//   runApp(
//     MaterialApp(
//       home: CounterPage(),
//     ),
//   );
// }

// class CounterCubit extends Cubit<int> {
//   CounterCubit() : super(0);

//   void increment() => emit(state + 1);
//   void decrement() => emit(state - 1);
// }


// class CounterPage extends StatelessWidget {
  
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       // create: (BuildContext context) => CounterCubit(),
//       value: BlocProvider.of<CounterCubit>(context),
//       // child: Scaffold(
//       //   body: Center(
//       //   ),
//       //   floatingActionButton: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.end,
//       //     mainAxisAlignment: MainAxisAlignment.end,
//       //     children: <Widget>[
//       //       Padding(
//       //         padding: const EdgeInsets.symmetric(vertical: 5.0),
//       //         child: FloatingActionButton(
//       //           child: const Icon(Icons.add),
//       //           onPressed: () => context.bloc<CounterCubit>().increment(),
//       //         ),
//       //       ),
//       //       Padding(
//       //         padding: const EdgeInsets.symmetric(vertical: 5.0),
//       //         child: FloatingActionButton(
//       //           child: const Icon(Icons.remove),
//       //           onPressed: () => context.bloc<CounterCubit>().decrement(),
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     );  


//     // return BlocProvider(
//     //   create: (BuildContext context) => CounterCubit(),
//     //   child: Scaffold(
//     //     body: Center(
//     //     ),
//     //     floatingActionButton: Column(
//     //       crossAxisAlignment: CrossAxisAlignment.end,
//     //       mainAxisAlignment: MainAxisAlignment.end,
//     //       children: <Widget>[
//     //         Padding(
//     //           padding: const EdgeInsets.symmetric(vertical: 5.0),
//     //           child: FloatingActionButton(
//     //             child: const Icon(Icons.add),
//     //             onPressed: () => context.bloc<CounterCubit>().increment(),
//     //           ),
//     //         ),
//     //         Padding(
//     //           padding: const EdgeInsets.symmetric(vertical: 5.0),
//     //           child: FloatingActionButton(
//     //             child: const Icon(Icons.remove),
//     //             onPressed: () => context.bloc<CounterCubit>().decrement(),
//     //           ),
//     //         ),
//     //       ],
//     //     ),
//     //   ),
//     // );  
//   }
// }



import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// class CounterObserver extends BlocObserver{

//   @override
//   void onChange(Cubit cubit, Change change){
//     print('${cubit.runtimeType} $change');
//     super.onChange(cubit, change);
//   }
// }

void main(){
  // CounterObserver observer = CounterObserver();
  runApp(const CounterApp());
}


class CounterApp extends MaterialApp{
  const CounterApp({Key key}) : super(key: key, home: const CounterPage());
}

class CounterPage extends StatelessWidget{

  const CounterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
  }
}

class CounterCubit extends Cubit<int>{

  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

class CounterView extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Counter'),),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state){
            return Text('$state', style: textTheme.headline2);
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.add),
            onPressed: () => context.bloc<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('counterView_decrement_floatingActionButton'),
            child: const Icon(Icons.remove),
            onPressed: () => context.bloc<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}