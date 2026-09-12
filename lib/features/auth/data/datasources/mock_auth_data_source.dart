import '../../domain/entities/user.dart';

class MockAuthDataSource {
  Future<User> signIn() async =>
      const User(id: 'reader-01', name: 'Alex Morgan');

  Future<void> signOut() async {}
}
