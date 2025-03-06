import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/features/auth/presentation/view/register_view.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';

class MockSignupBloc extends MockBloc<SignupEvent, SignupState>
    implements SignupBloc {}

// Create a fake state to register as fallback.
class FakeSignupState extends Fake implements SignupState {}

void main() {
  late MockSignupBloc signupBloc;
  setUpAll(() {});

  setUp(() {
    signupBloc = MockSignupBloc();
  });
  Widget loadRegisterView() {
    return BlocProvider<SignupBloc>(
      create: (_) => signupBloc,
      child: const MaterialApp(
        home: RegisterView(),
      ),
    );
  }

  group('RegisterView Widget Tests', () {
    testWidgets(
        'check for full name, email, password, and confirm password inputs',
        (WidgetTester tester) async {
      when(() => signupBloc.state).thenReturn(const SignupState.initial());
      await tester.pumpWidget(loadRegisterView());
      await tester.pumpAndSettle();

      // Assuming order: 0 - Full Name, 1 - Email, 2 - Password, 3 - Confirm Password.
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'sandhya@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password');
      await tester.enterText(find.byType(TextFormField).at(3), 'password');

      // Tap the "Sign Up" button to trigger form submission.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pumpAndSettle();

      // Verify that the entered texts appear in the widget tree.
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('sandhya@gmail.com'), findsOneWidget);
      // "password" should appear in both password fields.
      expect(find.text('password'), findsNWidgets(2));
    });

    // testWidgets('check for validator messages when inputs are invalid',
    //     (WidgetTester tester) async {
    //   when(() => signupBloc.state).thenReturn(const SignupState.initial());
    //   await tester.pumpWidget(loadRegisterView());
    //   await tester.pumpAndSettle();

    //   // Input invalid values:
    //   // Empty full name, invalid email, too short password, and mismatched confirm password.
    //   await tester.enterText(find.byType(TextFormField).at(0), '');
    //   await tester.enterText(find.byType(TextFormField).at(1), 'invalidemail');
    //   await tester.enterText(find.byType(TextFormField).at(2), '123');
    //   await tester.enterText(find.byType(TextFormField).at(3), '321');

    //   // Tap the "Sign Up" button.
    //   await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    //   await tester.pumpAndSettle();

    //   // Expect appropriate validation error messages.
    //   expect(find.text('Please enter your full name'), findsOneWidget);
    //   expect(find.text('Please enter a valid email'), findsOneWidget);
    //   expect(
    //       find.text('Password must be at least 6 characters'), findsOneWidget);
    //   expect(find.text('Passwords do not match'), findsOneWidget);
    // });
  });
}
