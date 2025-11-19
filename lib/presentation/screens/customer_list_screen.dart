import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/api_repository.dart';
import '../../logic/customer_bloc/customer_bloc.dart';
import '../../logic/customer_bloc/customer_event.dart';
import '../../logic/customer_bloc/customer_state.dart';
import '../widgets/customer_card.dart';
import '../widgets/loading_shimmer.dart';
import 'user_details_screen.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer List",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const UserDetailsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      if (state.status ==
                          CustomerStatus.initial) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CustomerListShimmer(),
                        );
                      }

                      if (state.customers.isEmpty &&
                          state.status ==
                              CustomerStatus.success) {
                        return const Center(
                          child: Text("No customers found"),
                        );
                      }

                      if (state.customers.isEmpty &&
                          state.status ==
                              CustomerStatus.failure) {
                        return Center(
                          child: Text(
                            "Error: ${state.errorMessage}",
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: const Color(0xFF6A11CB),
                        child: ListView.builder(
                          controller: _scrollController,
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 4,
                            right: 4,
                            bottom: 20,
                          ),
                          itemCount: state.hasReachedMax
                              ? state.customers.length
                              : state.customers.length + 1,
                          itemBuilder: (context, index) {
                            if (index >=
                                state.customers.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    16.0,
                                  ),
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child:
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(
                                            0xFF6A11CB,
                                          ),
                                        ),
                                  ),
                                ),
                              );
                            }
                            return CustomerCard(
                              customer:
                                  state.customers[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
