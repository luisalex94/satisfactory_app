import '../handlers/material_handlers.dart';

class Engine {
  Map<String, dynamic> recipe (String item) {
    Map<String, dynamic> recipe = {};

    Map<String, dynamic> mainItem = MaterialHandlers().getMaterialInfo(item);

    int countMaterialsRecipe = mainItem['recipes']['1']['materials'].length;

    for (var x = 1 ; x <= countMaterialsRecipe ; x++) {
      print('rrsd ${mainItem['recipes']['1']['materials'][x.toString()]['materialName']}');
    }

    


    return recipe;
  }
}