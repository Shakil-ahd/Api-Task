import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/api_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiRepository repository;

  AuthBloc({required this.repository})
    : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.login(
          event.email,
          event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(
          AuthFailure(
            e.toString().replaceAll("Exception: ", ""),
          ),
        );
      }
    });
  }
}
