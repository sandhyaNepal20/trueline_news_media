import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/upload_image_usecase.dart';

import 'login_user_usecase_test.dart';

// Mock Repository

void main() {
  late MockAuthRepository repository;
  late UploadImageUsecase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = UploadImageUsecase(repository);
  });

  final tFile = File(
      'path/to/file.jpg'); // Sample file (in real use case it should be a valid file)
  const tUploadResult =
      'image_url_from_server'; // Example result of uploading an image

  test('should upload image and return the image URL', () async {
    // Arrange
    when(() => repository.uploadProfilePicture(tFile))
        .thenAnswer((_) async => const Right(tUploadResult));

    // Act
    final result = await usecase(UploadImageParams(file: tFile));

    // Assert
    expect(
        result,
        const Right(
            tUploadResult)); // Verifies the result is the expected image URL
    verify(() => repository.uploadProfilePicture(tFile))
        .called(1); // Verifies the upload method was called once
  });

  test('should return failure if image upload fails', () async {
    // Arrange
    const failure = ApiFailure(message: 'Image upload failed');
    when(() => repository.uploadProfilePicture(tFile))
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(UploadImageParams(file: tFile));

    // Assert
    expect(result,
        const Left(failure)); // Verifies the result is the expected failure
    verify(() => repository.uploadProfilePicture(tFile))
        .called(1); // Verifies the upload method was called once
  });
}
