import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/mock_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/connectivity/data/repositories/connectivity_repository_impl.dart';
import '../../features/connectivity/domain/repositories/connectivity_repository.dart';
import '../../features/connectivity/presentation/bloc/connectivity_bloc.dart';
import '../../features/shelf/data/repositories/shelf_repository_impl.dart';
import '../../features/shelf/domain/repositories/shelf_repository.dart';
import '../../features/shelf/presentation/bloc/shelf_bloc.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<MockAuthDataSource>(MockAuthDataSource.new)
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()))
    ..registerLazySingleton<ShelfRepository>(ShelfRepositoryImpl.new)
    ..registerLazySingleton<ConnectivityRepository>(
      () => ConnectivityRepositoryImpl(Connectivity()),
    )
    ..registerFactory<AuthBloc>(() => AuthBloc(repository: getIt()))
    ..registerFactory<ConnectivityBloc>(
      () => ConnectivityBloc(repository: getIt()),
    )
    ..registerFactoryParam<ShelfBloc, AuthBloc, void>(
      (authBloc, _) => ShelfBloc(repository: getIt(), authBloc: authBloc),
    );
}
