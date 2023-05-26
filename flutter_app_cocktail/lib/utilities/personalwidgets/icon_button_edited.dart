import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/services/cloud/cloud_note.dart';

class IconButtonFavs extends StatefulWidget {
  final CloudDrink drinktoShow;

  const IconButtonFavs({super.key, required this.drinktoShow});

  @override
  _IconButtonFavsState createState() => _IconButtonFavsState();
}

class _IconButtonFavsState extends State<IconButtonFavs> {
  bool _isChecked = false;

  void _toggleCheckState() {
    CloudDrink drinktodo = widget.drinktoShow;
    print(drinktodo.documentId);

    setState(() {
      _isChecked = !_isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleCheckState,
      icon: Icon(_isChecked ? Icons.check_box : Icons.check_box_outline_blank),
    );
  }
}
