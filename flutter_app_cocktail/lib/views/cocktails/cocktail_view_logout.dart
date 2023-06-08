// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/services/auth/auth_service.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_event.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LogOutView extends StatefulWidget {
  const LogOutView({super.key});

  @override
  State<LogOutView> createState() => _LogOutViewState();
}

class _LogOutViewState extends State<LogOutView> {
  @override
  Widget build(BuildContext context) {
    String userCurrentEmail = AuthService.firebase().currentUser!.email;
    String userCurrentId = AuthService.firebase().currentUser!.id;
    return Scaffold(body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          color: const Color.fromARGB(255, 236, 196, 78),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SvgPicture.asset(
                    'assets/images/cocktailLoginImage.svg',
                    height: 200,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Logged user email: ' + userCurrentEmail),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Logged user id: ' + userCurrentId),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: TextButton(
                      onPressed: () async {
                        final shouldLogout = await showLogOutDialog(context);
                        if (shouldLogout) {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        }
                      },
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
