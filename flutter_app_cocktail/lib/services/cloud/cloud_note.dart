import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_storage_constants.dart';

class ListOfCloudDrinks {
  List<CloudDrink> drinks;

  ListOfCloudDrinks({required this.drinks});

  ListOfCloudDrinks.fromJson(Map<String, dynamic> json) : drinks = [] {
    if (json['drinks'] != null) {
      json['drinks'].forEach((v) {
        drinks.add(CloudDrink.fromJson(v));
      });
    }
  }
}

class CloudDrink {
  late String documentId;
  late String ownerUserid;
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

  CloudDrink({
    required this.documentId,
    required this.ownerUserid,
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

  CloudDrink.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserid = snapshot.data()[ownerUserIdFieldName],
        idDrink = snapshot.data()[drinkId],
        strDrink = snapshot.data()[nameDrink],
        strCategory = snapshot.data()[categoryDrink],
        strAlcoholic = snapshot.data()[isAlcoholic],
        strGlass = snapshot.data()[glassType],
        strDrinkThumb = snapshot.data()[imageDrink],
        strInstructions = snapshot.data()[instruc],
        strIngredient1 = snapshot.data()[ingr1],
        strIngredient2 = snapshot.data()[ingr2],
        strIngredient3 = snapshot.data()[ingr3] as String;

  CloudDrink.fromJson(Map<String, dynamic> json) {
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
