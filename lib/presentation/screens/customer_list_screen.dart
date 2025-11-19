import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_1/presentation/screens/user_details_screen.dart';
import '../../data/repositories/api_repository.dart';
import '../../logic/customer_bloc/customer_bloc.dart';
import '../../logic/customer_bloc/customer_event.dart';
import '../../logic/customer_bloc/customer_state.dart';
import '../widgets/customer_card.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerBloc(
        repository: context.read<ApiRepository>(),
      )..add(CustomerFetchEvent()),
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatefulWidget {
  const _CustomerListView({Key? key}) : super(key: key);

  @override
  State<_CustomerListView> createState() =>
      _CustomerListViewState();
}

class _CustomerListViewState
    extends State<_CustomerListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CustomerBloc>().add(
        CustomerFetchEvent(),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll =
        _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    context.read<CustomerBloc>().add(
      CustomerRefreshEvent(),
    );
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Customer List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // ✅ Settings e click korle UserDetailsScreen (Profile) e jabe
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserDetailsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state.status == CustomerStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.customers.isEmpty &&
              state.status == CustomerStatus.success) {
            return const Center(
              child: Text("No customers found"),
            );
          }

          if (state.customers.isEmpty &&
              state.status == CustomerStatus.failure) {
            return Center(
              child: Text("Error: ${state.errorMessage}"),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: Colors.blue,
            child: ListView.builder(
              controller: _scrollController,
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              itemCount: state.hasReachedMax
                  ? state.customers.length
                  : state.customers.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.customers.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                }
                // ✅ Data pass kora hocche CustomerCard e
                return CustomerCard(
                  customer: state.customers[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
