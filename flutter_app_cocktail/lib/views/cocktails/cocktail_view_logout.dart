import 'package:flutter/material.dart';

class LogOutView extends StatefulWidget {
  const LogOutView({super.key});

  @override
  State<LogOutView> createState() => _LogOutViewState();
}

class _LogOutViewState extends State<LogOutView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página Log out'),
    );
  }
}
