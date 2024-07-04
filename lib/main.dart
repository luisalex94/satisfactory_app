import 'package:flutter/material.dart';
import 'handlers/material_handlers.dart';
import 'handlers/engine.dart';
import 'handlers/material_item.dart';

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
  Map<String, dynamic> selectedMaterial = {};
  int selectedIndex = -1;

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
                      _findBox(),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              MaterialHandlers().getMaterialsList(json).length,
                          itemBuilder: (context, index) {
                            List materials =
                                MaterialHandlers().getMaterialsList(json);

                            return ListTile(
                              title: Text(materials[index]),
                              selected: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedMaterial = MaterialHandlers()
                                      .getMaterialInfo(materials[index]);
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

  Widget _mainPage(Map<String, dynamic> material) {
    if (material == {} || material.isEmpty) {
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Choose item')],
            ),
          ),
        ),
      );
    } else {
      var dt = Engine().recipe(material['materialName']);
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(material['materialName']),
                
                //GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: items.)
              ],
            ),
          ),
        ),
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
}
