import 'package:flutter/widgets.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'We are now sent you a password reset link. Please check your email for more information.',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
