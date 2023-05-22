// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/enums/menu_action.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_event.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_discover.dart';
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

  final List<Widget> _pages = <Widget>[
    const HomeCocktailView(),
    const DiscoverView(),
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cocktails'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItems,
        currentIndex: _selectedIndex,
        onTap: (int index) {
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
