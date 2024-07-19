import 'package:flutter/material.dart';
import 'package:satisfactory_app/handlers/factories_handlers.dart';
import 'package:satisfactory_app/handlers/factories_item.dart';
import 'package:satisfactory_app/handlers/material_item.dart';
import 'package:satisfactory_app/popup/add_new_factory_popup.dart';
import 'package:satisfactory_app/popup/edit_material_quantity_popup.dart';

class FactoryCollectionWidget extends StatefulWidget {
  const FactoryCollectionWidget({
    required this.factoryCollection,
    required this.materialStringList,
    required this.callBackFunction,
    required this.callBackFunctionOnlySetState,
    required this.callBackFunctionUpdateRecipe,
    required this.callBackFunctionDeleteFunctionFactoryCollection,
    required this.callBackFunctionDeleteFunctionFactoryConfiguration,
    super.key,
  });

  final FactoryCollection factoryCollection;
  final List<String> materialStringList;
  final Function(
    String collectionName,
  ) callBackFunction;
  final Function callBackFunctionOnlySetState;
  final Function({
    required Recipe recipeUpdate,
    required Map<String, OreItem> oreItemsUpdate,
    required String materialNameUpdate,
    required String collectionNameUpdate,
  }) callBackFunctionUpdateRecipe;
  final Function({
    required String factoryCollectionName,
  }) callBackFunctionDeleteFunctionFactoryCollection;
  final Function({
    required String factoryCollectionName,
    required String factoryConfigurationName,
  }) callBackFunctionDeleteFunctionFactoryConfiguration;

  @override
  State<FactoryCollectionWidget> createState() =>
      _FactoryCollectionWidgetState();
}

class _FactoryCollectionWidgetState extends State<FactoryCollectionWidget> {
  bool showFactories = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: showFactories == true
                      ? const Icon(Icons.keyboard_arrow_down_sharp)
                      : const Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    showFactories = !showFactories;
                    setState(() {});
                  },
                ),
                Text(
                  widget.factoryCollection.factoryCollectionName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                widget.factoryCollection.factoryCollectionName == 'Main factory'
                    ? Container()
                    : IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          FactoriesHandlers().deleteFactoryCollection(
                            widget.factoryCollection.factoryCollectionName,
                          );
                          widget.callBackFunctionOnlySetState();
                          widget
                              .callBackFunctionDeleteFunctionFactoryCollection(
                            factoryCollectionName:
                                widget.factoryCollection.factoryCollectionName,
                          );
                        },
                      ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    widget.callBackFunction(
                        widget.factoryCollection.factoryCollectionName);
                  },
                ),
              ],
            ),
          ],
        ),
        showFactories == true ? _hidenItems() : Container(),
      ],
    );
  }

  Widget _hidenItems() {
    return Column(
      children: [
        const Divider(
          endIndent: 10,
          indent: 10,
        ),
        _itemFactoryCollection(
          widget.factoryCollection,
        ),
        ElevatedButton(
          onPressed: () {
            _addNewFactoryPopUp(
              widget.factoryCollection.factoryCollectionName,
            );
          },
          child: const Text('Add factory'),
        ),
        _sizedBox10(),
      ],
    );
  }

  /// Muestra los items de una [FactoryCollection] individual
  Widget _itemFactoryCollection(
    FactoryCollection factoryCollection,
  ) {
    // Flujo para retornar vacio si entra vacio
    if (factoryCollection.factoryCollection[""]?.itemName != null) {
      return const Text('No items');
    }

    // Establece una lista vacia para guardar los Widgets de las fabricas
    List<Widget> factoryConfiguration = [];

    // Recorre el mapa de [factoryCollection]
    factoryCollection.factoryCollection.forEach(
      (key, value) {
        String itemName = factoryCollection.factoryCollection[key]!.itemName;
        String outputPm =
            factoryCollection.factoryCollection[key]!.outputPm.toString();
        factoryConfiguration.add(
          Column(
            children: [
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white54,
                    border: Border.all(width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CheckboxFactoryConfiguration(
                            factoryConfigurationName: itemName,
                            collectionName:
                                factoryCollection.factoryCollectionName,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 4,
                            ),
                            child: SizedBox(
                              width: 160,
                              child: Text(
                                '$itemName ($outputPm)',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editFactoryConfiguration(
                                factoryConfiguration: value,
                                factoryCollectionName:
                                    factoryCollection.factoryCollectionName,
                                factoryConfigurationName: value.itemName,
                              );
                              widget.callBackFunctionOnlySetState();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              _deleteItemFromCollection(
                                  key, factoryCollection.factoryCollectionName);
                              setState(
                                () {
                                  widget.callBackFunctionOnlySetState();
                                  widget
                                      .callBackFunctionDeleteFunctionFactoryConfiguration(
                                    factoryCollectionName:
                                        factoryCollection.factoryCollectionName,
                                    factoryConfigurationName: value.itemName,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  widget.callBackFunctionUpdateRecipe(
                    recipeUpdate: value.factoryItem[value.itemName]!,
                    oreItemsUpdate: value.oreItems,
                    materialNameUpdate: value.itemName,
                    collectionNameUpdate:
                        factoryCollection.factoryCollectionName,
                  );
                },
              ),
              _sizedBox10()
            ],
          ),
        );
      },
    );

    return Column(
      children: factoryConfiguration,
    );
  }

  void _editFactoryConfiguration({
    required FactoryConfiguration factoryConfiguration,
    required String factoryCollectionName,
    required String factoryConfigurationName,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            child: EditMaterialQuantityPopup(
              factoryConfiguration: factoryConfiguration,
              factoryCollectionName: factoryCollectionName,
              factoryConfigurationName: factoryConfigurationName,
              callBackFunctionUpdateRecipe: widget.callBackFunctionUpdateRecipe,
            ),
          ),
        );
      },
    );
  }

  void _addNewFactoryPopUp(String collectionName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            child: AddNewFactoryPopup(
              collectionName: collectionName,
              originalMaterialStringList: widget.materialStringList,
              callBackFunctionOnlySetState: widget.callBackFunctionOnlySetState,
            ),
          ),
        );
      },
    );
  }

  void _deleteItemFromCollection(String itemName, String collectionName) {
    FactoriesHandlers().deleteFactoryConfiguration(collectionName, itemName);
  }

  Widget _sizedBox10() {
    return const SizedBox(
      height: 10,
      width: 10,
    );
  }
}

class CheckboxFactoryConfiguration extends StatefulWidget {
  const CheckboxFactoryConfiguration({
    required this.factoryConfigurationName,
    required this.collectionName,
    super.key,
  });

  final String factoryConfigurationName;
  final String collectionName;

  @override
  State<CheckboxFactoryConfiguration> createState() =>
      _CheckboxFactoryConfigurationState();
}

class _CheckboxFactoryConfigurationState
    extends State<CheckboxFactoryConfiguration> {
  bool? isCheck = false;

  @override
  void initState() {
    isCheck = FactoriesHandlers().getReadyFactoryConfiguration(
        factoryConfigurationName: widget.factoryConfigurationName,
        collectionName: widget.collectionName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: isCheck,
        onChanged: (value) {
          FactoriesHandlers().setReadyFactoryConfiguration(
            factoryConfigurationName: widget.factoryConfigurationName,
            collectionName: widget.collectionName,
            ready: value ?? false,
          );
          setState(() {
            isCheck = value;
          });
        });
  }
}
