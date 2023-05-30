// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app_cocktail/services/auth/bloc/auth_event.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/error_dialog.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              'We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Forgot Password'),
            backgroundColor: const Color.fromARGB(255, 236, 196, 78)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SvgPicture.asset(
                    'assets/images/cocktailLoginImage.svg',
                    height: 200,
                    width: 200,
                  ),
                ),
                const Text(
                    'If you forgot your password, simply enter your email and we will send you a password-reset email.',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 236, 196, 78),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autofocus: true,
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        gapPadding: 8.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      hintStyle: TextStyle(color: Colors.green),
                      hintText: 'Your email address...',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context.read<AuthBloc>().add(
                          AuthEventForgotPassword(email: email),
                        );
                  },
                  child: const Text('Send me password reset link',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      )),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('Back to login page',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
