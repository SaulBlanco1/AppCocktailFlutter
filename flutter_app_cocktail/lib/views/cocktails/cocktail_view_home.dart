// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/constants/constants.dart';
import 'package:flutter_app_cocktail/dataclasses/cocktail_list_drinks.dart';
import 'package:flutter_app_cocktail/providers/itemdetail_provider.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';
import 'package:flutter_app_cocktail/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/error_dialog.dart';
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeCocktailView extends StatefulWidget {
  const HomeCocktailView({super.key});

  @override
  State<HomeCocktailView> createState() => _HomeCocktailViewState();
}

class _HomeCocktailViewState extends State<HomeCocktailView> {
  late final FirebaseCloudStorage _notesService;
  List<dynamic> apiData = [];
  bool isFavorite = false;

  String _categorySelected = 'Ordinary Drink';
  String _alcoholicSelected = 'Alcoholic';
  String _typeGlassSelected = 'Highball glass';

  Future<void> searchForDrinks(String drinktoSearch) async {
    final response = await http.get(Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$drinktoSearch'));

    final Map<String, dynamic> parsedJson = json.decode(response.body);
    final drinklist = ListOfCloudDrinks.fromJson(parsedJson);

    setState(() {
      apiData = drinklist.drinks;
    });
    if (drinklist.drinks.isEmpty) {
      await showErrorDialog(context, 'No results found for your search.');
    }
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    searchForDrinks('a');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 35.0),
      child: Column(
        children: [
          TextField(
            controller: TextEditingController(),
            onSubmitted: (value) {
              searchForDrinks(value);
            },
            decoration: const InputDecoration(
              errorBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
              hintText: 'Search for drinks...',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _categorySelected,
                items: categorias.map((String categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _categorySelected = newValue!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _alcoholicSelected,
                items: alcoholic.map((String alcoholic) {
                  return DropdownMenuItem<String>(
                    value: alcoholic,
                    child: Text(alcoholic),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _alcoholicSelected = newValue!;
                  });
                },
              ),
            ],
          ),
          DropdownButton<String>(
            value: _typeGlassSelected,
            items: glassType.map((String glassType) {
              return DropdownMenuItem<String>(
                value: glassType,
                child: Text(glassType),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _typeGlassSelected = newValue!;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: apiData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      apiData[index].strDrinkThumb,
                      fit: BoxFit.cover,
                      height: 150.0,
                    ),
                    title: Text(apiData[index].strDrink),
                    subtitle: Text(apiData[index].strCategory +
                        ' / ' +
                        apiData[index].strAlcoholic +
                        ' / ' +
                        apiData[index].strGlass),
                    trailing: Checkbox(
                      value: isFavorite,
                      onChanged: (value) async {
                        if (value == true) {
                          final currentUser =
                              AuthService.firebase().currentUser!;
                          await _notesService.addDrinktoFav(
                              ownerUserId: currentUser.id,
                              drinkToAdd: apiData[index]);
                        } else {
                          //TODO conseguir borrar drinks de firebase

                          // await _notesService.deleteDrinkFromFavs(
                          //     documentId: snapshot.id);
                        }

                        setState(() {
                          isFavorite = value ?? false;
                        });
                      },
                    ),
                    onTap: () {
                      context.read<ItemDetail>().setitemDetail(apiData[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ItemDetailShow()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
