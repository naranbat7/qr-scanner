import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr/bloc/event.dart';
import 'package:qr/bloc/state.dart';
import 'package:qr/service.dart';

class QRBloc extends Bloc<QREvent, QRState> {
  QRBloc(QRState initialState) : super(initialState) {
    on<QRSubmit>((event, emit) async {
      emit(QRLoading());
      try {
        await ApiRequest.postRequest(data: event.data);
        emit(QRSuccessful(successMsg: "Successful"));
      } catch (ex) {
        emit(QRFailure(error: "Түр хүлээгээд дахин оролдоно уу."));
      }
    });
  }
}
