import 'package:flutter/material.dart';

class SlidingPanelTopController with ChangeNotifier {
  bool _isPanelOpen = false;

  bool get isPanelOpen => _isPanelOpen;

  void open() {
    _isPanelOpen = true;
    notifyListeners();
  }

  void close() {
    _isPanelOpen = false;
    notifyListeners();
  }

  void toggle() {
    if (_isPanelOpen) {
      close();
    } else {
      open();
    }
  }
}
