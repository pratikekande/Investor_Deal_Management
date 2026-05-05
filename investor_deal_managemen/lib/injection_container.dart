import 'package:get_it/get_it.dart';
import 'package:investor_deal_managemen/data/datasources/auth_local_datasource.dart';
import 'package:investor_deal_managemen/data/datasources/database_helper.dart';
import 'package:investor_deal_managemen/data/datasources/deal_local_datasource.dart';
import 'package:investor_deal_managemen/data/datasources/interest_local_datasource.dart';
import 'package:investor_deal_managemen/data/datasources/shared_preferences.dart';
import 'package:investor_deal_managemen/data/repository/auth_repository_impl.dart';
import 'package:investor_deal_managemen/data/repository/deal_repository_impl.dart';
import 'package:investor_deal_managemen/data/repository/interest_repository_impl.dart';
import 'package:investor_deal_managemen/domain/repositories/auth_repository.dart';
import 'package:investor_deal_managemen/domain/repositories/deal_repository.dart';
import 'package:investor_deal_managemen/domain/repositories/interest_repository.dart';
import 'package:investor_deal_managemen/domain/usecases/auth_usecases.dart';
import 'package:investor_deal_managemen/domain/usecases/deals_usecases.dart';
import 'package:investor_deal_managemen/presentation/bloc/auth/auth_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/deal/deal_bloc.dart';
import 'package:investor_deal_managemen/presentation/bloc/interest/interest_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Step 1: Core (no dependencies) ──
  sl.registerSingleton(DatabaseHelper());
  sl.registerSingleton(SessionManager());

  // ── Step 2: Datasources ──
  sl.registerSingleton<AuthLocalDatasource>(AuthLocalDatasourceImpl(sl()));
  sl.registerSingleton<DealLocalDatasource>(DealLocalDatasourceImpl(sl()));
  sl.registerSingleton<InterestLocalDatasource>(
      InterestLocalDatasourceImpl(sl()));

  // ── Step 3: Repositories ──
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(datasource: sl(), sessionManager: sl()),
  );
  sl.registerSingleton<DealRepository>(
      DealRepositoryImpl(datasource: sl()));
  sl.registerSingleton<InterestRepository>(
      InterestRepositoryImpl(datasource: sl()));

  // ── Step 4: Auth Usecases ──
  sl.registerFactory(() => SignInUsecase(sl()));
  sl.registerFactory(() => SignUpUsecase(sl()));
  sl.registerFactory(() => GetSessionUsecase(sl()));
  sl.registerFactory(() => SignOutUsecase(sl()));

  // ── Step 5: Deal Usecases ──
  sl.registerFactory(() => GetAllDealsUsecase(sl()));
  sl.registerFactory(() => GetMyDealsUsecase(sl()));
  sl.registerFactory(() => PostDealUsecase(sl()));
  sl.registerFactory(() => UpdateDealStatusUsecase(sl()));
  sl.registerFactory(() => DeleteDealUsecase(sl()));

  // ── Step 6: Interest Usecases ──
  sl.registerFactory(() => GetMyInterestsUsecase(sl()));
  sl.registerFactory(() => ExpressInterestUsecase(sl()));
  sl.registerFactory(() => RemoveInterestUsecase(sl()));
  sl.registerFactory(() => CheckInterestUsecase(sl()));

  // ── Step 7: BLoCs ──
  sl.registerFactory(
    () => AuthBloc(
      signInUsecase: sl(),
      signUpUsecase: sl(),
      getSessionUsecase: sl(),
      signOutUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => DealBloc(
      getAllDealsUsecase: sl(),
      getMyDealsUsecase: sl(),
      postDealUsecase: sl(),
      updateDealStatusUsecase: sl(),
      deleteDealUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => InterestBloc(
      getMyInterestsUsecase: sl(),
      expressInterestUsecase: sl(),
      removeInterestUsecase: sl(),
      checkInterestUsecase: sl(),
    ),
  );
}