// ignore_for_file: unused_local_variable

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
    List<List<MaterialItem>> matrixRecipe = [[]];

    matrixRecipe[0].insert(0, materialItems[name]!);

    List<String> initialMaterials = hasMaterials(materialItems[name]!);

    // Altura de la matriz
    int matHei = matrixRecipe.length;
    // Anchura de la matriz
    int matWid = matrixRecipe[0].length;
    // Agrega una fila debajo

    // Agrega la primer fila de receta
    if (initialMaterials.isNotEmpty) {
      // Agrega una fila a la matriz
      matrixRecipe.add([]);

      // Agrega los items de la receta en la nueva fila
      for (int i = 0; i < initialMaterials.length; i++) {
        matrixRecipe[matHei].insert(i, materialItems[initialMaterials[i]]!);
      }
    }

    // Altura de la matriz
    matHei = matrixRecipe.length;
    // Anchura de la matriz
    matWid = matrixRecipe[matHei - 1].length;

    print('matHei $matHei');
    print('matWid $matWid');

    // Guarda la altura a la que se encontró el último item
    int lastHeiItem = 0;

    for (int i = 0; i < matWid; i++) {
      for (int j = 0; j < matHei; j++) {
        try {
          print(matrixRecipe[j][i]);
          print('fila $j');
          print('columna $i');
          lastHeiItem = j;
          print('lastHeiItem: $lastHeiItem');
        } catch (e) {
          print('nulo en: ');
          print('fila $j');
          print('columna $i');
        }
      }
      List<String> materials = hasMaterials(matrixRecipe[lastHeiItem][i]);
      print(materials);

      matrixRecipe.add([]);

      for (int k = 0; k < materials.length; k++) {
        matrixRecipe[lastHeiItem + 1].insert(k + i, materialItems[materials[k]]!);
      }
      
    }

    return matrixRecipe;
  }

  // Busca donde expandir materiales y los expande
  List<List<MaterialItem>> expandTree (List<List<MaterialItem>> matrix) {
    return [];
  }

  // Devuelve si es necesario crecer el arbol
  bool needGrow (List<List<MaterialItem>> matrix) {
    return true;
  }



  List<String> hasMaterials(MaterialItem materialItem) {
    List<String> materials = [];
    materialItem.recipes['1']?.materials.forEach(
      (key, value) {
        materials.add(value.materialName);
      },
    );
    print(materials);
    return materials;
  }
}
