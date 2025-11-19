import 'package:equatable/equatable.dart';
import '../../data/models/customer_model.dart';

enum CustomerStatus { initial, success, failure }

class CustomerState extends Equatable {
  final CustomerStatus status;
  final List<CustomerModel> customers;
  final bool hasReachedMax;
  final int pageNo;
  final String errorMessage;

  const CustomerState({
    this.status = CustomerStatus.initial,
    this.customers = const <CustomerModel>[],
    this.hasReachedMax = false,
    this.pageNo = 1,
    this.errorMessage = "",
  });

  CustomerState copyWith({
    CustomerStatus? status,
    List<CustomerModel>? customers,
    bool? hasReachedMax,
    int? pageNo,
    String? errorMessage,
  }) {
    return CustomerState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNo: pageNo ?? this.pageNo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    customers,
    hasReachedMax,
    pageNo,
    errorMessage,
  ];
}
