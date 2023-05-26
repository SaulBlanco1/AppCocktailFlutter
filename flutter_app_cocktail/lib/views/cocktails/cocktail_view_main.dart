// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/providers/itemdetail_provider.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/error_dialog.dart';
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_favorites.dart';
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_home.dart';
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_logout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCocktailView extends StatefulWidget {
  const MainCocktailView({super.key});

  @override
  State<MainCocktailView> createState() => _MainCocktailViewState();
}

class _MainCocktailViewState extends State<MainCocktailView> {
  String get userId => AuthService.firebase().currentUser!.id;
  int _selectedIndex = 0;
  CloudDrink? apiData;

  final List<Widget> _pages = <Widget>[
    const HomeCocktailView(),
    const ItemDetailShow(),
    const FavoritesView(),
    const LogOutView(),
  ];

  final List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.lightbulb), label: 'Discover'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: 'Favorites'),
    const BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Log Out'),
  ];

  Future<void> searchForRandomDrink() async {
    final response = await http.get(
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));

    final Map<String, dynamic> parsedJson = json.decode(response.body);
    final drinklist = ListOfCloudDrinks.fromJson(parsedJson);

    setState(() {
      apiData = drinklist.drinks[0];
    });
    if (drinklist.drinks.isEmpty) {
      await showErrorDialog(context, 'No results found for your search.');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItems,
        currentIndex: _selectedIndex,
        onTap: (int index) async {
          if (index == 1) {
            await searchForRandomDrink();
            context.read<ItemDetail>().setitemDetail(apiData!);
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        elevation: 20.0,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.amber,
      ),
    );
  }
}
