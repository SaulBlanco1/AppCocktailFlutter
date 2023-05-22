class ListOfDrinks {
  List<Drinks> drinks;

  ListOfDrinks({required this.drinks});

  ListOfDrinks.fromJson(Map<String, dynamic> json) : drinks = [] {
    if (json['drinks'] != null) {
      json['drinks'].forEach((v) {
        drinks.add(Drinks.fromJson(v));
      });
    }
  }
}

class Drinks {
  late String idDrink;
  late String strDrink;
  String? strCategory;
  String? strAlcoholic;
  String? strGlass;
  late String strDrinkThumb;

  Drinks({
    required this.idDrink,
    required this.strDrink,
    this.strCategory,
    this.strAlcoholic,
    this.strGlass,
    required this.strDrinkThumb,
  });

  Drinks.fromJson(Map<String, dynamic> json) {
    idDrink = json['idDrink'];
    strDrink = json['strDrink'];
    strCategory = json['strCategory'];
    strAlcoholic = json['strAlcoholic'];
    strGlass = json['strGlass'];
    strDrinkThumb = json['strDrinkThumb'];
  }
}
