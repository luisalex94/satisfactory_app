import 'package:flutter/material.dart';
import 'package:satisfactory_app/handlers/factories_handlers.dart';
import 'package:satisfactory_app/handlers/factories_item.dart';
import 'package:satisfactory_app/popup/add_new_factory_popup.dart';
import 'package:satisfactory_app/popup/edit_material_quantity_popup.dart';

class FactoryCollectionWidget extends StatefulWidget {
  const FactoryCollectionWidget({
    required this.factoryCollection,
    required this.materialStringList,
    required this.callBackFunction,
    required this.callBackFunctionOnlySetState,
    super.key,
  });

  final FactoryCollection factoryCollection;
  final List<String> materialStringList;
  final Function(String collectionName) callBackFunction;
  final Function callBackFunctionOnlySetState;

  @override
  State<FactoryCollectionWidget> createState() =>
      _FactoryCollectionWidgetState();
}

class _FactoryCollectionWidgetState extends State<FactoryCollectionWidget> {
  bool showFactories = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
                          setState(() {});
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
        String itenName = factoryCollection.factoryCollection[key]!.itemName;
        String outputPm =
            factoryCollection.factoryCollection[key]!.outputPm.toString();
        factoryConfiguration.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$itenName ($outputPm)'),
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
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _deleteItemFromCollection(
                          key, factoryCollection.factoryCollectionName);
                      setState(() {
                        widget.callBackFunctionOnlySetState();
                      });
                    },
                  ),
                ],
              ),
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
              callBackFunction: widget.callBackFunctionOnlySetState,
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
