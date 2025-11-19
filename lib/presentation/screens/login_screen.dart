import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth_bloc/auth_bloc.dart';
import '../../logic/auth_bloc/auth_event.dart';
import '../../logic/auth_bloc/auth_state.dart';
import 'customer_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Login Failed, Please try again",
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text("Login Successful!"),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );

              Future.delayed(
                const Duration(milliseconds: 100),
                () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          const CustomerListScreen(),
                    ),
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white.withOpacity(0.95),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_person_rounded,
                              size: 50,
                              color: Color(0xFF2575FC),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            "Please login to continue",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 30),

                          TextFormField(
                            controller: _emailCtrl,
                            validator: (value) =>
                                value!.isEmpty
                                ? "Email cannot be empty"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF6A11CB),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                              ),
                              filled: true,
                              fillColor:
                                  Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passCtrl,
                            obscureText: true,
                            validator: (value) =>
                                value!.isEmpty
                                ? "Password required"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF6A11CB),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                              ),
                              filled: true,
                              fillColor:
                                  Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.transparent,
                                shadowColor:
                                    Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),
                                ),
                              ),
                              onPressed:
                                  state is AuthLoading
                                  ? null
                                  : () {
                                      if (_formKey
                                          .currentState!
                                          .validate()) {
                                        context
                                            .read<
                                              AuthBloc
                                            >()
                                            .add(
                                              LoginRequested(
                                                _emailCtrl
                                                    .text,
                                                _passCtrl
                                                    .text,
                                              ),
                                            );
                                      }
                                    },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient:
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF6A11CB),
                                          Color(0xFF2575FC),
                                        ],
                                      ),
                                  borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),
                                ),
                                child: Container(
                                  alignment:
                                      Alignment.center,
                                  child:
                                      state is AuthLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child:
                                              CircularProgressIndicator(
                                                color: Colors
                                                    .white,
                                                strokeWidth:
                                                    2,
                                              ),
                                        )
                                      : const Text(
                                          "LOG IN",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                            color: Colors
                                                .white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
