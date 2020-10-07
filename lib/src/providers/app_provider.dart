import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  bool isLoading = false;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void toggleLoading() {
    loading = !loading;
  }

  void changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
