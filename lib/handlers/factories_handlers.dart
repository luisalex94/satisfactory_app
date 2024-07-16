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
      )
    },
  );

  /* Inicializa */

  /// Inicializa la primer fabrica solo la primera vez que arranca el codigo
  void addFlowDefault(FactoryConfiguration factoryConfiguration) {
    addEmptyFactoryConfiguration(factoryConfiguration, 'Main factory');
    addEmptyFactoryCollection(factoryCollection);
  }

  void addEmptyFactoryConfiguration(
    FactoryConfiguration factoryConfiguration,
    String collectionName,
  ) {
    mainFactoryCollection.mainCollection[collectionName]!.factoryCollection
        .putIfAbsent(factoryConfiguration.itemName, () => factoryConfiguration);
  }

  /// Agrega una [FactoryCollection] vacia en [factoryCollection].
  /// Solo se usa para arrancar la aplicacion
  void addEmptyFactoryCollection(
    FactoryCollection factoryCollection,
  ) {
    mainFactoryCollection
            .mainCollection[factoryCollection.factoryCollectionName] =
        FactoryCollection();
  }

  /* Metodos genericos */

  /// Agrega una [FactoryConfiguration] a una [FactoryCollection]
  /// Se agrega el item [factoryConfiguration]
  /// a la coleccion [collectionName]
  void addFactoryConfiguration(
    FactoryConfiguration factoryConfiguration,
    String collectionName,
  ) {
    // Agrega al [FactoryCollection] con el nombre [collectionName] la
    // [FactoryConfiguration] con el nombre [factoryConfiguration]
    mainFactoryCollection.mainCollection[collectionName]!.factoryCollection
        .putIfAbsent(factoryConfiguration.itemName, () => factoryConfiguration);
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
}
