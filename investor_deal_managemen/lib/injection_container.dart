import 'package:get_it/get_it.dart';
import 'package:investor_deal_managemen/data/datasources/auth_local_datasource.dart';
import 'package:investor_deal_managemen/data/datasources/database_helper.dart';
import 'package:investor_deal_managemen/data/datasources/shared_preferences.dart';
import 'package:investor_deal_managemen/data/repository/auth_repository_impl.dart';
import 'package:investor_deal_managemen/domain/repositories/auth_repository.dart';
import 'package:investor_deal_managemen/domain/usecases/get_session_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/sign_in_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/sign_out_usecase.dart';
import 'package:investor_deal_managemen/domain/usecases/sign_up_usecase.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Step 1 — Core (no dependencies)
  sl.registerSingleton(DatabaseHelper());
  sl.registerSingleton(SessionManager());

  // Step 2 — Datasource (needs DatabaseHelper)
  sl.registerSingleton<AuthLocalDatasource>(AuthLocalDatasourceImpl(sl()));

  // Step 3 — Repository (needs AuthLocalDatasource + SessionManager)
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(datasource: sl(), sessionManager: sl()),
  );

  // Step 4 — Usecases (need AuthRepository)
  sl.registerFactory(() => SignInUsecase(sl()));
  sl.registerFactory(() => SignUpUsecase(sl()));
  sl.registerFactory(() => GetSessionUsecase(sl()));
  sl.registerFactory(() => SignOutUsecase(sl()));

  // Step 5 — BLoC (needs all usecases)
  sl.registerFactory(
    () => AuthBloc(
      signInUsecase: sl(),
      signUpUsecase: sl(),
      getSessionUsecase: sl(),
      signOutUsecase: sl(),
    ),
  );
}