import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satisfactory_app/handlers/factories_handlers.dart';
import 'package:satisfactory_app/handlers/factories_item.dart';
import 'package:satisfactory_app/handlers/material_handlers.dart';
import 'package:satisfactory_app/handlers/material_item.dart';

class AddNewFactoryPopup extends StatefulWidget {
  const AddNewFactoryPopup({
    required this.collectionName,
    required this.originalMaterialStringList,
    required this.callBackFunctionOnlySetState,
    super.key,
  });

  final String collectionName;
  final List<String> originalMaterialStringList;
  final Function callBackFunctionOnlySetState;

  @override
  State<AddNewFactoryPopup> createState() => _AddNewFactoryPopupState();
}

class _AddNewFactoryPopupState extends State<AddNewFactoryPopup> {
  List<String> materialStringList = [];
  List<String> originalMaterialStringList = [];
  Map<String, OreItem> oreItems = {};
  MaterialItem selectedMaterial = MaterialItem();
  int selectedIndex = -1;
  List<List<MaterialItem>> recipe = [];
  bool ready = false;

  final TextEditingController _itemsPmTextController = TextEditingController();
  final TextEditingController _searchItemController = TextEditingController();

  @override
  void initState() {
    materialStringList = widget.originalMaterialStringList;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    originalMaterialStringList = widget.originalMaterialStringList;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _showListOfItems();
  }

  Widget _showListOfItems() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
        border: Border.all(width: 1),
      ),
      height: 330,
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              selectedMaterial.materialName == ""
                  ? "Select material from the list"
                  : selectedMaterial.materialName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            _sizedBox10(),
            _itemsPm(context),
            _sizedBox10(),
            _findBox(),
            Expanded(
              child: ListView.builder(
                itemCount: materialStringList.length,
                itemBuilder: (context, index) {
                  List materials = materialStringList;

                  return ListTile(
                    title: Text(materials[index]),
                    selected: selectedIndex == index,
                    onTap: () {
                      setState(
                        () {
                          // Se toma el material seleccionado
                          selectedMaterial = MaterialHandlers()
                              .getMaterialItem(materials[index]);

                          // Se extrae la informacion de [_itemsPmTextController]
                          String ppmString = _itemsPmTextController.text;

                          // Se parsea a un double en [ppmString]
                          double ppmDouble = double.tryParse(ppmString) ?? 0.0;

                          // Se asegura un mínimo de 1 en [ppmString]
                          ppmDouble = ppmDouble == 0 ? 1 : ppmDouble;

                          // Se corre la matriz de receta con el material indicado y las ppm indicadas
                          recipe = MaterialHandlers().runMatrixRecipe(
                            item: materials[index] ?? [],
                            ppm: ppmDouble,
                          );
                          oreItems = MaterialHandlers().getOreItems();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                _addButton(),
                _addandCloseButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sizedBox10() {
    return const SizedBox(
      height: 10,
      width: 10,
    );
  }

  Widget _findBox() {
    return TextFormField(
      controller: _searchItemController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: "Find item",
        fillColor: Colors.white70,
        suffixIcon: const Icon(Icons.search),
        suffixIconColor: Colors.grey[800],
      ),
      onChanged: (value) {
        setState(() {
          materialStringList = _searchItem(value);
        });
      },
    );
  }

  Widget _itemsPm(BuildContext context) {
    return TextFormField(
      controller: _itemsPmTextController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        DecimalTextInputFormater(),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: "Items per minute",
        fillColor: Colors.white70,
        suffixIcon: const Icon(Icons.play_arrow_rounded),
        suffixIconColor: Colors.grey[800],
      ),
      onChanged: (value) {
        setState(() {
          // Se extrae la informacion de [_itemsPmTextController]
          String ppmString = value;

          // Se parsea a un double en [ppmString]
          double ppmDouble = double.tryParse(ppmString) ?? 0.0;

          // Se asegura un mínimo de 1 en [ppmString]
          ppmDouble = ppmDouble == 0 ? 1 : ppmDouble;
          recipe = MaterialHandlers().runMatrixRecipe(
            item: selectedMaterial.materialName,
            ppm: ppmDouble,
          );
          oreItems = MaterialHandlers().getOreItems();
        });
      },
    );
  }

  List<String> _searchItem(String name) {
    materialStringList = originalMaterialStringList;
    List<String> filteredMaterialList = [];
    for (int i = 0; i < materialStringList.length; i++) {
      if (materialStringList[i].toLowerCase().contains(name.toLowerCase())) {
        filteredMaterialList.add(materialStringList[i]);
      }
    }
    if (filteredMaterialList.isEmpty) {
      filteredMaterialList.add('No item match');
    }
    return filteredMaterialList;
  }

  /// Agrega una fabrica a una coleccion y cierra el popup
  Widget _addandCloseButton() {
    return ElevatedButton(
      onPressed: () {
        // Se extrae la informacion de [_itemsPmTextController]
        String ppmString = _itemsPmTextController.text;

        // Se parsea a un double en [ppmString]
        double ppmDouble = double.tryParse(ppmString) ?? 0.0;

        // Se asegura un mínimo de 1 en [ppmString]
        ppmDouble = ppmDouble == 0 ? 1 : ppmDouble;

        if (selectedMaterial.materialName != "") {
          Recipe recipeItem = Recipe(recipe: recipe);
          FactoriesHandlers().addFactoryConfiguration(
            FactoryConfiguration(
              itemName: selectedMaterial.materialName,
              factoryItem: {
                selectedMaterial.materialName: recipeItem,
              },
              outputPm: ppmDouble,
            ),
            widget.collectionName,
          );
          Navigator.of(context).pop(true);
        }
      },
      child: const Text('Add item and close'),
    );
  }

  /// Agrega una fabrica a una coleccion y cierra el popup
  Widget _addButton() {
    return ElevatedButton(
      onPressed: () {
        // Se extrae la informacion de [_itemsPmTextController]
        String ppmString = _itemsPmTextController.text;

        // Se parsea a un double en [ppmString]
        double ppmDouble = double.tryParse(ppmString) ?? 0.0;

        // Se asegura un mínimo de 1 en [ppmString]
        ppmDouble = ppmDouble == 0 ? 1 : ppmDouble;

        if (selectedMaterial.materialName != "") {
          Recipe recipeItemTest = Recipe(recipe: recipe);
          FactoriesHandlers().addFactoryConfiguration(
            FactoryConfiguration(
              itemName: selectedMaterial.materialName,
              factoryItem: {
                selectedMaterial.materialName: recipeItemTest,
              },
              outputPm: ppmDouble,
            ),
            widget.collectionName,
          );
        }
        widget.callBackFunctionOnlySetState();
      },
      child: const Text('Add item'),
    );
  }
}

class DecimalTextInputFormater extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regExp = RegExp(r'^\d*\.?\d*$');
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (regExp.hasMatch(newValue.text)) {
      double value = double.tryParse(newValue.text) ?? 0.0;
      if (value >= 0.0) {
        return newValue;
      }
    }
    return oldValue;
  }
}
