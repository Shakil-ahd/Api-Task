import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/api_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc
    extends Bloc<CustomerEvent, CustomerState> {
  final ApiRepository repository;
  static const int _pageSize = 20;

  CustomerBloc({required this.repository})
    : super(const CustomerState()) {
    on<CustomerFetchEvent>(_onCustomerFetch);
    on<CustomerRefreshEvent>(_onCustomerRefresh);
  }

  Future<void> _onCustomerFetch(
    CustomerFetchEvent event,
    Emitter<CustomerState> emit,
  ) async {
    if (state.hasReachedMax || state.isFetching) return;

    try {
      if (state.status == CustomerStatus.initial) {
        final customers = await repository.getCustomers(
          pageNo: 1,
          pageSize: _pageSize,
        );
        return emit(
          state.copyWith(
            status: CustomerStatus.success,
            customers: customers,
            hasReachedMax: customers.length < _pageSize,
            pageNo: 2,
            isFetching: false,
          ),
        );
      }

      emit(state.copyWith(isFetching: true));

      final customers = await repository.getCustomers(
        pageNo: state.pageNo,
        pageSize: _pageSize,
      );

      if (customers.isEmpty) {
        emit(
          state.copyWith(
            hasReachedMax: true,
            isFetching: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CustomerStatus.success,
            customers: List.of(state.customers)
              ..addAll(customers),
            hasReachedMax: customers.length < _pageSize,
            pageNo: state.pageNo + 1,
            isFetching: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerStatus.failure,
          errorMessage: e.toString().replaceAll(
            "Exception: ",
            "",
          ),
          isFetching: false,
        ),
      );
    }
  }

  Future<void> _onCustomerRefresh(
    CustomerRefreshEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CustomerStatus.initial,
        customers: [],
        hasReachedMax: false,
        pageNo: 1,
        isFetching: false,
      ),
    );
    add(CustomerFetchEvent());
  }
}
