import 'factories_item.dart';

class FactoriesHandlers {
  static final FactoriesHandlers _instance = FactoriesHandlers._internal();

  factory FactoriesHandlers() {
    return _instance;
  }

  FactoriesHandlers._internal();

  FactoryConfiguration factoryConfiguration = FactoryConfiguration(
    itemName: "",
    factoryItem: {},
    outputPm: 1.0,
    oreItems: {},
  );

  FactoryCollection factoryCollection = FactoryCollection(
    factoryCollectionName: 'default',
    factoryCollection: {},
  );

  MainFactoryCollection mainFactoryCollection = MainFactoryCollection(
    mainCollection: {},
  );

  void addFactoryConfiguration(
    FactoryConfiguration factoryConfiguration,
    String? collectionName,
  ) {
    String name = collectionName ?? 'default';
    factoryCollection.factoryCollection[name] = factoryConfiguration;
  }

  void addFactoryCollection(
    FactoryCollection factoryCollection,
  ) {
    mainFactoryCollection
            .mainCollection[factoryCollection.factoryCollectionName] =
        factoryCollection;
  }

  void addFlowDefault(FactoryConfiguration factoryConfiguration) {
    addFactoryConfiguration(factoryConfiguration, 'default');
    addFactoryCollection(factoryCollection);
  }

  MainFactoryCollection getMainFactoryCollection() {
    return mainFactoryCollection;
  }
}
