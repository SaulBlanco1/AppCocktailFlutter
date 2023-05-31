import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';

class ItemDetail with ChangeNotifier {
  late CloudDrink _drinktoDetail;

  CloudDrink get getDrink => _drinktoDetail;

  void setitemDetail(CloudDrink drinktoShow) {
    _drinktoDetail = drinktoShow;
    notifyListeners();
  }
}
