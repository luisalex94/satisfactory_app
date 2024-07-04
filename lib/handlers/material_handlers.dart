import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import './material_item.dart';

class MaterialHandlers {

  static final MaterialHandlers _instance = MaterialHandlers._internal();

  factory MaterialHandlers() {
    return _instance;
  }

  MaterialHandlers._internal();

  Map<String, dynamic> globalMaterials = {};

  Map<String, MaterialItem> materialItems = {};

  Future<Map<String, dynamic>> loadJson() async {
    String jsonString =
        await rootBundle.loadString('lib/assets/materials.json');

    final jsonResponse = json.decode(jsonString);

    globalMaterials = jsonResponse;

    globalMaterials.forEach((key, value) {
      materialItems[key] = MaterialItem.fromJson(value);
    });

    return jsonResponse;
  }

  List<String> getMaterialsList(Map<String, dynamic>? json) {
    List<String> data = [];
    if (json == null) {
      data = [];
    } else {
      json.forEach((key, value) {
        data.add(key);
      });
      //print(data);
    }
    return data;
  }

  Map<String, dynamic> getMaterialInfo(String name) {
    return globalMaterials[name] ?? {};
  }

  List<List<MaterialItem>> runMatrixRecipe(String name) {
    
    List<List<MaterialItem>> matrixRecipe = [];
    return matrixRecipe;
  }
}
