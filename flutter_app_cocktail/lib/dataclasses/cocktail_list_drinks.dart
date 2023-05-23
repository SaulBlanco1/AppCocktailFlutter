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
  String? strInstructions;
  String? strIngredient1;
  String? strIngredient2;
  String? strIngredient3;

  Drinks({
    required this.idDrink,
    required this.strDrink,
    this.strCategory,
    this.strAlcoholic,
    this.strGlass,
    required this.strDrinkThumb,
    this.strInstructions,
    this.strIngredient1,
    this.strIngredient2,
    this.strIngredient3,
  });

  Drinks.fromJson(Map<String, dynamic> json) {
    idDrink = json['idDrink'];
    strDrink = json['strDrink'];
    strCategory = json['strCategory'];
    strAlcoholic = json['strAlcoholic'];
    strGlass = json['strGlass'];
    strDrinkThumb = json['strDrinkThumb'];
    strInstructions = json['strInstructions'];
    strIngredient1 = json['strIngredient1'];
    strIngredient2 = json['strIngredient2'];
    strIngredient3 = json['strIngredient3'];
  }
}
