import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String password;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [userId, email, password];
}
