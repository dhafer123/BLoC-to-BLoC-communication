import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final MockAuthDataSource _dataSource;

  @override
  Future<User> signIn() => _dataSource.signIn();

  @override
  Future<void> signOut() => _dataSource.signOut();
}
