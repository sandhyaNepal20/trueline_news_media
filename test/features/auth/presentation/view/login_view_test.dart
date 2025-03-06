import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trueline_news_media/features/auth/presentation/view/login_view.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/login/login_bloc.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  // Helper widget to load the login view with the BlocProvider
  Widget loadLoginView() {
    return BlocProvider<LoginBloc>(
      create: (_) => loginBloc,
      child: const MaterialApp(
        home: LoginView(),
      ),
    );
  }

  testWidgets('check for the text in login UI', (tester) async {
    when(() => loginBloc.state).thenReturn(LoginState.initial());
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Verify that the sign in button with the text "Sign in" exists.
    final result = find.widgetWithText(ElevatedButton, 'Sign in');
    expect(result, findsOneWidget);
  });

  testWidgets('check for the email and password input', (tester) async {
    when(() => loginBloc.state).thenReturn(LoginState.initial());
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).at(0), 'sandhya@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'sandhya123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('sandhya@gmail.com'), findsOneWidget);
    expect(find.text('sandhya123'), findsOneWidget);
  });

  testWidgets('check for the validator messages', (tester) async {
    when(() => loginBloc.state).thenReturn(LoginState.initial());
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Leave both fields empty to trigger validation.
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');

    // Tap the sign in button.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    // Expect validation messages to appear.
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('login success', (tester) async {
    when(() => loginBloc.state)
        .thenReturn(LoginState(isLoading: false, isSuccess: true));

    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).at(0), 'sandhya@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'sandhya123');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(loginBloc.state.isSuccess, true);
  });
}
