import 'package:flutter/cupertino.dart';

class SizedApp {
  SizedApp(this.displaySize){
    _instance = this;
    _isTheLowestResolution = displaySize.width <= 320;

  }
  static SizedApp? _instance;
  static SizedApp? get to => _instance;
  
  final Size displaySize;
  bool _isTheLowestResolution = false;

  double getForLowestResolution(double lowestResolution, double othersResolutions){
    return _isTheLowestResolution ? lowestResolution : othersResolutions;
  }
}