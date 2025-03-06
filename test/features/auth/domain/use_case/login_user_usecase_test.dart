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

      expect(
        result,
        const Left(ApiFailure(message: 'Email or password cannot be empty')),
      );
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should return ApiFailure when email is empty', () async {
      const invalidParams = LoginParams(email: '', password: testPassword);
      final result = await loginUseCase(invalidParams);

      expect(
        result,
        const Left(ApiFailure(message: 'Email or password cannot be empty')),
      );
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should return ApiFailure when password is empty', () async {
      const invalidParams = LoginParams(email: testemail, password: '');
      final result = await loginUseCase(invalidParams);

      expect(
        result,
        const Left(ApiFailure(message: 'Email or password cannot be empty')),
      );
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    // Additional test: simulate invalid JWT token that causes a decode error.
    test('should return SharedPrefsFailure when JWT decoding fails', () async {
      // An invalid token format that will cause JwtDecoder.decode to throw.
      const String invalidJwtToken = 'invalid.token';
      when(() => mockAuthRepository.loginStudent(testemail, testPassword))
          .thenAnswer((_) async => const Right(invalidJwtToken));

      when(() => mockTokenSharedPrefs.saveToken(invalidJwtToken))
          .thenAnswer((_) async => const Right(null));

      final result = await loginUseCase(params);

      expect(
        result,
        const Left(SharedPrefsFailure(message: "Error decoding JWT token")),
      );
    });

    // Additional test: verify that user info and user id are saved when JWT is decoded successfully.
    test('should save user info and user id on successful JWT decoding',
        () async {
      const String validJwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
          'eyJpZCI6InVzZXJJZDEyMyIsImZ1bGxOYW1lIjoiVGVzdCBVc2VyIiwiZW1haWwiOiJ0ZXN0QGV4YW1wbGUuY29tIiwicm9sZSI6InN0dWRlbnQiLCJwcm9maWxlSW1hZ2UiOiJpbWFnZS5wbmcifQ.'
          'signature';

      when(() => mockAuthRepository.loginStudent(testemail, testPassword))
          .thenAnswer((_) async => const Right(validJwtToken));

      when(() => mockTokenSharedPrefs.saveToken(validJwtToken))
          .thenAnswer((_) async => const Right(null));

      // Simulate successful saving of user info and user id.
      when(() => mockTokenSharedPrefs.saveUserInfo(
            any(),
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => const Right(null));

      when(() => mockTokenSharedPrefs.saveUserId(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await loginUseCase(params);

      expect(result, const Right(validJwtToken));
      // Verify that user info and id were saved with the expected values.
      verify(() => mockTokenSharedPrefs.saveUserInfo(
            "Test User",
            "test@example.com",
            "student",
            "image.png",
          )).called(1);
      verify(() => mockTokenSharedPrefs.saveUserId("userId123")).called(1);
    });
  });
}
