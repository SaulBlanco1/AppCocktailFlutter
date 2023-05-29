import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/utilities/dialogs/generic_dialog.dart';

Future<void> showInfoFavsDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'Favorites Edited',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
