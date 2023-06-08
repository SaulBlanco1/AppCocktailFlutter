import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cocktail/dataclasses/cocktail_list_drinks.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_ingredient.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final drinks = FirebaseFirestore.instance.collection('favDrinks');
  final ingredients = FirebaseFirestore.instance.collection('favIngredients');

  Future<void> deleteDrinkFromFavs({required String drinkId}) async {
    Query queryToDelete = drinks.where('idDrink', isEqualTo: drinkId);

    await queryToDelete.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> deleteDrinkFromIngredientsFavs(
      {required String idIngredient}) async {
    Query queryToDelete =
        ingredients.where('idIngredient', isEqualTo: idIngredient);

    await queryToDelete.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Stream<Iterable<CloudDrink>> getAllFavs({required String ownerUserId}) {
    final allDrinks = drinks
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudDrink.fromSnapshot(doc)));
    return allDrinks;
  }

  Stream<Iterable<Ingredients>> getAllIngredientsFavs(
      {required String ownerUserId}) {
    final allIngredients = ingredients
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => Ingredients.fromSnapshot(doc)));
    return allIngredients;
  }

  Future<List<String>> getAllIngredientsIDsFavs(
      {required String ownerUserId}) async {
    List<String> idsFavs = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await ingredients.get();
    List<Ingredients> data =
        querySnapshot.docs.map((doc) => Ingredients.fromSnapshot(doc)).toList();

    List<Ingredients> filteredData = data
        .where((ingredients) => ingredients.ownerUserid == ownerUserId)
        .toList();

    for (Ingredients ingredient in filteredData) {
      idsFavs.add(ingredient.idIngredient);
    }
    return idsFavs;
  }

  Future<List<String>> getAllIDsFavs({required String ownerUserId}) async {
    List<String> idsFavs = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await drinks.get();
    List<CloudDrink> data =
        querySnapshot.docs.map((doc) => CloudDrink.fromSnapshot(doc)).toList();

    List<CloudDrink> filteredData =
        data.where((drink) => drink.ownerUserid == ownerUserId).toList();

    for (CloudDrink drink in filteredData) {
      idsFavs.add(drink.idDrink);
    }
    return idsFavs;
  }

  Future<void> addIngredienttoFav(
      {required String ownerUserId,
      required Ingredients ingredientToAdd}) async {
    final document = await ingredients.add({
      ownerUserIdFieldName: ownerUserId,
      idOfIngredient: ingredientToAdd.idIngredient,
      nameIngredient: ingredientToAdd.strIngredient,
      descriptionIngr: ingredientToAdd.strDescription,
      typeIngr: ingredientToAdd.strType,
      isAlcohol: ingredientToAdd.strAlcohol,
      gradesAlc: ingredientToAdd.strABV,
    });

    await document.get();
  }

  Future<void> addDrinktoFav(
      {required String ownerUserId, required CloudDrink drinkToAdd}) async {
    final document = await drinks.add({
      ownerUserIdFieldName: ownerUserId,
      drinkId: drinkToAdd.idDrink,
      isAlcoholic: drinkToAdd.strAlcoholic,
      categoryDrink: drinkToAdd.strCategory,
      nameDrink: drinkToAdd.strDrink,
      imageDrink: drinkToAdd.strDrinkThumb,
      glassType: drinkToAdd.strGlass,
      ingr1: drinkToAdd.strIngredient1,
      ingr2: drinkToAdd.strIngredient2,
      ingr3: drinkToAdd.strIngredient3,
      instruc: drinkToAdd.strInstructions,
    });

    await document.get();
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
