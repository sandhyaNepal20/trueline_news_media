import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trueline_news_media/app/shared_prefs/token_shared_prefs.dart';
import 'package:trueline_news_media/app/usecase/usecase.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  // Initial Constructor
  const LoginParams.initial()
      : email = '',
        password = '';

  @override
  List<Object> get props => [email, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    // Check for empty email or password and return a failure immediately
    if (params.email.isEmpty || params.password.isEmpty) {
      return const Left(
          ApiFailure(message: 'email or password cannot be empty'));
    }

    // Proceed with the login if inputs are valid
    final result = await repository.loginStudent(params.email, params.password);

    return result.fold(
      (failure) => Left(failure), // If login fails, return the failure
      (token) {
        tokenSharedPrefs
            .saveToken(token); // Save the token if login is successful
        return Right(token); // Return the token if successful
      },
    );
  }
}
