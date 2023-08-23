import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

enum SomeBlocEvent { start, error }

class SomeBloc extends Bloc<SomeBlocEvent, int> {
  SomeBloc() : super(0) {
    on<SomeBlocEvent>((event, emit) {
      try {
        switch (event) {
          case SomeBlocEvent.start:
            emit(Random().nextInt(255));
            break;
          default:
            throw Exception('ERROR');
        }
      } catch (error) {
        emit(-1);
        rethrow;
      }
    });
  }
}
