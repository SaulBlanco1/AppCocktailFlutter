import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_storage_constants.dart';

class CloudIngredient {
  List<Ingredients> ingredients;

  CloudIngredient({required this.ingredients});

  CloudIngredient.fromJson(Map<String, dynamic> json) : ingredients = [] {
    if (json['ingredients'] != null) {
      json['ingredients'].forEach((v) {
        ingredients.add(Ingredients.fromJson(v));
      });
    }
  }
}

class Ingredients {
  late String idIngredient;
  String? ownerUserid;
  String? strIngredient;
  String? strDescription;
  String? strType;
  String? strAlcohol;
  String? strABV;

  Ingredients(
      {required this.idIngredient,
      this.ownerUserid,
      this.strIngredient,
      this.strDescription,
      this.strType,
      this.strAlcohol,
      this.strABV});

  Ingredients.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    idIngredient = snapshot.data()[idOfIngredient];
    ownerUserid = snapshot.data()[ownerUserIdFieldName];
    strIngredient = snapshot.data()[nameIngredient];
    strDescription = snapshot.data()[descriptionIngr];
    strType = snapshot.data()[typeIngr];
    strAlcohol = snapshot.data()[isAlcohol];
    strABV = snapshot.data()[gradesAlc];
  }

  Ingredients.fromJson(Map<String, dynamic> json) {
    idIngredient = json['idIngredient'];
    strIngredient = json['strIngredient'];
    strDescription = json['strDescription'];
    strType = json['strType'];
    strAlcohol = json['strAlcohol'];
    strABV = json['strABV'];
  }
}
