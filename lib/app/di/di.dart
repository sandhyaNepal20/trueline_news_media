import 'package:get_it/get_it.dart';
import 'package:trueline_news_media/core/network/hive_service.dart';
import 'package:trueline_news_media/features/auth/data/data_source/local_data_source/auth_local_datasource.dart';
import 'package:trueline_news_media/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:trueline_news_media/features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'package:trueline_news_media/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // First initialize hive service
  await _initHiveService();

  // Initialize the login dependencies first because SplashCubit depends on LoginBloc
  await _initLoginDependencies();

  // Initialize the onboarding cubit and other dependencies
  await _initSplashDependencies();
  await _initOnboardingDependencies();
  await _initRegisterDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initLoginDependencies() {
  // Register the LoginUseCase
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthLocalRepository>()),
  );

  // Register LoginBloc, which depends on LoginUseCase and SignupBloc
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      signupBloc: getIt<SignupBloc>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}

_initSplashDependencies() {
  // Register SplashCubit, which depends on LoginBloc
  getIt.registerFactory<SplashCubit>(() => SplashCubit(getIt<LoginBloc>()));
}

_initOnboardingDependencies() {
  // Register OnboardingCubit
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());
}

_initRegisterDependencies() {
  // Register AuthLocalDataSource, which depends on HiveService
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  // Register AuthLocalRepository, which depends on AuthLocalDataSource
  getIt.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  // Register RegisterUserUseCase, which depends on AuthLocalRepository
  getIt.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(getIt<AuthLocalRepository>()),
  );

  // Register SignupBloc, which depends on RegisterUserUseCase
  getIt.registerFactory<SignupBloc>(
    () => SignupBloc(registerUseCase: getIt<RegisterUserUseCase>()),
  );
}
