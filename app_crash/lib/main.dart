import 'dart:async';

import 'package:app_crash/bloc/some_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Ловит флаттер ошибки
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    /// идентификатор уникальный
    FirebaseCrashlytics.instance.setUserIdentifier('userId');
    return runApp(const MainApp());
  },
      (error, stack) =>

          /// Ловит любые другие ошибки
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SomeBloc(),
        child: const MaterialApp(home: Home()));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool error = false;
  @override
  Widget build(BuildContext context) {
    final result = context.select<SomeBloc, (String, bool)>(
      (value) {
        return ('${value.state}', value.state == -1);
      },
    );
    return Scaffold(
      body: Center(
        child: Text(result.$1),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        throw Exception('FLUTTER ERROR');
      }),
    );
  }
}
