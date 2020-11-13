import 'package:equatable/equatable.dart';
import 'package:notifytest/data/models/message.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const []]) : super(props);
}

class HomeStarted extends HomeEvent {
  @override
  String toString() => 'HomeStarted';
}

class SendMessagePressed extends HomeEvent {
  final String message;

  SendMessagePressed({
    this.message,
  }) : super([message]);

  @override
  String toString() => 'SendMessagePressed { message: $message}';

}

class NewMessageAdded extends HomeEvent {
  final Message message;

  NewMessageAdded({
    this.message,
  }) : super([message]);

  @override
  String toString() => 'NewMessageAdded { message: ${message.toString()}}';

}

class LogoutButtonPressed extends HomeEvent {


  LogoutButtonPressed() : super();

  @override
  String toString() => 'LogoutButtonPressed {}';

}