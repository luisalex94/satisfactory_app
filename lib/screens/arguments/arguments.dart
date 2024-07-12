import 'package:satisfactory_app/handlers/material_item.dart';

class MainRecipesPageArguments {
  Map<String, OreItem> oreItems = {};
  List<String> materialStringList = [];

  MainRecipesPageArguments({
    required this.oreItems,
    required this.materialStringList,
  });
}
