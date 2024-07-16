import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satisfactory_app/handlers/factories_handlers.dart';
import 'package:satisfactory_app/handlers/material_item.dart';

class AddNewCollectionPopup extends StatefulWidget {
  const AddNewCollectionPopup({
    required this.collectionsStringList,
    super.key,
  });

  final List<String> collectionsStringList;

  @override
  State<AddNewCollectionPopup> createState() => _AddNewCollectionPopupState();
}

class _AddNewCollectionPopupState extends State<AddNewCollectionPopup> {
  List<String> collectionsStringList = [];
  Map<String, OreItem> oreItems = {};
  MaterialItem selectedMaterial = MaterialItem();
  int selectedIndex = -1;
  List<List<MaterialItem>> recipe = [];
  bool ready = false;

  final TextEditingController _newCollectionNameController =
      TextEditingController();

  final _formKeyAddNewCollection = GlobalKey<FormState>();

  @override
  void initState() {
    collectionsStringList = widget.collectionsStringList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _showTextFormField();
  }

  Widget _showTextFormField() {
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
            ),
            _createNewCollectionTextFormField(context),
            _sizedBox10(),
            _addButton(),
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

  Widget _createNewCollectionTextFormField(BuildContext context) {
    return Form(
      key: _formKeyAddNewCollection,
      child: TextFormField(
        controller: _newCollectionNameController,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: "New collection name",
          fillColor: Colors.white70,
          suffixIcon: const Icon(Icons.search),
          suffixIconColor: Colors.grey[800],
        ),
        validator: (value) {
          if (_sameName(value)) {
            return "Already exists";
          }
          return null;
        },
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  /// Agrega una fabrica a una coleccion y cierra el popup
  Widget _addButton() {
    final validation =
        _formKeyAddNewCollection.currentState?.validate() ?? false;

    return ElevatedButton(
      onPressed: () {
        if (!validation) {
          return;
        }
        // Se extrae la informacion de [_itemsPmTextController]
        String collectionName = _newCollectionNameController.text;

        FactoriesHandlers().addFactoryCollection(collectionName);

        Navigator.of(context).pop(true);
      },
      child: const Text('Add item to collection and close popup'),
    );
  }

  bool _sameName(String? actualName) {
    String name = actualName ?? "";
    bool sameName = false;

    collectionsStringList.forEach((value) {
      if (name == value) {
        sameName = true;
      }
    });

    return sameName;
  }
}
