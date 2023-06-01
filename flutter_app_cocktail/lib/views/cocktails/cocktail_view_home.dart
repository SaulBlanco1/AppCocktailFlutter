// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/constants/constants.dart';
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
  String userCurrent = AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;
  List<dynamic> apiData = [];
  List<String> idFavorites = [];
  bool _filtersActivated = false;
  bool _categoryActivated = false;
  bool _alcoholicActivated = false;
  bool _typeGlassActivated = false;

  String _categorySelected = 'Ordinary Drink';
  String _alcoholicSelected = 'Alcoholic';
  String _typeGlassSelected = 'Highball glass';

  Future<void> searchForDrinks(String drinktoSearch) async {
    final List<CloudDrink> finalListtoShow;

    final response = await http.get(Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$drinktoSearch'));

    final Map<String, dynamic> parsedJson = json.decode(response.body);
    final drinklist = ListOfCloudDrinks.fromJson(parsedJson);

    if (_filtersActivated) {
      finalListtoShow = filterSearch(drinklist.drinks);
      if (finalListtoShow.isEmpty) {
        await showErrorDialog(context, 'No Drinks Found.');
      }
    } else {
      finalListtoShow = drinklist.drinks;
    }
    setState(() {
      apiData = finalListtoShow;
    });
    if (drinklist.drinks.isEmpty) {
      await showErrorDialog(context, 'No results found for your search.');
    }
  }

  List<CloudDrink> filterSearch(List<CloudDrink> listtoFilter) {
    List<CloudDrink> finalList = listtoFilter;

    if (_categoryActivated) {
      finalList = finalList
          .where((drink) => drink.strCategory == _categorySelected)
          .toList();
    }

    if (_alcoholicActivated) {
      finalList = finalList
          .where((drink) => drink.strAlcoholic == _alcoholicSelected)
          .toList();
    }

    if (_typeGlassActivated) {
      finalList = finalList
          .where((drink) => drink.strGlass == _typeGlassSelected)
          .toList();
    }

    return finalList;
  }

  Future<List<String>> getidFavs() async {
    List<String> listIdFavs =
        await _notesService.getAllIDsFavs(ownerUserId: userCurrent);
    idFavorites = listIdFavs;
    return listIdFavs;
  }

  Future<bool> isFav(String drinkId) async {
    List<String> listIdFavs =
        await _notesService.getAllIDsFavs(ownerUserId: userCurrent);
    idFavorites = listIdFavs;
    if (idFavorites.contains(drinkId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    //searchForDrinks('a');
    //getidFavs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: searchForDrinks('a'),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.done:
            getidFavs();
            return Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 236, 196, 78)),
              child: Container(
                margin: const EdgeInsets.only(top: 35.0),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: TextField(
                        controller: TextEditingController(),
                        onSubmitted: (value) {
                          searchForDrinks(value);
                        },
                        decoration: const InputDecoration(
                            hintText: 'Search for drinks...',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 236, 196, 78),
                            )),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _filtersActivated,
                          activeColor: Colors.green,
                          onChanged: (value) {
                            setState(() {
                              _filtersActivated = !_filtersActivated;
                            });
                          },
                        ),
                        const Text('Filters On/Off')
                      ],
                    ),
                    Visibility(
                      visible: _filtersActivated,
                      child: Card(
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side:
                                const BorderSide(color: Colors.grey, width: 1)),
                        margin: const EdgeInsets.all(3.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Checkbox(
                                    value: _categoryActivated,
                                    onChanged: (value) {
                                      setState(() {
                                        _categoryActivated =
                                            !_categoryActivated;
                                      });
                                    },
                                  ),
                                  DropdownButton<String>(
                                    value: _categorySelected,
                                    items: _filtersActivated
                                        ? categorias.map((String categoria) {
                                            return DropdownMenuItem<String>(
                                              value: categoria,
                                              child: Text(categoria),
                                            );
                                          }).toList()
                                        : [],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _categorySelected = newValue!;
                                      });
                                    },
                                  ),
                                  Checkbox(
                                    value: _alcoholicActivated,
                                    onChanged: (value) {
                                      setState(() {
                                        _alcoholicActivated =
                                            !_alcoholicActivated;
                                      });
                                    },
                                  ),
                                  DropdownButton<String>(
                                    value: _alcoholicSelected,
                                    items: _filtersActivated
                                        ? alcoholic.map((String alcoholic) {
                                            return DropdownMenuItem<String>(
                                              value: alcoholic,
                                              child: Text(alcoholic),
                                            );
                                          }).toList()
                                        : [],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _alcoholicSelected = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: _typeGlassActivated,
                                    onChanged: (value) {
                                      setState(() {
                                        _typeGlassActivated =
                                            !_typeGlassActivated;
                                      });
                                    },
                                  ),
                                  DropdownButton<String>(
                                    value: _typeGlassSelected,
                                    items: _filtersActivated
                                        ? glassType.map((String glassType) {
                                            return DropdownMenuItem<String>(
                                              value: glassType,
                                              child: Text(glassType),
                                            );
                                          }).toList()
                                        : [],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _typeGlassSelected = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: apiData.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool itemFavSelect =
                              idFavorites.contains(apiData[index].idDrink);
                          return Card(
                            color: Colors.white,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                    color: Colors.grey, width: 1)),
                            margin: const EdgeInsets.all(4.0),
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
                              trailing: IconButton(
                                icon: itemFavSelect
                                    ? const Icon(Icons.favorite)
                                    : const Icon(Icons.favorite_border),
                                onPressed: () async {
                                  if (idFavorites
                                      .contains(apiData[index].idDrink)) {
                                    await _notesService.deleteDrinkFromFavs(
                                        drinkId: apiData[index].idDrink);

                                    // await showInfoFavsDialog(
                                    //     context, 'Drink eliminated from Favs.');
                                  } else {
                                    await _notesService.addDrinktoFav(
                                        ownerUserId: userCurrent,
                                        drinkToAdd: apiData[index]);

                                    // await showInfoFavsDialog(
                                    //     context, 'Drink added to Favs.');
                                  }
                                  await getidFavs();
                                  setState(() {
                                    itemFavSelect = idFavorites
                                        .contains(apiData[index].idDrink);
                                  });
                                },
                                color: Colors.red,
                              ),
                              onTap: () {
                                context
                                    .read<ItemDetail>()
                                    .setitemDetail(apiData[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ItemDetailShow()),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
            break;
          default:
            return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}
