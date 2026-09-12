import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/shelf_repository.dart';

sealed class ShelfEvent extends Equatable {
  const ShelfEvent();

  @override
  List<Object?> get props => [];
}

final class ShelfLoaded extends ShelfEvent {}

final class ShelfBookAdded extends ShelfEvent {
  const ShelfBookAdded(this.book);

  final Book book;

  @override
  List<Object> get props => [book];
}

final class ShelfBookRemoved extends ShelfEvent {
  const ShelfBookRemoved(this.book);

  final Book book;

  @override
  List<Object> get props => [book];
}

final class ShelfCleared extends ShelfEvent {}

class ShelfBloc extends Bloc<ShelfEvent, List<Book>> {
  ShelfBloc({required ShelfRepository repository, required AuthBloc authBloc})
    : _repository = repository,
      _authBloc = authBloc,
      super(const []) {
    on<ShelfLoaded>((event, emit) => emit(const []));
    on<ShelfBookAdded>(_onBookAdded);
    on<ShelfBookRemoved>(_onBookRemoved);
    on<ShelfCleared>((event, emit) => emit(const []));
    _authSubscription = _authBloc.stream.listen((authState) {
      if (authState is AuthSignedOut) add(ShelfCleared());
    });
  }

  final ShelfRepository _repository;
  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authSubscription;

  List<Book> get catalog => _repository.getCatalog();

  void _onBookAdded(ShelfBookAdded event, Emitter<List<Book>> emit) {
    if (!state.any((book) => book.id == event.book.id)) {
      emit([...state, event.book]);
    }
  }

  void _onBookRemoved(ShelfBookRemoved event, Emitter<List<Book>> emit) {
    emit(state.where((book) => book.id != event.book.id).toList());
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    return super.close();
  }
}
