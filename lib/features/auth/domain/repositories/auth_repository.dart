import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn();
  Future<void> signOut();
}
