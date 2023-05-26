import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';

class FavListProv with ChangeNotifier {
  late List<CloudDrink> _listDrinksFavs;

  List<CloudDrink> get getDrink => _listDrinksFavs;

  void setitemDetail(List<CloudDrink> listfavDrinks) {
    _listDrinksFavs = listfavDrinks;
    notifyListeners();
  }
}
