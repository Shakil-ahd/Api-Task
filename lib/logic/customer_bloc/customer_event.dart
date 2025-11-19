import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CustomerFetchEvent extends CustomerEvent {
  final int page;

  CustomerFetchEvent({required this.page});

  @override
  List<Object> get props => [page];
}
