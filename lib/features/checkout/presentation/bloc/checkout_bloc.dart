import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../connectivity/presentation/bloc/connectivity_bloc.dart';
import '../../../shelf/domain/entities/book.dart';
import '../../../shelf/presentation/bloc/shelf_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

final class CheckoutDependenciesChanged extends CheckoutEvent {}

final class CheckoutRequested extends CheckoutEvent {}

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.isOnline,
    required this.itemCount,
    this.isSubmitting = false,
    this.completed = false,
  });

  const CheckoutState.initial()
    : isOnline = true,
      itemCount = 0,
      isSubmitting = false,
      completed = false;

  final bool isOnline;
  final int itemCount;
  final bool isSubmitting;
  final bool completed;

  bool get canCheckout => isOnline && itemCount > 0 && !isSubmitting;
  String get reason {
    if (!isOnline) return 'Reconnect to borrow your shelf.';
    if (itemCount == 0) return 'Add a book to your shelf first.';
    return 'Ready to borrow';
  }

  CheckoutState copyWith({
    bool? isOnline,
    int? itemCount,
    bool? isSubmitting,
    bool? completed,
  }) => CheckoutState(
    isOnline: isOnline ?? this.isOnline,
    itemCount: itemCount ?? this.itemCount,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    completed: completed ?? this.completed,
  );

  @override
  List<Object> get props => [isOnline, itemCount, isSubmitting, completed];
}

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc({
    required ShelfBloc shelfBloc,
    required ConnectivityBloc connectivityBloc,
  }) : _shelfBloc = shelfBloc,
       _connectivityBloc = connectivityBloc,
       super(const CheckoutState.initial()) {
    on<CheckoutDependenciesChanged>((event, emit) => emit(_currentState()));
    on<CheckoutRequested>(_onCheckoutRequested);
    _shelfSubscription = _shelfBloc.stream.listen(
      (_) => add(CheckoutDependenciesChanged()),
    );
    _connectivitySubscription = _connectivityBloc.stream.listen(
      (_) => add(CheckoutDependenciesChanged()),
    );
  }

  final ShelfBloc _shelfBloc;
  final ConnectivityBloc _connectivityBloc;
  late final StreamSubscription<List<Book>> _shelfSubscription;
  late final StreamSubscription<bool> _connectivitySubscription;

  CheckoutState _currentState() => CheckoutState(
    isOnline: _connectivityBloc.state,
    itemCount: _shelfBloc.state.length,
  );

  Future<void> _onCheckoutRequested(
    CheckoutRequested event,
    Emitter<CheckoutState> emit,
  ) async {
    if (!state.canCheckout) return;
    emit(state.copyWith(isSubmitting: true));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(isSubmitting: false, completed: true));
  }

  @override
  Future<void> close() async {
    await _shelfSubscription.cancel();
    await _connectivitySubscription.cancel();
    return super.close();
  }
}
