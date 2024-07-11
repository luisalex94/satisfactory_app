import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satisfactory_app/cards/regularItemCard.dart';
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
  double _screenHeight = 0;
  MaterialItem selectedMaterial = MaterialItem();
  int selectedIndex = -1;
  List<List<MaterialItem>> recipe = [];
  Map<String, OreItem> oreItems = {};
  bool ready = false;

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
                //return _materialsBar(snapshot.data);
                return body(context);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }

  Widget body(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _showOreItems(),
                    _sizedBox10(),
                    _showListOfItems(),
                  ],
                ),
                _sizedBox10(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight - 20,
                          minWidth: viewportConstraints.maxWidth - 360,
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
                ),
              ],
            ),
          );
        },
      ),
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
                itemCount: MaterialHandlers().getMaterialsList().length,
                itemBuilder: (context, index) {
                  List materials = MaterialHandlers().getMaterialsList();

                  return ListTile(
                    title: Text(materials[index]),
                    selected: selectedIndex == index,
                    onTap: () {
                      setState(
                        () {
                          selectedMaterial = MaterialHandlers()
                              .getMaterialItem(materials[index]);
                          recipe = MaterialHandlers().runMatrixRecipe(
                              item: materials[index] ?? [],
                              ppm: double.parse(_itemsPmTextController.text
                                          .toString()) ==
                                      0
                                  ? 1
                                  : double.parse(
                                      _itemsPmTextController.text.toString()));
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

  Widget _mainPage(MaterialItem? material) {
    if (material!.materialName != "") {
      int row = recipe.length;
      int column = recipe[0].length;
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 400,
                minWidth: 400,
              ),
              child: _columnConstructor(
                column,
                row,
              ),
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
            key: ValueKey('${recipe[i][j].materialId != 0 ? 0 : recipe[i][j].materialId} _$i _$j'),
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

  Widget regularItemCard(MaterialItem material) {
    // CREAR UN NUEVO WIDGET SATEFULL PARA APLICAR SETSTATE SOLOAMENTE A ESTE WIDGET
    if (material.ore) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber[100],
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
      return GestureDetector(
        onTap: () {
          setState(() {
            ready = !ready;
            print('ready: $ready');
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ready ? Colors.blue[100] : Colors.green[100],
            border: Border.all(width: 1),
          ),
          height: 200,
          width: 200,
          child: Column(
            children: [
              Text(material.materialName),
              //Text(material.materialId.toString()),
              Text('${material.fact}: ${material.factQuantity}'),
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
