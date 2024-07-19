import 'package:satisfactory_app/handlers/material_item.dart';

import 'factories_item.dart';

class FactoriesHandlers {
  static final FactoriesHandlers _instance = FactoriesHandlers._internal();

  factory FactoriesHandlers() {
    return _instance;
  }

  FactoriesHandlers._internal();

  /* Objetos para inicializar [MainFactoryCollection] */

  /// [FactoryConfiguration] para inicializar
  FactoryConfiguration factoryConfiguration = FactoryConfiguration(
    itemName: "",
    factoryItem: {},
    outputPm: 1.0,
    oreItems: {},
  );

  /// [FactoryCollection] para inicializar
  FactoryCollection factoryCollection = FactoryCollection(
    factoryCollectionName: 'Main factory',
    factoryCollection: {},
  );

  /// [MainFactoryCollection] para inicializar
  MainFactoryCollection mainFactoryCollection = MainFactoryCollection(
    mainCollection: {
      "Main factory": FactoryCollection(
        factoryCollectionName: "Main factory",
        factoryCollection: {},
        oreItems: {},
      )
    },
  );

  /* Metodos genericos */

  /// Agrega una [FactoryConfiguration] a una [FactoryCollection]
  /// Se agrega el item [factoryConfiguration]
  /// a la coleccion [collectionName]
  void addFactoryConfiguration(
    FactoryConfiguration factoryConfiguration,
    String collectionName,
  ) {
    // Extrae la receta de [factoryConfiguration]
    Recipe recipe =
        factoryConfiguration.factoryItem[factoryConfiguration.itemName]!;
    // Agrega los [oreItems] de la receta
    factoryConfiguration.oreItems = _oreItemsIngredient(recipe);
    // Agrega al [FactoryCollection] con el nombre [collectionName] la
    // [FactoryConfiguration] con el nombre [factoryConfiguration]
    mainFactoryCollection.mainCollection[collectionName]!.factoryCollection
        .putIfAbsent(factoryConfiguration.itemName, () => factoryConfiguration);

    _updateCollectionOres(collectionName);
  }

  /// Elimina una [FactoryConfiguration] de [FactoryCollection]
  /// Se elimina el item [factoryConfigurationName]
  /// de la coleccion [factoryCollectionName]
  void deleteFactoryConfiguration(
    String factoryCollectionName,
    String factoryConfigurationName,
  ) {
    // Elimina la [FactoryConfiguration] con el nombre [factoryConfigurationName]
    // de la [FactoryCollection] con el nombre [factoryCollectionName]
    mainFactoryCollection
        .mainCollection[factoryCollectionName]!.factoryCollection
        .removeWhere((key, value) {
      return key == factoryConfigurationName;
    });

    _updateCollectionOres(factoryCollectionName);
  }

  /// Edita la cantidad de output de un [FactoryConfiguration]
  /// Elimina y agrega la [FactoryConfiguration], recicla ambas funciones
  void editFactoryConfiguration({
    required FactoryConfiguration factoryConfiguration,
    required String factoryCollectionName,
    required String factoryConfigurationName,
  }) {
    // Extrae la receta de [factoryConfiguration]
    Recipe recipe =
        factoryConfiguration.factoryItem[factoryConfiguration.itemName]!;
    // Agrega los [oreItems] de la receta
    factoryConfiguration.oreItems = _oreItemsIngredient(recipe);

    // Agrega al [FactoryCollection] con el nombre [collectionName] la
    // [FactoryConfiguration] con el nombre [factoryConfiguration]
    mainFactoryCollection.mainCollection[factoryCollectionName]!
            .factoryCollection[factoryConfiguration.itemName] =
        factoryConfiguration;

    _updateCollectionOres(factoryCollectionName);
  }

  /// Agrega una [FactoryCollection] a [MainFactoryCollection]
  /// Se agrega con el nombre de [addFactoryCollection]
  void addFactoryCollection(
    String addFactoryCollection,
  ) {
    // Inicializa la [FactoryCollection] para agregarla
    FactoryCollection newFactoryCollection = FactoryCollection(
      factoryCollectionName: addFactoryCollection,
      factoryCollection: {},
      oreItems: {},
    );

    // Agrega la [FactoryCollection] inicializada arriba
    mainFactoryCollection.mainCollection
        .putIfAbsent(addFactoryCollection, () => newFactoryCollection);
  }

  /// Elimina una [FactoryCollection] de [MainFactoryCollection]
  void deleteFactoryCollection(
    String deleteFactoryCollectionName,
  ) {
    // Elimina la [FactoryCollection] con la clave [deleteFactoryCollectionName]
    mainFactoryCollection.mainCollection.removeWhere((key, value) {
      return key == deleteFactoryCollectionName;
    });
  }

  /// Obtiene una [List<String>] de los nombres de todas las colecciones
  List<String> getCollectionStringNamesList() {
    // Lista donde se guardaran todos los nombres
    List<String> data = [];

    // Se recorre el mapa de colecciones para agregar a la lista los objetos
    mainFactoryCollection.mainCollection.forEach((key, value) {
      data.add(value.factoryCollectionName);
    });
    return data;
  }

  /// Obtiene el [MainFactoryCollection]
  MainFactoryCollection getMainFactoryCollection() {
    return mainFactoryCollection;
  }

  /* Contador de materiales por [FactoryConfiguration] */

  /// Devuelve un mapa de OreItem de la receta que entra
  Map<String, OreItem> _oreItemsIngredient(Recipe recipe) {
    // Almacena el mapa principal
    Map<String, OreItem> data = {};

    // Altura de la matriz
    int maxRow = recipe.recipe.length;

    // Ancho de la matriz
    int maxColumn = recipe.recipe[0].length;

    // Recorre las columnas de la matriz
    for (int column = 0; column < maxColumn; column++) {
      // Recorre las filas de la matriz
      for (int row = maxRow - 1; row >= 0; row--) {
        // Se verifica que la posicion actual sea un ore
        if (recipe.recipe[row][column].ore) {
          // Se extrae el materialItem
          MaterialItem materialItem = recipe.recipe[row][column];

          // Se extrae el nombre del ore actual
          String oreName = materialItem.materialName;

          // Se extrae el outputPm del ore actual
          double newOreOutputPm = materialItem.oreOutputPm;

          // Se genera el objeto [OreItem]
          OreItem oreItem = OreItem(
            materialId: materialItem.materialId,
            materialName: materialItem.materialName,
            outputPm: materialItem.oreOutputPm,
          );

          // Se agrega un nuevo oreItem si el actual no existe
          // Se suman los oreOutputPm si el oreItem si existe
          if (data[oreName] == null) {
            // Se agrega el nuevo oreItem
            data[oreName] = oreItem;
          } else {
            // Se extrae el oreItem actual
            OreItem currentOreItem = data[oreName]!;

            // Se extrae el oreOutputPm actual
            double currentOreItemOreOutputPm = currentOreItem.outputPm;

            // Nuevo valor de oreOutputPm
            newOreOutputPm = newOreOutputPm + currentOreItemOreOutputPm;

            // Se actualiza el oreItem
            currentOreItem.outputPm = newOreOutputPm;

            // Se genera un nuevo objeto OreItem actualizado
            data[oreName] = currentOreItem;
          }
        }
      }
    }

    return data;
  }

  /* Contador de materiales por [FactoryCollection] */

  /// Actualiza los oreItems totales de la coleccion
  _updateCollectionOres(String collectionName) {
    // [collectionFactories] almacena en un mapa las [FactoryConfiguration] del
    // [FactoryCollection]
    Map<String, FactoryConfiguration> collectionFactories =
        mainFactoryCollection.mainCollection[collectionName]!.factoryCollection;

    // Mapa para guardar los OreItems
    Map<String, OreItem> data = {};

    // Recorre cada configuracion de la coleccion
    collectionFactories.forEach(
      (key, value) {
        // Recorre cada OreItems de cada configuracion
        value.oreItems.forEach(
          (key, value) {
            // Se extrae el nombre del ore actual
            String oreName = value.materialName;

            // Se extrae el outputPm del ore actual
            double newOreOutputPm = value.outputPm;

            // Se extrae el id del ore actual
            int oreId = value.materialId;

            // Crea un nuevo OreItem por si necesita agregarse
            OreItem newOreItem = OreItem(
              materialName: oreName,
              outputPm: newOreOutputPm,
              materialId: oreId,
            );

            if (data[oreName] == null) {
              data[oreName] = newOreItem;
            } else {
              // Se extrae el oreItem actual
              OreItem currentOreItem = data[oreName]!;

              // Se extrae el oreOutputPm actual
              double currentOreItemOreOutputPm = currentOreItem.outputPm;

              // Nuevo valor de oreOutputPm
              newOreOutputPm = newOreOutputPm + currentOreItemOreOutputPm;

              // Se actualiza el oreItem
              currentOreItem.outputPm = newOreOutputPm;

              // Se genera un nuevo objeto OreItem actualizado
              data[oreName] = currentOreItem;
            }
          },
        );
      },
    );

    // Se actualiza el valor de oreItems
    mainFactoryCollection.mainCollection[collectionName]!.oreItems = data;
  }

  /// Retorna un mapa de OreItems de los ores de una coleccion
  Map<String, OreItem> oreItemsCollection(String collectionName) {
    // Recolecta la informacion
    Map<String, OreItem> data =
        mainFactoryCollection.mainCollection[collectionName]?.oreItems ?? {};
    // Retorna la informacion
    return data;
  }

  /// Setea true o false el bool ready de una [FactoryConfiguration]
  void setReadyFactoryConfiguration({
    required String factoryConfigurationName,
    required String collectionName,
    required bool ready,
  }) {
    mainFactoryCollection.mainCollection[collectionName]!
        .factoryCollection[factoryConfigurationName]!.ready = ready;
  }

  /// Obtiene true o false del bool ready de una [FactoryConfiguration]
  bool getReadyFactoryConfiguration({
    required String factoryConfigurationName,
    required String collectionName,
  }) {
    return mainFactoryCollection.mainCollection[collectionName]!
        .factoryCollection[factoryConfigurationName]!.ready;
  }

  /// Setea true o false el bool ready de un [OreItem] del oreItems de un [FactoryCollection]
  void setReadyOreItemFactoryCollection({
    required String collectionName,
    required String oreName,
    required bool ready,
  }) {
    mainFactoryCollection
        .mainCollection[collectionName]!.oreItems[oreName]!.ready = ready;
  }

  /// Obtiene true o false del bool ready de un [OreItem] del oreItems de una [FactoryCollection]
  bool getReadyOreItemFactoryCollection({
    required String collectionName,
    required String oreName,
  }) {
    return mainFactoryCollection
        .mainCollection[collectionName]!.oreItems[oreName]!.ready;
  }

  /* Manejadores del estado [ready] de los [MaterialItems] de las [FactoryConfiguration] */

  /// Setea true o false el bool ready de un:
  /// [MaterialItem] -> [Recipe] -> [FactoryConfiguration] -> [FactoryCollection]
  void setReadyMaterialItem({
    required String factoryCollectionName,
    required String factoryConfigurationName,
    required String materialName,
    required int row,
    required int column,
    required bool ready,
  }) {
    mainFactoryCollection
        .mainCollection[factoryCollectionName]!
        .factoryCollection[factoryConfigurationName]!
        .factoryItem[materialName]!
        .recipe[row][column]
        .ready = ready;
  }

  /// Obtiene true o false del bool ready de un:
  /// [MaterialItem] -> [Recipe] -> [FactoryConfiguration] -> [FactoryCollection]
  bool getReadyMaterialItem({
    required String factoryCollectionName,
    required String factoryConfigurationName,
    required String materialName,
    required int row,
    required int column,
  }) {
    try {
      return mainFactoryCollection
          .mainCollection[factoryCollectionName]!
          .factoryCollection[factoryConfigurationName]!
          .factoryItem[materialName]!
          .recipe[row][column]
          .ready;
    } catch (e) {
      return false;
    }
  }
}
