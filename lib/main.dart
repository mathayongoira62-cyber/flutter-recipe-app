import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/app_main.dart';
import 'package:recipe_app/provider/favorite_provider.dart';
import 'package:recipe_app/provider/quantity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // VERY IMPORTANT
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        //this is the provider for quantity
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
      ],
      child: const MaterialApp(debugShowCheckedModeBanner: false, home: App()),
    );
  }
}
