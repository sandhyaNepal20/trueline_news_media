import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/core/error/failure.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:trueline_news_media/features/home/presentation/view/home_view.dart';
import 'package:trueline_news_media/features/home/presentation/view_model/home_cubit.dart';

/// A fake for LoginParams needed by mocktail when using any()
class FakeLoginParams extends Fake implements LoginParams {}

/// Mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignupBloc extends Mock implements SignupBloc {}

class MockHomeCubit extends Mock implements HomeCubit {}

/// A simple NavigatorObserver mock to intercept navigation calls.
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

/// A simple widget to trigger login events.
class TestLoginWidget extends StatelessWidget {
  const TestLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // A button to trigger LoginUserEvent.
    return Scaffold(
      appBar: AppBar(title: const Text('Login Test')),
      body: Center(
        child: ElevatedButton(
          key: const Key('loginButton'),
          onPressed: () {
            // Dispatch a LoginUserEvent with test credentials.
            BlocProvider.of<LoginBloc>(context).add(
              LoginUserEvent(
                email: 'test@test.com',
                password: 'password',
                context: context,
              ),
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

void main() {
  // Register fallback values for custom types.
  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
  });

  late MockLoginUseCase mockLoginUseCase;
  late MockSignupBloc mockSignupBloc;
  late MockHomeCubit mockHomeCubit;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignupBloc = MockSignupBloc();
    mockHomeCubit = MockHomeCubit();

    // By default, simulate a successful login with a valid token.
    when(() => mockLoginUseCase(any()))
        .thenAnswer((_) async => const Right('valid.token'));
  });

  group('LoginBloc', () {
    testWidgets('navigates to HomeView on successful login', (tester) async {
      // Create a navigator observer to intercept navigation events.
      final navigatorObserver = MockNavigatorObserver();

      // Build our test app with the LoginBloc.
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(
                  signupBloc: mockSignupBloc,
                  homeCubit: mockHomeCubit,
                  loginUseCase: mockLoginUseCase,
                ),
              ),
            ],
            child: const TestLoginWidget(),
          ),
          navigatorObservers: [navigatorObserver],
        ),
      );

      // Tap on the login button.
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify that navigation occurred and HomeView is displayed.
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('shows error snackbar on login failure', (tester) async {
      // Override the use case to return a failure.
      when(() => mockLoginUseCase(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Invalid Credentials')),
      );

      // Build the test app.
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(
                  signupBloc: mockSignupBloc,
                  homeCubit: mockHomeCubit,
                  loginUseCase: mockLoginUseCase,
                ),
              ),
            ],
            child: const TestLoginWidget(),
          ),
        ),
      );

      // Tap the login button.
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump(); // Let the snackbar show

      // Expect a snackbar with the error message.
      expect(find.text("Invalid Credentials"), findsOneWidget);
    });
  });
}
