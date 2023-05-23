import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/providers/itemdetail_provider.dart';
import 'package:provider/provider.dart';

class ItemDetailShow extends StatefulWidget {
  const ItemDetailShow({super.key});

  @override
  State<ItemDetailShow> createState() => _ItemDetailShowState();
}

class _ItemDetailShowState extends State<ItemDetailShow> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemDetail>(create: (_) => ItemDetail()),
      ],
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 236, 196, 78),
            title: Text(context.watch<ItemDetail>().getDrink.strDrink)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                context.watch<ItemDetail>().getDrink.strDrinkThumb,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  context.watch<ItemDetail>().getDrink.strDrink,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      context.watch<ItemDetail>().getDrink.strCategory!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.watch<ItemDetail>().getDrink.strAlcoholic!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.watch<ItemDetail>().getDrink.strGlass!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      context.watch<ItemDetail>().getDrink.strIngredient1 ??
                          'Error',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.watch<ItemDetail>().getDrink.strIngredient2 ??
                          'Error',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.watch<ItemDetail>().getDrink.strIngredient3 ??
                          'Error',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Scrollbar(
                thickness: 8,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    context.watch<ItemDetail>().getDrink.strInstructions ??
                        'Error',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
