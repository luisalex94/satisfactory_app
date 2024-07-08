// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import './material_item.dart';

class MaterialHandlers {
  static final MaterialHandlers _instance = MaterialHandlers._internal();

  factory MaterialHandlers() {
    return _instance;
  }

  MaterialHandlers._internal();

  // Mapa de materiales
  Map<String, MaterialItem> materialItems = {};

  // Matriz de receta
  List<List<MaterialItem>> mainMaterialMatrix = [[]];

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
          print('row $j');
          print('column $i');
          lastHeiItem = j;
          print('lastHeiItem: $lastHeiItem');
        } catch (e) {
          print('nulo en: ');
          print('row $j');
          print('column $i');
        }
      }
      List<String> materials = hasMaterials(matrixRecipe[lastHeiItem][i]);
      print(materials);

      matrixRecipe.add([]);

      for (int k = 0; k < materials.length; k++) {
        matrixRecipe[lastHeiItem + 1]
            .insert(k + i, materialItems[materials[k]]!);
      }
    }

    mainMaterialMatrix = matrixRecipe;

    return matrixRecipe;
  }

  // Proceso principal
  List<List<MaterialItem>> runMatrixRecipeB(String item) {
    // Indica si el proceso de crecimiento ha terminado
    bool finish = false;

    // Matriz principal de receta
    List<List<MaterialItem>> recipe = [[]];

    // Material del cual se quiere receta
    MaterialItem mainMaterial = getMaterialItem(item);

    // Agrega el mainMaterial (material objetivo) en la posicion [0][0]
    recipe[0].add(mainMaterial);

    // Ciclo para expandir el arbol de receta
    while (needGrow(recipe)) {
      // Verifica si requiere crecer
      needGrow(recipe) ? finish = false : finish = true;

      // Completa la matriz
      fillWithEmptyMaterialItems(recipe);

      // Imprime la matriz (informativo)
      printMaterials(recipe);

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
            // True: salta la columna a la superior
            // False: crece el arbol
            if (materialMatrix[row][column].ore) {
              row = -1;
            } else {
              print('grow = true');
              if (maxRow - 1 - row == 0) {
                // Agrega una fila debajo, ya que detecta que está en la última fila
                materialMatrix.add([]);
                fillWithEmptyMaterialItems(materialMatrix);
              }
              List<String> newMaterials =
                  hasMaterials(materialMatrix[row][column]);
              if (newMaterials.length > 1) {
                materialMatrix = addColumn(
                  materialMatrix: materialMatrix,
                  column: column + 1,
                );
              }
              int j = 0;
              for (int i = column; i <= newMaterials.length + column - 1; i++) {
                materialMatrix[row + 1][i] = getMaterialItem(newMaterials[j]);
                j++;
              }

              // Sale del flujo total
              row = -1;
              column = maxColumn + 1;
            }
          }
        } catch (e) {
          print('NULO Posición: $row x $column');
          materialMatrix[row].insert(column, emptyMaterialItem());
          print(materialMatrix[row][column]);
        }
      }
    }
    return materialMatrix;
  }

  // Busca donde expandir materiales y los expande
  void expandTreeB() {
    // Altura de la matriz
    int maxRow = mainMaterialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = mainMaterialMatrix[0].length;

    // Recorre column
    for (int column = 0; column < maxColumn; column++) {
      // Recorre row
      for (int row = maxRow - 1; row >= 0; row--) {
        try {
          print('Posición: $row x $column');
          print(mainMaterialMatrix[row][column]);
          if (mainMaterialMatrix[row][column].materialId != 0) {
            print('materialId = ${mainMaterialMatrix[row][column].ore}');
            if (mainMaterialMatrix[row][column].ore) {
              print('grow = false');

              row = -1;
            } else {
              print('grow = true');
              if (maxRow - 1 - row == 0) {
                // Agrega una fila debajo, ya que detecta que está en la última fila
                mainMaterialMatrix.add([]);
              }
              List<String> newMaterials =
                  hasMaterials(mainMaterialMatrix[row][column]);
              if (newMaterials.length > 1) {
                addColumnB(column);
              }
              for (int i = column; i <= newMaterials.length + column - 1; i++) {
                int j = 0;
                mainMaterialMatrix[row + 1]
                    .insert(column, getMaterialItem(newMaterials[j]));
                j++;
              }

              // Sale del flujo total
              row = -1;
              column = maxColumn + 1;
            }
          }
        } catch (e) {
          print('NULO Posición: $row x $column');
          mainMaterialMatrix[row].insert(column, emptyMaterialItem());
          print(mainMaterialMatrix[row][column]);
        }
      }
    }
  }

  // Devuelve si es necesario crecer el arbol
  // Debe entrar una matriz completa
  bool needGrowB() {
    // Altura de la matriz
    int maxRow = mainMaterialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = mainMaterialMatrix[0].length;
    // Indica que el arbol necesita crecer
    bool needGrow = false;

    // Recorre column
    for (int column = 0; column < maxColumn; column++) {
      // Recorre row
      for (int row = maxRow - 1; row >= 0; row--) {
        try {
          // Verifica que MaterialItem no sea vacio
          if (mainMaterialMatrix[row][column].materialId != 0) {
            // Verifica si el MaterialItem es mineral (o fuente)
            if (mainMaterialMatrix[row][column].ore) {
              needGrow = false;
              row = -1;
            } else {
              print('needGrow = true');
              needGrow = true;
              row = -1;
              column = maxColumn + 1;
            }
          }
        } catch (e) {
          print('NULO Posición: $row x $column');
          mainMaterialMatrix[row].insert(column, emptyMaterialItem());
          print(mainMaterialMatrix[row][column]);
        }
      }
    }
    return needGrow;
  }

  // Devuelve si es necesario crecer el arbol
  // Debe entrar una matriz completa
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
            if (materialMatrix[row][column].ore) {
              needGrow = false;
              row = -1;
            } else {
              print('needGrow = true');
              needGrow = true;
              row = -1;
              column = maxColumn + 1;
            }
          }
        } catch (e) {
          print('NULO Posición: $row x $column');
        }
      }
    }
    return needGrow;
  }

  // Devuelve un MaterialItem vacio
  MaterialItem emptyMaterialItem() {
    return MaterialItem();
  }

  // Agrega una columna a la matriz
  // [column] es donde se agrega la nueva columna
  // Entra matriz completa / sale matriz completa
  void addColumnB(int column) {
    // Altura de la matriz
    int maxRow = mainMaterialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = mainMaterialMatrix[0].length;

    // Recorre la matriz en la columna [column] agregando un MaterialItem vacio
    for (int i = 0; i < maxColumn; i++) {
      mainMaterialMatrix[column].insert(i, emptyMaterialItem());
    }
    //return MaterialItem();
  }

  // Agrega una columna a la matriz
  // [column] es donde se agrega la nueva columna
  // Debe entrar matriz completa
  // Sale matriz completa
  List<List<MaterialItem>> addColumn({
    required List<List<MaterialItem>> materialMatrix,
    required int column,
  }) {
    fillWithEmptyMaterialItems(materialMatrix);
    // Altura de la matriz
    int maxRow = materialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = materialMatrix[0].length;

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

    // Guarda la altura a la que se encontró el último item
    int lastHeiItem = 0;

    // Recorre column
    for (int column = 0; column < maxColumn; column++) {
      for (int row = 0; row < maxRow; row++) {
        try {
          print('Posición: $row x $column');
          print(materialMatrix[row][column]);
          lastHeiItem = row;
        } catch (e) {
          print('NULO Posición: $row x $column');
          materialMatrix[row].insert(column, emptyMaterialItem());
          print(materialMatrix[row][column]);
        }
      }
    }
    return materialMatrix;
  }

  // Rellena la matriz con materialItem vacios
  void fillWithEmptyMaterialItemsB() {
    // Altura de la matriz
    int maxRow = mainMaterialMatrix.length;
    // Guarda el numero con la fila mas ancha
    int maxColumn = 0;

    // Busca la fila mas larga
    for (int i = 0; i < maxRow; i++) {
      if (mainMaterialMatrix[i].length > maxColumn) {
        maxColumn = mainMaterialMatrix[i].length;
      }
    }

    // Guarda la altura a la que se encontró el último item
    int lastHeiItem = 0;

    // Recorre column
    for (int column = 0; column < maxColumn; column++) {
      for (int row = 0; row < maxRow; row++) {
        try {
          print('Posición: $row x $column');
          print(mainMaterialMatrix[row][column]);
          lastHeiItem = row;
        } catch (e) {
          print('NULO Posición: $row x $column');
          mainMaterialMatrix[row].insert(column, emptyMaterialItem());
          print(mainMaterialMatrix[row][column]);
        }
      }
    }
    print('paso');
  }

  // Imprime los id de los materiales en la matriz
  void printMaterials(List<List<MaterialItem>> materialMatrix) {
    // Filas de la matriz
    int maxRow = materialMatrix.length;
    // Columnas de la matriz
    int maxColumn = materialMatrix[maxRow - 1].length;

    print('maxRow $maxRow');
    print('matWid $maxColumn');

    // Guarda la altura a la que se encontró el último item
    int lastHeiItem = 0;

    for (int row = 0; row < maxRow; row++) {
      for (int column = 0; column < maxColumn; column++) {
        //stdout.write('Posición: $row x $column');
        stdout.write('${materialMatrix[row][column].materialId} ');
      }
      stdout.writeln();
    }
  }

  // Imprime los id de los materiales en la matriz mainMaterialMatrix
  void printMaterialsB() {
    // Filas de la matriz
    int maxRow = mainMaterialMatrix.length;
    // Columnas de la matriz
    int maxColumn = mainMaterialMatrix[maxRow - 1].length;

    print('maxRow $maxRow');
    print('matWid $maxColumn');

    // Guarda la altura a la que se encontró el último item
    int lastHeiItem = 0;

    for (int row = 0; row < maxRow; row++) {
      for (int column = 0; column < maxColumn; column++) {
        //stdout.write('Posición: $row x $column');
        stdout.write('${mainMaterialMatrix[row][column].materialId} ');
      }
      stdout.writeln();
    }
  }

  // Metodo test para ver como opera la lista
  void testAdd() {
    // Inicial:
    // 6 0
    // 3 5
    // 2 4
    // 0 0

    // Esto le agrega filas
    mainMaterialMatrix.add([]);
    // Despues de mainMaterialMatrix.add([]):
    // 6 0
    // 3 5
    // 2 4
    // 0 0
    // 0 0 <- NUEVO

    // Esto le agrega columnas
    // NOTA: El insert no puede ser mayor a n+1 columnas
    // mainMaterialMatrix[2].insert(3, emptyMaterialItem()); <- por el 3 se rompe, por que
    // n filas es 1, n+1 = 2, siempre debe ser n+1.
    mainMaterialMatrix[2].insert(2, emptyMaterialItem());
    // Despues de mainMaterialMatrix[2].insert(2, emptyMaterialItem()):
    // 6 0
    // 3 5
    // 2 4 0 <- NUEVO
    // 0 0
    // 0 0

    print('paso');
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
