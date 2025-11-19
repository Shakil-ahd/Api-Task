import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/api_repository.dart';
import '../../logic/customer_bloc/customer_bloc.dart';
import '../../logic/customer_bloc/customer_event.dart';
import '../../logic/customer_bloc/customer_state.dart';
import '../widgets/customer_card.dart';
import '../widgets/loading_shimmer.dart';
import 'user_setting_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CustomerBloc(repository: context.read<ApiRepository>())
            ..add(CustomerFetchEvent(page: 1)),
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatelessWidget {
  const _CustomerListView({Key? key}) : super(key: key);

  Future<void> _onRefresh(BuildContext context) async {
    context.read<CustomerBloc>().add(CustomerFetchEvent(page: 1));
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
            colors: [
              Color.fromARGB(255, 149, 175, 3),
              Color.fromARGB(255, 0, 89, 255),
            ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Customer List",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserDetailsScreen(),
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
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: BlocBuilder<CustomerBloc, CustomerState>(
                          builder: (context, state) {
                            if (state.status == CustomerStatus.initial ||
                                state.isFetching) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: CustomerListShimmer(),
                              );
                            }

                            if (state.status == CustomerStatus.failure) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.redAccent,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Error: ${state.errorMessage}",
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (state.customers.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No customers found",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }

                            return GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) {
                                if (state.isFetching) return;

                                if (details.primaryVelocity! < 0) {
                                  if (!state.hasReachedMax) {
                                    context.read<CustomerBloc>().add(
                                      CustomerFetchEvent(
                                        page: state.pageNo + 1,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("No more pages"),
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          252,
                                          2,
                                          2,
                                        ),
                                        duration: Duration(milliseconds: 500),
                                      ),
                                    );
                                  }
                                } else if (details.primaryVelocity! > 0) {
                                  if (state.pageNo > 1) {
                                    context.read<CustomerBloc>().add(
                                      CustomerFetchEvent(
                                        page: state.pageNo - 1,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Swipe Left To Next"),
                                        backgroundColor: Colors.green,
                                        duration: Duration(milliseconds: 500),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: RefreshIndicator(
                                onRefresh: () => _onRefresh(context),
                                color: const Color.fromARGB(255, 0, 89, 255),
                                backgroundColor: Colors.white,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 16,
                                    right: 16,
                                    bottom: 10,
                                  ),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: state.customers.length,
                                  itemBuilder: (context, index) {
                                    return CustomerCard(
                                      customer: state.customers[index],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: BlocBuilder<CustomerBloc, CustomerState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state.pageNo > 1) ...[
                                Icon(
                                  Icons.swipe_right_rounded,
                                  color: Colors.grey[400],
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Prev",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F3F8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Page ${state.pageNo}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 89, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              if (!state.hasReachedMax) ...[
                                const SizedBox(width: 12),
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.swipe_left_rounded,
                                  color: Colors.grey[400],
                                  size: 18,
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
