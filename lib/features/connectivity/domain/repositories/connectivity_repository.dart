import 'dart:async';

abstract class ConnectivityRepository {
  Future<bool> get initialStatus;
  Stream<bool> get status;
}
