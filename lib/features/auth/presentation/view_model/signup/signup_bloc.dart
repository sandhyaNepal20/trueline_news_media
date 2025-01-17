import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:trueline_news_media/core/common/snackbar/my_snackbar.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/register_user_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RegisterUserUseCase _registerUseCase;

  SignupBloc({
    required RegisterUserUseCase registerUseCase,
  })  : _registerUseCase = registerUseCase,
        super(SignupState.initial()) {
    //load jobs here
    on<RegisterUser>(_onRegisterEvent);
  }

  void _onRegisterEvent(
    RegisterUser event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _registerUseCase.call(RegisterUserParams(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }
}
