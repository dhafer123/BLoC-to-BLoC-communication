import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_to_bloc/features/auth/domain/entities/user.dart';
import 'package:bloc_to_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:bloc_to_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_to_bloc/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:bloc_to_bloc/features/connectivity/domain/repositories/connectivity_repository.dart';
import 'package:bloc_to_bloc/features/connectivity/presentation/bloc/connectivity_bloc.dart';
import 'package:bloc_to_bloc/features/shelf/data/repositories/shelf_repository_impl.dart';
import 'package:bloc_to_bloc/features/shelf/presentation/bloc/shelf_bloc.dart';

class _AuthRepository implements AuthRepository {
  @override
  Future<User> signIn() async => const User(id: 'id', name: 'Reader');

  @override
  Future<void> signOut() async {}
}

class _ConnectivityRepository implements ConnectivityRepository {
  @override
  Future<bool> get initialStatus async => true;

  @override
  Stream<bool> get status => const Stream<bool>.empty();
}

void main() {
  test('blocks checkout when connectivity changes offline', () async {
    final auth = AuthBloc(repository: _AuthRepository());
    final shelf = ShelfBloc(repository: ShelfRepositoryImpl(), authBloc: auth);
    final connectivity = ConnectivityBloc(
      repository: _ConnectivityRepository(),
    );
    final checkout = CheckoutBloc(
      shelfBloc: shelf,
      connectivityBloc: connectivity,
    );

    final states = expectLater(
      checkout.stream,
      emitsInOrder([
        const CheckoutState(isOnline: true, itemCount: 1),
        const CheckoutState(isOnline: false, itemCount: 1),
      ]),
    );
    shelf.add(ShelfBookAdded(ShelfRepositoryImpl().getCatalog().first));
    await Future<void>.delayed(const Duration(milliseconds: 10));
    connectivity.add(const ConnectivityChanged(false));

    await states;
    await checkout.close();
    await connectivity.close();
    await shelf.close();
    await auth.close();
  });
}
