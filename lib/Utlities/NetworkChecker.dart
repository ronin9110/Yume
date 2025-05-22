import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkChecker extends StatefulWidget {
  final Widget child;
  const NetworkChecker({
    super.key,
    required this.child,
  });

  @override
  State<NetworkChecker> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NetworkChecker> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          _connectionStatus.length,
          (index) {
            if (_connectionStatus[index] == ConnectivityResult.none) {
              return Center(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Icon(
                        Icons.signal_wifi_connected_no_internet_4_outlined,
                        size: 70,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "Please Check Internet Connection\nMove to Local Media or\nRestart The App!",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return widget.child;
            }
          },
        ),
      ),
    );
  }
}
