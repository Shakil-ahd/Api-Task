import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/api_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final ApiRepository repository;
  static const int _pageSize = 20;

  CustomerBloc({required this.repository}) : super(const CustomerState()) {
    on<CustomerFetchEvent>(_onCustomerFetch);
  }

  Future<void> _onCustomerFetch(
    CustomerFetchEvent event,
    Emitter<CustomerState> emit,
  ) async {
    if (state.isFetching) return;

    emit(state.copyWith(isFetching: true, status: CustomerStatus.initial));

    try {
      final customers = await repository.getCustomers(
        pageNo: event.page,
        pageSize: _pageSize,
      );

      emit(
        state.copyWith(
          status: CustomerStatus.success,

          customers: customers,
          hasReachedMax: customers.length < _pageSize,
          pageNo: event.page,
          isFetching: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerStatus.failure,
          errorMessage: e.toString().replaceAll("Exception: ", ""),
          isFetching: false,
        ),
      );
    }
  }
}
