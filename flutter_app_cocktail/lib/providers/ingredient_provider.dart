import 'package:flutter/material.dart';

class IngredientDetail with ChangeNotifier {
  late String _nameIngre;

  String get getIngre => _nameIngre;

  void setingreDetail(String ingretoShow) {
    _nameIngre = ingretoShow;
    notifyListeners();
  }
}
