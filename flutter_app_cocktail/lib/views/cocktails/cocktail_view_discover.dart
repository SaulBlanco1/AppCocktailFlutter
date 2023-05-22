import 'package:flutter/material.dart';
import 'package:flutter_app_cocktail/providers/counter_provider.dart';
import 'package:provider/provider.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(context.watch<CounterProvider>().counter.toString(),
            style: const TextStyle(fontSize: 50)));
  }
}
