// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/providers/itemdetail_provider.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/infofavs_dialog.dart';
import 'package:provider/provider.dart';

class ItemDetailShow extends StatefulWidget {
  const ItemDetailShow({super.key});

  @override
  State<ItemDetailShow> createState() => _ItemDetailShowState();
}

class _ItemDetailShowState extends State<ItemDetailShow> {
  String userCurrent = AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;
  List<String> idFavorites = [];
  late bool itemIsFav = false;

  Future<List<String>> getidFavs() async {
    List<String> listIdFavs =
        await _notesService.getAllIDsFavs(ownerUserId: userCurrent);
    idFavorites = listIdFavs;
    return listIdFavs;
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    getidFavs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemDetail>(create: (_) => ItemDetail()),
      ],
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 236, 196, 78),
            title: Text(context.watch<ItemDetail>().getDrink.strDrink)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                context.watch<ItemDetail>().getDrink.strDrinkThumb,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40.0),
                  child: Row(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side:
                                const BorderSide(color: Colors.grey, width: 1)),
                        child: Center(
                          child: Text(
                            context.watch<ItemDetail>().getDrink.strDrink,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: itemIsFav
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                        onPressed: () async {
                          if (idFavorites.contains(
                              Provider.of<ItemDetail>(context, listen: false)
                                  .getDrink
                                  .idDrink)) {
                            await _notesService.deleteDrinkFromFavs(
                                drinkId: Provider.of<ItemDetail>(context,
                                        listen: false)
                                    .getDrink
                                    .idDrink);

                            await showInfoFavsDialog(
                                context, 'Drink eliminated from Favs.');
                          } else {
                            await _notesService.addDrinktoFav(
                                ownerUserId: userCurrent,
                                drinkToAdd: Provider.of<ItemDetail>(context,
                                        listen: false)
                                    .getDrink);

                            await showInfoFavsDialog(
                                context, 'Drink added to Favs.');
                          }
                          await getidFavs();
                          setState(() {
                            itemIsFav = idFavorites.contains(
                                Provider.of<ItemDetail>(context, listen: false)
                                    .getDrink
                                    .idDrink);
                          });
                        },
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.grey, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          context.watch<ItemDetail>().getDrink.strCategory!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.watch<ItemDetail>().getDrink.strAlcoholic!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.watch<ItemDetail>().getDrink.strGlass!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.grey, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          context.watch<ItemDetail>().getDrink.strIngredient1 ??
                              'Error',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.watch<ItemDetail>().getDrink.strIngredient2 ??
                              'Error',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.watch<ItemDetail>().getDrink.strIngredient3 ??
                              'Error',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 100.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.grey, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Scrollbar(
                        thickness: 8,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            context
                                    .watch<ItemDetail>()
                                    .getDrink
                                    .strInstructions ??
                                'Error',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.pink,
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
        ),
      ),
    );
  }
}
