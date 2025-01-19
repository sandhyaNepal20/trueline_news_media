part of 'login_bloc.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
    required this.isFailure,
  });

  factory LoginState.initial() {
    return LoginState(
      isLoading: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
