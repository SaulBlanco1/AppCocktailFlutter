import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/providers/itemdetail_provider.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';
import 'package:flutter_app_cocktail/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_detail.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late final FirebaseCloudStorage _notesService;
  bool isFavorite = false;
  List<dynamic> apiData = [];
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _notesService.getAllFavs(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allFavDrinks = snapshot.data as Iterable<CloudDrink>;
                apiData = allFavDrinks.toList();
                return Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 236, 196, 78)),
                  child: ListView.builder(
                    itemCount: apiData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side:
                                const BorderSide(color: Colors.grey, width: 1)),
                        margin: const EdgeInsets.all(4.0),
                        child: ListTile(
                          leading: Image.network(
                            apiData[index].strDrinkThumb,
                            fit: BoxFit.cover,
                            height: 150.0,
                          ),
                          title: Text(apiData[index].strDrink),
                          subtitle: Text(
                              '${apiData[index].strCategory!} / ${apiData[index].strAlcoholic!} / ${apiData[index].strGlass!}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite),
                            color: Colors.red,
                            onPressed: () async {
                              await _notesService.deleteDrinkFromFavs(
                                  drinkId: apiData[index].idDrink);
                            },
                          ),
                          onTap: () {
                            context
                                .read<ItemDetail>()
                                .setitemDetail(apiData[index]);
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
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
