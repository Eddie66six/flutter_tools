import 'package:flutter/foundation.dart';

class StepNotifier extends ChangeNotifier  {
  // GitStepNotifier._();
  // static GitStepNotifier _instance;
  // static GitStepNotifier get to => _instance ??= GitStepNotifier._();

  String? mesage;
  bool inProgresss = false;

  void setInProgresssValue(bool value) {
    inProgresss = value;
    notifyListeners();
  }

  void setMesageValue(String step) {
    mesage = step;
    notifyListeners();
  }
}