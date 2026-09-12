import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_to_bloc/features/auth/domain/entities/user.dart';
import 'package:bloc_to_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:bloc_to_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_to_bloc/features/shelf/data/repositories/shelf_repository_impl.dart';
import 'package:bloc_to_bloc/features/shelf/domain/entities/book.dart';
import 'package:bloc_to_bloc/features/shelf/presentation/bloc/shelf_bloc.dart';

class _AuthRepository implements AuthRepository {
  @override
  Future<User> signIn() async => const User(id: 'id', name: 'Reader');

  @override
  Future<void> signOut() async {}
}

void main() {
  group('ShelfBloc', () {
    late AuthBloc authBloc;

    setUp(() => authBloc = AuthBloc(repository: _AuthRepository()));
    tearDown(() => authBloc.close());

    blocTest<ShelfBloc, List<Book>>(
      'clears its items when AuthBloc signs out',
      build: () =>
          ShelfBloc(repository: ShelfRepositoryImpl(), authBloc: authBloc),
      act: (shelfBloc) async {
        final book = ShelfRepositoryImpl().getCatalog().first;
        shelfBloc.add(ShelfLoaded());
        await Future<void>.delayed(Duration.zero);
        shelfBloc.add(ShelfBookAdded(book));
        await Future<void>.delayed(Duration.zero);
        authBloc.add(AuthSignOutRequested());
      },
      expect: () => [
        const [],
        [ShelfRepositoryImpl().getCatalog().first],
        const [],
      ],
    );
  });
}
