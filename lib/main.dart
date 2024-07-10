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
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                  border: Border.all(width: 1),
                ),
                height: _screenHeight - 120,
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
                                setState(() {
                                  selectedMaterial = MaterialHandlers()
                                      .getMaterialItem(materials[index]);
                                  recipe = MaterialHandlers().runMatrixRecipe(
                                      item: materials[index] ?? [],
                                      ppm: double.parse(_itemsPmTextController
                                                  .text
                                                  .toString()) ==
                                              0
                                          ? 1
                                          : double.parse(_itemsPmTextController
                                              .text
                                              .toString()));
                                });
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _mainPage(selectedMaterial)
            ],
          ),
        ),
      ],
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

  Widget regularItemCard(MaterialItem material) {
    if (material.ore) {
      return SizedBox(
        height: 200,
        width: 200,
        child: Column(
          children: [
            Text(material.materialName),
            //Text(material.materialId.toString()),
            Text(material.fact),
            Divider(),
            material.oreOutputPm != 0
                ? Text('InputPM: ${material.oreOutputPm}',
                    style: const TextStyle(fontWeight: FontWeight.bold))
                : Container(),
          ],
        ),
      );
    } else if (material.materialId != 0) {
      return SizedBox(
        height: 300,
        width: 200,
        child: Column(
          children: [
            Text(material.materialName),
            //Text(material.materialId.toString()),
            Text(material.fact),
            Text('Output: ${material.recipes['1']!.output.toString()}'),
            Text('Output PM: ${material.recipes['1']!.outputPm.toString()}'),
            Text(
              'Modified Output PM: ${material.recipes['1']!.outputModifiedPm.toString()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(),
            material.recipes['1']!.materials['1']?.input != null
                ? Text(
                    '1 - ${material.recipes['1']!.materials['1']?.materialName}: ${material.recipes['1']!.materials['1']?.inputPm} (${material.recipes['1']!.materials['1']?.inputModifiedPm})')
                : Container(),
            material.recipes['1']!.materials['2']?.input != null
                ? Text(
                    '2 - ${material.recipes['1']!.materials['2']?.materialName}: ${material.recipes['1']!.materials['2']?.inputPm} (${material.recipes['1']!.materials['2']?.inputModifiedPm})')
                : Container(),
            material.recipes['1']!.materials['3']?.input != null
                ? Text(
                    '3 - ${material.recipes['1']!.materials['3']?.materialName}: ${material.recipes['1']!.materials['3']?.inputPm} (${material.recipes['1']!.materials['3']?.inputModifiedPm})')
                : Container(),
            material.recipes['1']!.materials['4']?.input != null
                ? Text(
                    '4 - ${material.recipes['1']!.materials['4']?.materialName}: ${material.recipes['1']!.materials['4']?.inputPm} (${material.recipes['1']!.materials['4']?.inputModifiedPm})')
                : Container(),
          ],
        ),
      );
    } else {
      return Container();
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
        setState(() {
          print(_itemsPmTextController.text);
        });
      },
    );
  }
}
