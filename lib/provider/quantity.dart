import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientAmounts = [];
  int get currentNumber => _currentNumber;

  // initial ingredient amount
  void setBaseIngredientAmounts(List<double> amounts) {
    _baseIngredientAmounts = amounts;
    notifyListeners();
  }

  // update the ingredient amount
  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts
        .map<String>((amount) => (amount * _currentNumber).toStringAsFixed(1))
        .toList();
  }

  // increase serving
  void increaseQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  // decrease serving
  void decreaseQuantity() {
    if (_currentNumber > 1) {
      _currentNumber--;
    }
    notifyListeners();
  }
}
