import 'package:flutter/material.dart';

import '../dataclasses/cocktail_list_drinks.dart';

class ItemDetail with ChangeNotifier {
  late Drinks _drinktoDetail;

  Drinks get getDrink => _drinktoDetail;

  void setitemDetail(Drinks drinktoShow) {
    _drinktoDetail = drinktoShow;
    notifyListeners();
  }
}
