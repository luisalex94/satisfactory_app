import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satisfactory_app/handlers/factories_handlers.dart';
import 'package:satisfactory_app/handlers/factories_item.dart';
import 'package:satisfactory_app/handlers/material_handlers.dart';
import 'package:satisfactory_app/handlers/material_item.dart';

class EditMaterialQuantityPopup extends StatefulWidget {
  const EditMaterialQuantityPopup({
    required this.factoryConfiguration,
    required this.factoryCollectionName,
    required this.factoryConfigurationName,
    required this.callBackFunction,
    super.key,
  });

  final FactoryConfiguration factoryConfiguration;
  final String factoryCollectionName;
  final String factoryConfigurationName;
  final Function callBackFunction;

  @override
  State<EditMaterialQuantityPopup> createState() =>
      _EditMaterialQuantityPopupState();
}

class _EditMaterialQuantityPopupState extends State<EditMaterialQuantityPopup> {
  List<List<MaterialItem>> recipe = [];
  Map<String, OreItem> oreItems = {};

  final TextEditingController _itemsPmTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              widget.factoryConfigurationName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            _sizedBox10(),
            _itemsPm(context),
            _sizedBox10(),
            Row(
              children: [
                _updateButton(),
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

  Widget _itemsPm(BuildContext context) {
    return TextFormField(
      controller: _itemsPmTextController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: "Items per minute",
        fillColor: Colors.white70,
        suffixIcon: const Icon(Icons.play_arrow_rounded),
        suffixIconColor: Colors.grey[800],
      ),
      onFieldSubmitted: (value) {
        _onSubmit();
      },
      onChanged: (value) {
        setState(() {
          // Se extrae la informacion de [_itemsPmTextController]
          String ppmString = value;

          // Se parsea a un double en [ppmString]
          double ppmDouble = double.tryParse(ppmString) ?? 0.0;

          // Se asegura un mínimo de 1 en [ppmString]
          ppmDouble = ppmDouble == 0 ? 1 : ppmDouble;
          recipe = MaterialHandlers().runMatrixRecipe(
            item: widget.factoryConfigurationName,
            ppm: ppmDouble,
          );
          oreItems = MaterialHandlers().getOreItems();
        });
      },
    );
  }

  Widget _updateButton() {
    return ElevatedButton(
      onPressed: () {
        // Se extrae la informacion de [_itemsPmTextController]
        String ppmString = _itemsPmTextController.text;

        // Se parsea a un double en [ppmString]
        double ppmDouble = double.tryParse(ppmString) ?? 0.0;

        // Se asegura un mínimo de 1 en [ppmString]
        ppmDouble = ppmDouble == 0 ? 1 : ppmDouble;

        Recipe recipeItem = Recipe(recipe: recipe);

        FactoryConfiguration factoryConfiguration = FactoryConfiguration(
          itemName: widget.factoryConfigurationName,
          factoryItem: {widget.factoryConfigurationName: recipeItem},
          outputPm: ppmDouble,
        );

        FactoriesHandlers().editFactoryConfiguration(
          factoryConfiguration: factoryConfiguration,
          factoryCollectionName: widget.factoryCollectionName,
          factoryConfigurationName: widget.factoryConfigurationName,
        );
        Navigator.of(context).pop();
      },
      child: const Text("Actualiza item"),
    );
  }

  void _onSubmit() {
    // Se extrae la informacion de [_itemsPmTextController]
    String ppmString = _itemsPmTextController.text;

    // Se parsea a un double en [ppmString]
    double ppmDouble = double.tryParse(ppmString) ?? 0.0;

    // Se asegura un mínimo de 1 en [ppmString]
    ppmDouble = ppmDouble == 0 ? 1 : ppmDouble;

    Recipe recipeItem = Recipe(recipe: recipe);

    FactoryConfiguration factoryConfiguration = FactoryConfiguration(
      itemName: widget.factoryConfigurationName,
      factoryItem: {widget.factoryConfigurationName: recipeItem},
      outputPm: ppmDouble,
    );

    FactoriesHandlers().editFactoryConfiguration(
      factoryConfiguration: factoryConfiguration,
      factoryCollectionName: widget.factoryCollectionName,
      factoryConfigurationName: widget.factoryConfigurationName,
    );
    Navigator.of(context).pop();
  }
}
