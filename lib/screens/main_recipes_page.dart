import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satisfactory_app/cards/regularItemCard.dart';
import 'package:satisfactory_app/handlers/material_handlers.dart';
import 'package:satisfactory_app/handlers/material_item.dart';
import 'package:satisfactory_app/screens/arguments/arguments.dart';

class MainRecipesPage extends StatefulWidget {
  const MainRecipesPage({super.key});

  @override
  State<MainRecipesPage> createState() => _MainRecipesPageState();
}

class _MainRecipesPageState extends State<MainRecipesPage> {
  List<String> materialStringList = [];
  List<String> originalMaterialStringList = [];
  Map<String, OreItem> oreItems = {};
  double _screenHeight = 0;
  MaterialItem selectedMaterial = MaterialItem();
  int selectedIndex = -1;
  List<List<MaterialItem>> recipe = [];
  bool ready = false;

  final TextEditingController _itemsPmTextController = TextEditingController();
  final TextEditingController _searchItemController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    MainRecipesPageArguments arguments =
        ModalRoute.of(context)!.settings.arguments as MainRecipesPageArguments;
    materialStringList = arguments.materialStringList;
    oreItems = arguments.oreItems;
    originalMaterialStringList = List.from(materialStringList);
    super.didChangeDependencies();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Recipes'),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          _screenHeight = viewportConstraints.maxHeight;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                _leftColumn(),
                _sizedBox10(),
                _mainBody(context, viewportConstraints),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _leftColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _showOreItems(),
        _sizedBox10(),
        _showListOfItems(),
      ],
    );
  }

  Widget _mainBody(BuildContext context, BoxConstraints viewportConstraints) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              minWidth: viewportConstraints.maxWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _mainPage(selectedMaterial),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPage(MaterialItem? material) {
    if (material!.materialName != "") {
      int row = recipe.length;
      int column = recipe[0].length;
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: _columnConstructor(
              column,
              row,
            ),
          ),
        );
      });
    } else {
      return const Text('No info');
    }
  }

  Widget _columnConstructor(int column, int row) {
    List<Widget> mainColumn = [];
    for (int i = 0; i < row; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < column; j++) {
        rowChildren.add(
          Regularitemcard(
            material: recipe[i][j],
            key: ValueKey(
                '${recipe[i][j].materialId != 0 ? 0 : recipe[i][j].materialId} _$i _$j'),
          ),
        );
        rowChildren.add(
          const SizedBox(
            width: 10,
            height: 10,
          ),
        );
      }
      mainColumn.add(
        Row(
          children: rowChildren,
        ),
      );
      mainColumn.add(
        const SizedBox(
          width: 10,
          height: 10,
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mainColumn,
    );
  }

  Widget _showOreItems() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
        border: Border.all(width: 1),
      ),
      height: 300,
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: oreItems.length,
                itemBuilder: (BuildContext context, int index) {
                  String name = oreItems.values.elementAt(index).materialName;
                  double quantity = oreItems.values.elementAt(index).outputPm;
                  return Text('$name: ${quantity.toStringAsFixed(2)}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showListOfItems() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black12,
        border: Border.all(width: 1),
      ),
      height: _screenHeight - 430,
      width: 320,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            )
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: "Items per minute",
        fillColor: Colors.white70,
        suffixIcon: const Icon(Icons.search),
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
}
