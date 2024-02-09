import 'package:dish_delight/screens/home/home_screen.dart';
import 'package:dish_delight/screens/recipe_details/recipe_details.dart';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/recipe_details': (context) => const RecipeDetailsScreen()
      },
    );
  }
}
