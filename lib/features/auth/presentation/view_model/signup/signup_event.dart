part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesAndBatches extends SignupEvent {}

class UploadImage extends SignupEvent {
  final File file;

  const UploadImage({
    required this.file,
  });
}

class RegisterUser extends SignupEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String password;
  final String? image;

  const RegisterUser({
    required this.context,
    required this.fullName,
    required this.email,
    required this.password,
    this.image,
  });
}
