// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/constants/constants.dart';
import 'package:flutter_app_cocktail/dataclasses/cocktail_list_drinks.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/error_dialog.dart';
import 'package:http/http.dart' as http;

class HomeCocktailView extends StatefulWidget {
  const HomeCocktailView({super.key});

  @override
  State<HomeCocktailView> createState() => _HomeCocktailViewState();
}

class _HomeCocktailViewState extends State<HomeCocktailView> {
  List<dynamic> apiData = [];
  String _categorySelected = 'Ordinary Drink';
  String _alcoholicSelected = 'Alcoholic';
  String _typeGlassSelected = 'Highball glass';

  Future<void> searchForDrinks(String drinktoSearch) async {
    final response = await http.get(Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$drinktoSearch'));

    final Map<String, dynamic> parsedJson = json.decode(response.body);
    final drinklist = ListOfDrinks.fromJson(parsedJson);

    setState(() {
      apiData = drinklist.drinks;
    });
    if (drinklist.drinks.isEmpty) {
      await showErrorDialog(context, 'No results found for your search.');
    }
  }

  @override
  void initState() {
    searchForDrinks('a');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: TextEditingController(),
          onSubmitted: (value) {
            searchForDrinks(value);
          },
          decoration: const InputDecoration(
            hintText: 'Search for drinks...',
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
                onTap: () {},
              ),
            );
          },
        ))
      ],
    );
  }
}
