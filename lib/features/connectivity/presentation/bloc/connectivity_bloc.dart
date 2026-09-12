import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/connectivity_repository.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

final class ConnectivityStarted extends ConnectivityEvent {}

final class ConnectivityChanged extends ConnectivityEvent {
  const ConnectivityChanged(this.isOnline);

  final bool isOnline;

  @override
  List<Object> get props => [isOnline];
}

class ConnectivityBloc extends Bloc<ConnectivityEvent, bool> {
  ConnectivityBloc({required ConnectivityRepository repository})
    : _repository = repository,
      super(true) {
    on<ConnectivityStarted>(_onStarted);
    on<ConnectivityChanged>((event, emit) => emit(event.isOnline));
  }

  final ConnectivityRepository _repository;
  StreamSubscription<bool>? _subscription;

  Future<void> _onStarted(ConnectivityStarted event, Emitter<bool> emit) async {
    emit(await _repository.initialStatus);
    await _subscription?.cancel();
    _subscription = _repository.status.listen(
      (isOnline) => add(ConnectivityChanged(isOnline)),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
