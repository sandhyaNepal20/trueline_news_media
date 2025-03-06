import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/auth/domain/entity/auth_entity.dart';
import 'package:trueline_news_media/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String? image;
  final String password;

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.password,
    this.image,
  });

  //intial constructor

  const RegisterUserParams.initial({
    required this.fullName,
    required this.email,
    required this.password,
    this.image,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

class RegisterUserUseCase {
  final IAuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final authEntity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      image: params.image,
    );
    return repository.registerStudent(authEntity);
  }
}
