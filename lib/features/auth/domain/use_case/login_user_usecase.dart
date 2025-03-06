import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
    if (params.email.isEmpty || params.password.isEmpty) {
      return const Left(
          ApiFailure(message: 'Email or password cannot be empty'));
    }

    final result = await repository.loginStudent(params.email, params.password);

    return result.fold(
      (failure) => Left(failure),
      (token) async {
        await tokenSharedPrefs.saveToken(token);

        try {
          // ✅ Decode JWT Token to Extract User Data
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

          String userId = decodedToken.containsKey('id')
              ? decodedToken['id'] as String
              : '';
          String fullName = decodedToken.containsKey('fullName')
              ? decodedToken['fullName'] as String
              : 'User';
          String email = decodedToken.containsKey('email')
              ? decodedToken['email'] as String
              : 'No Email';
          String role = decodedToken.containsKey('role')
              ? decodedToken['role'] as String
              : 'student';
          String profileImage = decodedToken.containsKey('profileImage')
              ? decodedToken['profileImage'] as String
              : '';

          // ✅ Save User Data in Shared Preferences
          await tokenSharedPrefs.saveUserInfo(
              fullName, email, role, profileImage);
          await tokenSharedPrefs.saveUserId(userId);

          return Right(token);
        } catch (error) {
          return const Left(
              SharedPrefsFailure(message: "Error decoding JWT token"));
        }
      },
    );
  }
}
