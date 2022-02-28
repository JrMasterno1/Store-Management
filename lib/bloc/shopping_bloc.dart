

import 'dart:async';

class CartBLoC {
  StreamController _streamController = StreamController();
  Stream get stream => _streamController.stream.asBroadcastStream();
  StreamSink get sink => _streamController.sink;

  CartBLoC();

  Future clearScreen() async {

  }
}