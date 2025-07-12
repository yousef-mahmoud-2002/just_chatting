import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  InternetCubit() : super(InternetInitial());

  void checkInternet() {
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        emit(InternetNotConnected());
      } else {
        emit(InternetConnected());
      }
    });
  }
}
