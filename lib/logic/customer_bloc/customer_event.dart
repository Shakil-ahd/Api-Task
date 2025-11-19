import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CustomerFetchEvent extends CustomerEvent {}

class CustomerRefreshEvent extends CustomerEvent {}
