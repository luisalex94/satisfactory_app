import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satisfactory_app/handlers/material_item.dart';
import 'handlers/material_handlers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Satisfactory recipes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _screenWidth = 0;
  double _screenHeight = 0;
  MaterialItem selectedMaterial = MaterialItem();
  int selectedIndex = -1;
  List<List<MaterialItem>> recipe = [];
  Map<String, OreItem> oreItems = {};

  final TextEditingController _itemsPmTextController = TextEditingController();

  @override
  void initState() {
    _itemsPmTextController.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _screenWidth = constraints.maxWidth;
        _screenHeight = constraints.maxHeight;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: FutureBuilder(
            future: MaterialHandlers().loadJson(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _materialsBar(snapshot.data);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }

  Widget _materialsBar(Map<String, dynamic>? json) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Height: $_screenHeight, width: $_screenWidth',
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                                String name = oreItems.values
                                    .elementAt(index)
                                    .materialName;
                                double quantity =
                                    oreItems.values.elementAt(index).outputPm;
                                return Text(
                                    '$name: ${quantity.toStringAsFixed(2)}');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 10,
                  ),
                  Container(
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
                          const SizedBox(
                            height: 10,
                          ),
                          _findBox(),
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  MaterialHandlers().getMaterialsList().length,
                              itemBuilder: (context, index) {
                                List materials =
                                    MaterialHandlers().getMaterialsList();

                                return ListTile(
                                  title: Text(materials[index]),
                                  selected: selectedIndex == index,
                                  onTap: () {
                                    setState(
                                      () {
                                        selectedMaterial = MaterialHandlers()
                                            .getMaterialItem(materials[index]);
                                        recipe = MaterialHandlers()
                                            .runMatrixRecipe(
                                                item: materials[index] ?? [],
                                                ppm: double.parse(
                                                            _itemsPmTextController
                                                                .text
                                                                .toString()) ==
                                                        0
                                                    ? 1
                                                    : double.parse(
                                                        _itemsPmTextController
                                                            .text
                                                            .toString()));
                                        oreItems =
                                            MaterialHandlers().getOreItems();
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
                  ),
                ],
              ),
              //_mainPage(selectedMaterial)
              const SizedBox(
                height: 10,
                width: 10,
              ),
              _mainPageB(selectedMaterial),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mainPageB(MaterialItem? material) {
    if (material!.materialName != "") {
      int row = recipe.length;
      int column = recipe[0].length;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _columnConstructor(
            column,
            row,
          ),
        ),
      );
    } else {
      return const Text('No info');
    }
  }

  Widget _columnConstructor(int column, int row) {
    List<Widget> mainColumn = [];
    for (int i = 0; i < row; i++) {
      mainColumn.add(regularItemCard(recipe[i][column - 1]));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mainColumn,
    );
  }

  Widget _mainPage(MaterialItem? material) {
    int column = 0;
    int row = 0;
    if (material!.materialName != "") {
      int columnSize = recipe[0].length;
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
            border: Border.all(width: 1),
          ),
          height: _screenHeight - 124,
          width: 1200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(material.materialName),
                Expanded(
                  child: GridView.builder(
                    itemCount: (recipe[0].length * recipe.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: recipe[0].length),
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      column = (index / columnSize).floor();
                      row = index - (column * columnSize);
                      return regularItemCard(recipe[column][row]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
            border: Border.all(width: 1),
          ),
          height: _screenHeight - 124,
          width: 320,
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Selecciona un item'),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget buildB(BuildContext context) {
    // Define el número de filas y columnas
    int n = 10; // número de filas
    int m = 10; // número de columnas

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula el tamaño de cada celda
        double cellWidth = constraints.maxWidth / m;
        double cellHeight = 100; // Altura fija de cada celda (puedes cambiarlo)

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: cellWidth * m,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: cellHeight * n,
                ),
                child: Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: m,
                      childAspectRatio: cellWidth / cellHeight,
                    ),
                    itemCount: n * m,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(4.0),
                        color: Colors.blueAccent,
                        child: Center(
                          child: Text('Item $index'),
                        ),
                      );
                    },
                    physics:
                        NeverScrollableScrollPhysics(), // Desactiva el scroll del GridView
                    shrinkWrap: true,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget regularItemCard(MaterialItem material) {
    if (material.ore) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
          border: Border.all(width: 1),
        ),
        height: 200,
        width: 200,
        child: Column(
          children: [
            Text(material.materialName),
            //Text(material.materialId.toString()),
            Text(material.fact),
            const Divider(),
            material.oreOutputPm != 0
                ? Text('InputPM: ${(material.oreOutputPm.toStringAsFixed(2))}',
                    style: const TextStyle(fontWeight: FontWeight.bold))
                : Container(),
          ],
        ),
      );
    } else if (material.materialId != 0) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
          border: Border.all(width: 1),
        ),
        height: 200,
        width: 200,
        child: Column(
          children: [
            Text(material.materialName),
            //Text(material.materialId.toString()),
            Text(material.fact),
            Text('Output: ${material.recipes['1']!.output.toString()}'),
            Text('Output PM: ${material.recipes['1']!.outputPm.toString()}'),
            Text(
              'Modified Output PM: ${(material.recipes['1']!.outputModifiedPm.toStringAsFixed(2))}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            material.recipes['1']!.materials['1']?.input != null
                ? Text(
                    '1 - ${material.recipes['1']!.materials['1']?.materialName}: ${material.recipes['1']!.materials['1']?.inputPm} (${(material.recipes['1']!.materials['1']?.inputModifiedPm)!.toStringAsFixed(2)})')
                : Container(),
            material.recipes['1']!.materials['2']?.input != null
                ? Text(
                    '2 - ${material.recipes['1']!.materials['2']?.materialName}: ${material.recipes['1']!.materials['2']?.inputPm} (${(material.recipes['1']!.materials['2']?.inputModifiedPm.toStringAsFixed(2))})')
                : Container(),
            material.recipes['1']!.materials['3']?.input != null
                ? Text(
                    '3 - ${material.recipes['1']!.materials['3']?.materialName}: ${material.recipes['1']!.materials['3']?.inputPm} (${(material.recipes['1']!.materials['3']?.inputModifiedPm.toStringAsFixed(2))})')
                : Container(),
            material.recipes['1']!.materials['4']?.input != null
                ? Text(
                    '4 - ${material.recipes['1']!.materials['4']?.materialName}: ${material.recipes['1']!.materials['4']?.inputPm} (${(material.recipes['1']!.materials['4']?.inputModifiedPm.toStringAsFixed(2))})')
                : Container(),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(width: 1),
        ),
        height: 200,
        width: 200,
        //child: const Text('No item'),
      );
    }
  }

  Widget _findBox() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: "Find item",
        fillColor: Colors.white70,
        suffixIcon: const Icon(Icons.search),
        suffixIconColor: Colors.grey[800],
      ),
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
        setState(() {});
      },
    );
  }
}
