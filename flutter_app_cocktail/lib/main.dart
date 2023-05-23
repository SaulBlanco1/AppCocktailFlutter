import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/helpers/loading/loading_screen.dart';
import 'package:flutter_app_cocktail/providers/counter_provider.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_event.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_state.dart';
import 'package:flutter_app_cocktail/services/auth/firebase_auth_provider.dart';
import 'package:flutter_app_cocktail/views/cocktails/cocktail_view_main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_cocktail/views/forgot_password_view.dart';
import 'package:flutter_app_cocktail/views/login_view.dart';

import 'package:flutter_app_cocktail/views/register_view.dart';
import 'package:flutter_app_cocktail/views/verify_email_view.dart';
import 'package:provider/provider.dart';

import 'providers/itemdetail_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemDetail>(create: (_) => ItemDetail()),
        ChangeNotifierProvider<CounterProvider>(
            create: (_) => CounterProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Please wait a moment',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const MainCocktailView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
