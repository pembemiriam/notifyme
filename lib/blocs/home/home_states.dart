import 'package:equatable/equatable.dart';
import 'package:notifytest/data/models/message.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable{
  HomeState([List props = const[]]) : super([props]);
}

class HomeLoaded extends HomeState {
  final List<Message> lstMessages;
  
  HomeLoaded({@required this.lstMessages}) : assert(lstMessages != null), super([lstMessages]);

  @override
  String toString() => 'HomeLoaded';
}

class HomeLoading extends HomeState {
  @override
  String toString() => 'HomeLoading';
}

class Failure extends HomeState {
  final String error;

  Failure({@required this.error}) : super([error]);

  @override
  String toString() => 'Failure { error: $error }';
}

class SendMessageSuccess extends HomeState {
  @override
  String toString() => 'SendMessageSuccess';
}

class LogoutInitial extends HomeState {
  @override
  String toString() => 'LogoutInitial';
}

class LogoutLoading extends HomeState {
  @override
  String toString() => 'LogoutLoading';
}

class LogoutFailure extends HomeState {
  final String error;

  LogoutFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'LogoutFailure { error: $error }';
}