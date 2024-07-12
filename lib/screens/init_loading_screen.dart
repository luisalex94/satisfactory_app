/// Pantalla inicial, carga el archivo json para despues redirigir a la pantall
/// a principal de recetas
library;

import 'package:flutter/material.dart';
import 'package:satisfactory_app/handlers/material_item.dart';
import 'package:satisfactory_app/handlers/material_handlers.dart';
import 'package:satisfactory_app/screens/arguments/arguments.dart';

class InitLoadingScreen extends StatefulWidget {
  const InitLoadingScreen({super.key});

  @override
  State<InitLoadingScreen> createState() => _InitLoadingScreenState();
}

class _InitLoadingScreenState extends State<InitLoadingScreen> {
  List<String> materialStringList = [];
  Map<String, OreItem> oreItems = {};
  String title = 'Loading';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(title),
          ),
          body: FutureBuilder(
            future: MaterialHandlers().loadJson(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return _materialsBar(snapshot.data);
                materialStringList = MaterialHandlers().getMaterialsList();
                oreItems = MaterialHandlers().getOreItems();
                Future.delayed(const Duration(milliseconds: 0)).then((value) {
                  goToMainRecipesPage();
                });
                return const CircularProgressIndicator();
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }

  void goToMainRecipesPage() {
    Navigator.of(context).pushNamed(
      '/mainRecipesPage',
      arguments: MainRecipesPageArguments(
        oreItems: oreItems,
        materialStringList: materialStringList,
      ),
    );
  }
}
