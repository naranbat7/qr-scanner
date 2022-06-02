import 'package:equatable/equatable.dart';

abstract class QRState extends Equatable {
  const QRState([List props = const []]) : super();
}

class QRInitial extends QRState {
  @override
  String toString() => "QRInitial";

  @override
  List<Object?> get props => [];
}

class QRLoading extends QRState {
  @override
  String toString() => "QRLoading";

  @override
  List<Object?> get props => [];
}

class QRFailure extends QRState {
  final String error;

  QRFailure({required this.error}) : super([error]);

  @override
  String toString() => "QRFailure{error: $error}";

  @override
  List<Object?> get props => [];
}

class QRSuccessful extends QRState {
  final String successMsg;

  QRSuccessful({required this.successMsg}) : super([successMsg]);

  @override
  String toString() => "QRSuccess{msg: $successMsg}";

  @override
  List<Object?> get props => [];
}
