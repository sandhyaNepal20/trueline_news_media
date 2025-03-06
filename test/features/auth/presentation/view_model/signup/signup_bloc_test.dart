// test/signup_bloc_widget_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';

/// Mocks for the use cases.
class MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

class MockUploadImageUsecase extends Mock implements UploadImageUsecase {}

/// A simple widget that triggers the RegisterUser event on button press.
class TestSignupWidget extends StatelessWidget {
  const TestSignupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // A button that dispatches the RegisterUser event when tapped.
    return Scaffold(
      appBar: AppBar(title: const Text('Signup Test')),
      body: Center(
        child: ElevatedButton(
          key: const Key('signupButton'),
          onPressed: () {
            BlocProvider.of<SignupBloc>(context).add(
              RegisterUser(
                fullName: 'Test User',
                email: 'test@test.com',
                password: 'password',
                context: context,
              ),
            );
          },
          child: const Text('Signup'),
        ),
      ),
    );
  }
}

void main() {
  late MockRegisterUserUseCase mockRegisterUserUseCase;
  late MockUploadImageUsecase mockUploadImageUsecase;

  // Register fallback values for RegisterUserParams. This is needed so that
  // mocktail knows how to handle any(RegisterUserParams) calls.
  setUpAll(() {
    registerFallbackValue(
      const RegisterUserParams(
        fullName: '',
        email: '',
        image: '',
        password: '',
      ),
    );
  });

  setUp(() {
    mockRegisterUserUseCase = MockRegisterUserUseCase();
    mockUploadImageUsecase = MockUploadImageUsecase();
  });

  group('SignupBloc Widget Tests', () {
    testWidgets('shows success snackbar on successful registration',
        (WidgetTester tester) async {
      // Simulate a successful registration.
      when(() => mockRegisterUserUseCase.call(any<RegisterUserParams>()))
          .thenAnswer((_) async => const Right('success'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SignupBloc>(
            create: (context) => SignupBloc(
              registerUseCase: mockRegisterUserUseCase,
              uploadImageUsecase: mockUploadImageUsecase,
            ),
            child: const TestSignupWidget(),
          ),
        ),
      );

      // Tap the signup button.
      await tester.tap(find.byKey(const Key('signupButton')));
      await tester.pumpAndSettle();

      // Expect a snackbar with the "Registration Successful" message.
      expect(find.text("Registration Successful"), findsOneWidget);
    });

    testWidgets('does not show success snackbar on registration failure',
        (WidgetTester tester) async {
      // Simulate a registration failure.
      when(() => mockRegisterUserUseCase.call(any<RegisterUserParams>()))
          .thenAnswer((_) async =>
              const Left(ApiFailure(message: 'Registration failed')));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SignupBloc>(
            create: (context) => SignupBloc(
              registerUseCase: mockRegisterUserUseCase,
              uploadImageUsecase: mockUploadImageUsecase,
            ),
            child: const TestSignupWidget(),
          ),
        ),
      );

      // Tap the signup button.
      await tester.tap(find.byKey(const Key('signupButton')));
      await tester.pumpAndSettle();

      // Since registration failed, the snackbar should not be shown.
      expect(find.text("Registration Successful"), findsNothing);
    });
  });
}
