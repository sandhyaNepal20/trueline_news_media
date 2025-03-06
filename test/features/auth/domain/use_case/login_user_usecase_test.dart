import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/app/shared_prefs/token_shared_prefs.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/auth/domain/repository/auth_repository.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/login_user_usecase.dart';

// Mocks
class MockAuthRepository extends Mock implements IAuthRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    loginUseCase = LoginUseCase(mockAuthRepository, mockTokenSharedPrefs);
  });

  group('LoginUseCase', () {
    const String testToken = '88888888888888';
    const String testemail = 'sandhyanepal54@gmail.com';
    const String testPassword = 'sandhya1111';
    const LoginParams params =
        LoginParams(email: testemail, password: testPassword);

    test('should return token when login is successful', () async {
      when(() => mockAuthRepository.loginStudent(testemail, testPassword))
          .thenAnswer((_) async => const Right(testToken));

      when(() => mockTokenSharedPrefs.saveToken(testToken))
          .thenAnswer((_) async => const Right(null));

      final result = await loginUseCase(params);

      expect(result, const Right(testToken));
      verify(() => mockTokenSharedPrefs.saveToken(testToken)).called(1);
    });

    test('should return ApiFailure when login fails', () async {
      const failure = ApiFailure(message: 'Login failed', statusCode: 500);
      when(() => mockAuthRepository.loginStudent(testemail, testPassword))
          .thenAnswer((_) async => const Left(failure));

      final result = await loginUseCase(params);

      expect(result, const Left(failure));
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should not save token if login fails', () async {
      const failure = ApiFailure(message: 'Login failed', statusCode: 500);
      when(() => mockAuthRepository.loginStudent(testemail, testPassword))
          .thenAnswer((_) async => const Left(failure));

      final result = await loginUseCase(params);

      expect(result, const Left(failure));
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should handle invalid input (empty email or password)', () async {
      const invalidParams = LoginParams(email: '', password: '');

      final result = await loginUseCase(invalidParams);

      expect(result,
          const Left(ApiFailure(message: 'email or password cannot be empty')));
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should return ApiFailure when email is empty', () async {
      const invalidParams = LoginParams(email: '', password: testPassword);

      final result = await loginUseCase(invalidParams);

      expect(result,
          const Left(ApiFailure(message: 'email or password cannot be empty')));
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should return ApiFailure when password is empty', () async {
      const invalidParams = LoginParams(email: testemail, password: '');

      final result = await loginUseCase(invalidParams);

      expect(result,
          const Left(ApiFailure(message: 'email or password cannot be empty')));
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });
  });
}
