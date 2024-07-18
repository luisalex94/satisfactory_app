import 'package:satisfactory_app/handlers/material_item.dart';

/// Almacena las recetas como objetos
class Recipe {
  List<List<MaterialItem>> recipe = [[]];

  Recipe({
    this.recipe = const [[]],
  });
}

/// Configuracion final de una fabrica de una receta
class FactoryConfiguration {
  String itemName = "";
  Map<String, Recipe> factoryItem = {};
  double outputPm = 1.0;
  Map<String, OreItem> oreItems = {};
  bool ready = false;

  FactoryConfiguration({
    this.itemName = "",
    this.factoryItem = const {},
    this.outputPm = 1.0,
    this.oreItems = const {},
    this.ready = false,
  });
}

/// Coleccion de fabricas para obtener una fabrica final
class FactoryCollection {
  String factoryCollectionName = "";
  Map<String, OreItem> oreItems = {};
  Map<String, FactoryConfiguration> factoryCollection = {};

  FactoryCollection({
    this.factoryCollectionName = "",
    this.oreItems = const {},
    this.factoryCollection = const {},
  });
}

/// Colección de fábricas finales
class MainFactoryCollection {
  Map<String, FactoryCollection> mainCollection = {};

  MainFactoryCollection({
    this.mainCollection = const {},
  });
}
