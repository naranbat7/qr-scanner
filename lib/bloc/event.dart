import 'package:equatable/equatable.dart';

abstract class QREvent extends Equatable {
  const QREvent([List props = const []]) : super();
}

class QRSubmit extends QREvent {
  final String data;

  const QRSubmit(this.data);

  @override
  List<Object> get props => [];
}
