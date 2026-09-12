import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get initialStatus async =>
      (await _connectivity.checkConnectivity()).any(_isConnected);

  @override
  Stream<bool> get status => _connectivity.onConnectivityChanged.map(
    (results) => results.any(_isConnected),
  );

  bool _isConnected(ConnectivityResult result) =>
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet;
}
