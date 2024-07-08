import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import './material_item.dart';
import 'dart:developer';

class MaterialHandlers {
  static final MaterialHandlers _instance = MaterialHandlers._internal();

  factory MaterialHandlers() {
    return _instance;
  }

  MaterialHandlers._internal();

  // Mapa de materiales
  Map<String, MaterialItem> materialItems = {};

  /// Carga los materiales a materialItems desde el json
  Future<Map<String, dynamic>> loadJson() async {
    // Se obtiene el json
    String jsonString =
        await rootBundle.loadString('lib/assets/materials.json');
    // Se decodifica la informacion
    final jsonResponse = json.decode(jsonString);
    // Se recorre el jsonResponse para cargar al mapa de materiales
    jsonResponse.forEach((key, value) {
      materialItems[key] = MaterialItem.fromJson(value);
    });

    return jsonResponse;
  }

  /// Devuelve una lista con los nombres de cada item
  List<String> getMaterialsList() {
    // Variable para almacenar en una lista los nombres de cada item
    List<String> data = [];
    // Recorre el mapa de materiales para agregar a la lista cada key (nombre)
    materialItems.forEach((key, value) {
      data.add(key);
    });
    // Devuelve la lista de nombres
    return data;
  }

  /// Devuelve un [MaterialItem]
  MaterialItem getMaterialItem(String name) {
    return materialItems[name]!;
  }

  /// Proceso principal
  List<List<MaterialItem>> runMatrixRecipe(String item) {
    // Matriz principal de receta
    List<List<MaterialItem>> recipe = [[]];

    // Material del cual se quiere receta
    MaterialItem mainMaterial = getMaterialItem(item);

    // Agrega el mainMaterial (material objetivo) en la posicion [0][0]
    recipe[0].add(mainMaterial);

    // Ciclo para expandir el arbol de receta
    while (needGrow(recipe)) {
      // Completa la matriz
      fillWithEmptyMaterialItems(recipe);

      // Expane el arbol de materiales
      expandTree(recipe);
    }

    // Imprime la matriz (informativo)
    printMaterials(recipe);

    return recipe;
  }

  // Busca donde expandir materiales y los expande
  List<List<MaterialItem>> expandTree(List<List<MaterialItem>> materialMatrix) {
    // Altura de la matriz
    int maxRow = materialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = materialMatrix[0].length;

    // Recorre column
    for (int column = 0; column < maxColumn; column++) {
      // Recorre row
      for (int row = maxRow - 1; row >= 0; row--) {
        try {
          // Verifica que la [row][column] actual no sea un MaterialItem vacio
          if (materialMatrix[row][column].materialId != 0) {
            // Verifica si el MaterialItem es mineral (o fuente)
            // True: salta a la siguiente columna
            // False: crece el arbol
            if (materialMatrix[row][column].ore) {
              row = -1;
            } else {
              // Revisa si está en la última fila, si si, agrega una adicional para los nuevos materiales
              if (maxRow - 1 - row == 0) {
                // Agrega una fila debajo, ya que detecta que está en la última fila
                materialMatrix.add([]);
                // Llena la fila debajo con materiales vacios
                fillWithEmptyMaterialItems(materialMatrix);
              }
              // Obtiene la lista de materiales nuevos a agregarse
              List<String> newMaterials =
                  hasMaterials(materialMatrix[row][column]);
              // Si la lista es mayor a uno, se agrega una columna adicional para los nuevos materiales
              if (newMaterials.length > 1) {
                materialMatrix = addColumn(
                  materialMatrix: materialMatrix,
                  column: column + 1,
                );
              }
              // Contador para recorrer lista de materiales
              int j = 0;
              // Recorre desde la columna original, en fila + 1, para ir agregando los nuevos materiales
              for (int i = column; i <= newMaterials.length + column - 1; i++) {
                // Agrega el material
                materialMatrix[row + 1][i] = getMaterialItem(newMaterials[j]);
                // Aumenta el contador para continuar recorriendo la lista de materiales
                j++;
              }
              // Sale del flujo total
              row = -1;
              column = maxColumn + 1;
            }
          }
        } catch (e) {
          log('ERROR en -expandTree- posición: $row x $column');
        }
      }
    }
    return materialMatrix;
  }

  /// Devuelve bool si debe crecer el arbol.
  /// [materialMatrix] debe entrar como matriz completa.
  bool needGrow(List<List<MaterialItem>> materialMatrix) {
    // Altura de la matriz
    int maxRow = materialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = materialMatrix[0].length;
    // Indica que el arbol necesita crecer
    bool needGrow = false;

    // Recorre column
    for (int column = 0; column < maxColumn; column++) {
      // Recorre row
      for (int row = maxRow - 1; row >= 0; row--) {
        try {
          // Verifica que MaterialItem no sea vacio
          if (materialMatrix[row][column].materialId != 0) {
            // Verifica si el MaterialItem es mineral (o fuente)
            // True: salta a la siguiente columna
            // False: indica crecimiento y termina el proceso
            if (materialMatrix[row][column].ore) {
              needGrow = false;
              row = -1;
            } else {
              needGrow = true;
              row = -1;
              column = maxColumn + 1;
            }
          }
        } catch (e) {
          log('ERROR en -needGrow- posición: $row x $column');
        }
      }
    }
    return needGrow;
  }

  // Agrega una columna a la matriz
  // [column] es donde se agrega la nueva columna
  // Debe entrar matriz completa
  // Sale matriz completa
  List<List<MaterialItem>> addColumn({
    required List<List<MaterialItem>> materialMatrix,
    required int column,
  }) {
    // Rellena los espacios antes de empezar
    fillWithEmptyMaterialItems(materialMatrix);
    // Altura de la matriz
    int maxRow = materialMatrix.length;

    // Recorre la matriz en la columna [column] agregando un MaterialItem vacio
    for (int i = 0; i < maxRow; i++) {
      materialMatrix[i].insert(column, emptyMaterialItem());
    }
    return materialMatrix;
  }

  // Rellena la matriz con materialItem vacios
  List<List<MaterialItem>> fillWithEmptyMaterialItems(
      List<List<MaterialItem>> materialMatrix) {
    // Altura de la matriz
    int maxRow = materialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = 0;

    // Busca la fila mas larga
    for (int i = 0; i < maxRow; i++) {
      if (materialMatrix[i].length > maxColumn) {
        maxColumn = materialMatrix[i].length;
      }
    }

    // Recorre column
    for (int column = 0; column < maxColumn; column++) {
      for (int row = 0; row < maxRow; row++) {
        try {
          // Contiene MaterialItem valido
          materialMatrix[row][column];
        } catch (e) {
          // Agrega MaterialItem valido
          materialMatrix[row].insert(column, emptyMaterialItem());
        }
      }
    }
    return materialMatrix;
  }

  // Imprime los id de los materiales en la matriz
  void printMaterials(List<List<MaterialItem>> materialMatrix) {
    // Filas de la matriz
    int maxRow = materialMatrix.length;
    // Columnas de la matriz
    int maxColumn = materialMatrix[maxRow - 1].length;

    for (int row = 0; row < maxRow; row++) {
      for (int column = 0; column < maxColumn; column++) {
        //stdout.write('Posición: $row x $column');
        stdout.write('${materialMatrix[row][column].materialId} ');
      }
      stdout.writeln();
    }
  }

  /// Devuelve un MaterialItem vacio
  MaterialItem emptyMaterialItem() {
    return MaterialItem();
  }

  /// Devuelve una lista de los materiales de la receta
  List<String> hasMaterials(MaterialItem materialItem) {
    List<String> materials = [];
    if (!materialItem.ore) {
      materialItem.recipes['1']?.materials.forEach(
        (key, value) {
          materials.add(value.materialName);
        },
      );
    }
    return materials;
  }
}
