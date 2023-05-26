import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cocktail/dataclasses/cocktail_list_drinks.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final drinks = FirebaseFirestore.instance.collection('favDrinks');

  Future<void> deleteDrinkFromFavs({required String documentId}) async {
    try {
      await drinks.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Stream<Iterable<CloudDrink>> getAllFavs({required String ownerUserId}) {
    final allDrinks = drinks
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudDrink.fromSnapshot(doc)));
    return allDrinks;
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
