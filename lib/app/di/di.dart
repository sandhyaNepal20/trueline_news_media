import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trueline_news_media/app/shared_prefs/token_shared_prefs.dart';
import 'package:trueline_news_media/core/network/api_service.dart';
import 'package:trueline_news_media/core/network/hive_service.dart';
import 'package:trueline_news_media/features/auth/data/data_source/local_data_source/auth_local_datasource.dart';
import 'package:trueline_news_media/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:trueline_news_media/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:trueline_news_media/features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:trueline_news_media/features/auth/domain/use_case/upload_image_usecase.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:trueline_news_media/features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'package:trueline_news_media/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // First initialize hive service
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  await _initSplashDependencies();
  await _initOnboardingDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initSplashDependencies() {
  // Register SplashCubit, which depends on LoginBloc
  getIt.registerFactory<SplashCubit>(() => SplashCubit(getIt<LoginBloc>()));
}

_initOnboardingDependencies() {
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit());
}

_initRegisterDependencies() {
// =========================== Data Source ===========================

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // =========================== Repository ===========================

  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );
  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(
      getIt<AuthRemoteRepository>(),
    ),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(
      getIt<AuthRemoteRepository>(),
    ),
  );

  getIt.registerFactory<SignupBloc>(
    () => SignupBloc(
      registerUseCase: getIt(),
      uploadImageUsecase: getIt(),
    ),
  );
}

_initLoginDependencies() async {
  // =========================== Token Shared Preferences ===========================
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthLocalRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      signupBloc: getIt<SignupBloc>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}
