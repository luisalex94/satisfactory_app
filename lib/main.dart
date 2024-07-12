import 'package:flutter/material.dart';
import 'package:satisfactory_app/screens/init_loading_screen.dart';
import 'package:satisfactory_app/screens/main_recipes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const InitLoadingScreen(),
      routes: {
        '/initLoadingScreen': (context) => const InitLoadingScreen(),
        '/mainRecipesPage': (context) => const MainRecipesPage(),
      },
    );
  }
}
