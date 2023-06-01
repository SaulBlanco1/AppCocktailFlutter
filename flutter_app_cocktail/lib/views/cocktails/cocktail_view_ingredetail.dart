// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/providers/ingredient_provider.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/error_dialog.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/infofavs_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_cocktail/services/cloud/cloud_ingredient.dart';
import 'package:provider/provider.dart';

class IngredientView extends StatefulWidget {
  const IngredientView({super.key});

  @override
  State<IngredientView> createState() => _IngredientViewState();
}

class _IngredientViewState extends State<IngredientView> {
  String userCurrent = AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;
  late final CloudIngredient ingreToShow;
  bool itemIsFav = false;
  late String imageIngre;
  late List<String> idFavorites = [];

  Future<Ingredients> searchIngre(String ingreToSearch) async {
    final response = await http.get(Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?i=$ingreToSearch'));
    final Map<String, dynamic> parsedJson = json.decode(response.body);
    final infoIngre = CloudIngredient.fromJson(parsedJson);

    idFavorites =
        await _notesService.getAllIngredientsIDsFavs(ownerUserId: userCurrent);
    return infoIngre.ingredients[0];
  }

  Future<void> getidFavs() async {
    idFavorites =
        await _notesService.getAllIngredientsIDsFavs(ownerUserId: userCurrent);
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String ingrToShow = context.watch<IngredientDetail>().getIngre;
    return FutureBuilder(
      future: searchIngre(ingrToShow),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (idFavorites.contains(snapshot.data?.idIngredient)) {
              itemIsFav = true;
            }
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 236, 196, 78),
                  title: Text(snapshot.data?.strIngredient ?? '')),
              body: Column(
                children: [
                  Image.network(
                    'https://www.thecocktaildb.com/images/ingredients/$ingrToShow.png',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          minWidth: 320,
                          minHeight: 40.0,
                          maxWidth: 320,
                        ),
                        child: Card(
                          color: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                  color: Colors.grey, width: 1)),
                          child: Center(
                            child: Text(
                              snapshot.data?.strIngredient ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: itemIsFav
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                        onPressed: () async {
                          if (idFavorites
                              .contains(snapshot.data?.idIngredient)) {
                            await _notesService.deleteDrinkFromIngredientsFavs(
                                idIngredient:
                                    snapshot.data?.idIngredient ?? '');

                            await showInfoFavsDialog(
                                context, 'Ingredient eliminated from Favs.');
                          } else {
                            await _notesService.addIngredienttoFav(
                                ownerUserId: userCurrent,
                                ingredientToAdd: snapshot.data!);

                            await showInfoFavsDialog(
                                context, 'Ingredient added to Favs.');
                          }
                          await getidFavs();
                          setState(() {
                            itemIsFav = idFavorites
                                .contains(snapshot.data?.idIngredient);
                          });
                        },
                        color: Colors.red,
                      ),
                    ],
                  ),
                  Container(
                    constraints: const BoxConstraints(minHeight: 40.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Is Alcoholic?:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  snapshot.data?.strAlcohol ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Type:  ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data?.strType ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100.0,
                        minWidth: 420.0,
                        maxHeight: 210,
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side:
                                const BorderSide(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Scrollbar(
                            thickness: 8,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                snapshot.data?.strDescription ?? 'NO INFO',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );

          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
