import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/auth/domain/entity/auth_entity.dart';
import 'package:trueline_news_media/features/auth/domain/repository/auth_repository.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/register_user_usecase.dart';

// Mock Repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository repository;
  late RegisterUserUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = RegisterUserUseCase(repository);

    // Register fallback values for mocktail
    registerFallbackValue(
      const AuthEntity(
        fullName: 'Sandhya Nepal',
        email: 'sandhyanepal54@example.com',
        password: 'sandhya1111',
        image: null,
      ),
    );

    registerFallbackValue(
        const ApiFailure(message: 'Registration failed', statusCode: 400));
  });

  test('should register successfully', () async {
    // Arrange
    when(() => repository.registerStudent(any()))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(
      const RegisterUserParams(
        fullName: 'Sandhya Nepal',
        email: 'sandhya@example.com',
        password: 'securePass123',
        image: null,
      ),
    );

    // Assert
    expect(result, equals(const Right(null)));
    verify(() => repository.registerStudent(any())).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should register with an image successfully', () async {
    // Arrange
    when(() => repository.registerStudent(any()))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await useCase(
      const RegisterUserParams(
        fullName: 'Sandhya Nepal',
        email: 'sandhya@example.com',
        password: 'securePass123',
        image: 'sandhya_profile.jpg',
      ),
    );

    // Assert
    expect(result, equals(const Right(null)));
    verify(() => repository.registerStudent(any())).called(1);
    verifyNoMoreInteractions(repository);
  });
}
