import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:trueline_news_media/view/Homepage_view.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignupBloc _signupBloc;
  final LoginUseCase _loginUseCase;

  LoginBloc({
    required SignupBloc signupBloc,
    required LoginUseCase loginUseCase,
  })  : _signupBloc = signupBloc,
        _loginUseCase = loginUseCase,
        super(LoginState.initial()) {
    // Event handler for logging in
    on<LoginUserEvent>(
      (event, emit) async {
        emit(state.copyWith(isLoading: true));
        final result = await _loginUseCase(
          LoginParams(
            email: event.email,
            password: event.password,
          ),
        );

        result.fold(
          (failure) {
            emit(state.copyWith(isLoading: false, isSuccess: false));
            // Show Snackbar for failure
            showMySnackBar(
              context: event.context,
              message: "Invalid Credentials",
              color: Colors.red,
            );
          },
          (token) {
            emit(state.copyWith(isLoading: false, isSuccess: true));
            // Show Snackbar for success
            showMySnackBar(
              context: event.context,
              message: "Login Successful",
              color: Colors.green,
            );
            // Dispatch a navigation event
            add(NavigateHomeScreenEvent(
              context: event.context,
              destination: const HomeScreen(),
            ));
          },
        );
      },
    );

    // Event handler for navigation to the home screen
    on<NavigateHomeScreenEvent>(
      (event, emit) {
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => event.destination,
          ),
        );
      },
    );

    // Event handler for navigation to the registration screen
    on<NavigateRegisterScreenEvent>(
      (event, emit) {
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: _signupBloc, child: event.destination),
          ),
        );
      },
    );
  }
}

// Snackbar utility function
void showMySnackBar({
  required BuildContext context,
  required String message,
  required Color color,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
