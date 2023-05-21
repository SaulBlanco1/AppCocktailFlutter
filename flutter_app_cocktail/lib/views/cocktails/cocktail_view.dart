// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/enums/menu_action.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_event.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CocktailView extends StatefulWidget {
  const CocktailView({super.key});

  @override
  State<CocktailView> createState() => _CocktailViewState();
}

class _CocktailViewState extends State<CocktailView> {
  String get userId => AuthService.firebase().currentUser!.id;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: 'Favorites'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings), label: 'Settings'),
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
      body: Column(
        children: [
          Text('Current Index : $_selectedIndex'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
