import 'package:flutter/material.dart';

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
    factoryCollectionName: 'Main factory',
    factoryCollection: {},
  );

  MainFactoryCollection mainFactoryCollection = MainFactoryCollection(
    mainCollection: {
      "Main factory": FactoryCollection(
        factoryCollectionName: "Main Factory",
        factoryCollection: {
          "": FactoryConfiguration(
            itemName: "",
            outputPm: 0.0,
            factoryItem: {},
            oreItems: {},
          ),
        },
      )
    },
  );

  void addFactoryConfiguration(
    FactoryConfiguration factoryConfiguration,
    String? collectionName,
  ) {
    String name = collectionName ?? 'Main factory';
    factoryCollection.factoryCollection[factoryConfiguration.itemName] =
        factoryConfiguration;
  }

  void addFactoryCollection(
    FactoryCollection factoryCollection,
  ) {
    mainFactoryCollection
            .mainCollection[factoryCollection.factoryCollectionName] =
        factoryCollection;
  }

  void addFlowDefault(FactoryConfiguration factoryConfiguration) {
    addFactoryConfiguration(factoryConfiguration, 'Main factory');
    addFactoryCollection(factoryCollection);
  }

  MainFactoryCollection getMainFactoryCollection() {
    return mainFactoryCollection;
  }

  MainFactoryCollection getEmptyMainFactoryCollection() {
    return MainFactoryCollection(mainCollection: {
      "": FactoryCollection(
        factoryCollectionName: "",
        factoryCollection: {
          "": FactoryConfiguration(
            itemName: "",
            outputPm: 0.0,
            factoryItem: {},
            oreItems: {},
          ),
        },
      )
    });
  }
}
