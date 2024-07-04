class MaterialItem {
  String materialName = "";
  String fact = "";
  int powerInput = 0;
  int materialId = 0;
  Map<String, RecipeItem> recipes = {};

  MaterialItem({
    this.materialName = "",
    this.fact = "",
    this.powerInput = 0,
    this.materialId = 0,
    this.recipes = const {},
  });

  factory MaterialItem.fromJson(json) {
    Map<String, RecipeItem> recipes = {};
    if (json['recipes'] == null || json['recipes'].isEmpty) {
      recipes = {};
    } else {
      json['recipes'].forEach((key, value) {
        recipes[key] = RecipeItem.fromJson(value);
      });
    }
    return MaterialItem(
      materialName: json['materialName'] ?? '',
      fact: json['fact'] ?? '',
      powerInput: json['power_input'] ?? 0,
      materialId: json['materialId'] ?? 0,
      recipes: recipes,
    );
  }
}

class RecipeItem {
  int output = 0;
  int outputPm = 0;
  Map<String, Ingredient> materials = {};

  RecipeItem({
    this.output = 0,
    this.outputPm = 0,
    this.materials = const {},
  });

  factory RecipeItem.fromJson(json) {
    Map<String, Ingredient> ingredients = {};
    if (json['materials'] == null || json['materials'].isEmpty) {
      ingredients = {};
    } else {
      json['materials'].forEach((key, value) {
        ingredients[key] = Ingredient.fromJson(value);
      });
    }
    return RecipeItem(
      output: json['output'] ?? 0,
      outputPm: json['output_pm'] ?? 0,
      materials: ingredients,
    );
  }
}

class Ingredient {
  String materialName = "";
  int materialId = 0;
  int input = 0;
  int inputPm = 0;

  Ingredient({
    this.materialName = "",
    this.materialId = 0,
    this.input = 0,
    this.inputPm = 0,
  });

  factory Ingredient.fromJson(json) {
    return Ingredient(
      materialName: json['materialName'] ?? '',
      materialId: json['materialId'] ?? 0,
      input: json['input'] ?? 0,
      inputPm: json['input_pm'] ?? 0,
    );
  }
}
