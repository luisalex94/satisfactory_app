class MaterialItem {
  String materialName = "";
  String fact = "";
  double powerInput = 0.0;
  int materialId = 0;
  bool ore = false;
  Map<String, RecipeItem> recipes = {};

  MaterialItem({
    this.materialName = "",
    this.fact = "",
    this.powerInput = 0,
    this.materialId = 0,
    this.ore = false,
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
      powerInput: json['power_input'] ?? 0.0,
      materialId: json['materialId'] ?? 0,
      ore: json['ore'] ?? false,
      recipes: recipes,
    );
  }

  factory MaterialItem.copyWith(MaterialItem item) {
    int recipesCount = item.recipes.length;
    Map<String, RecipeItem> newRecipes = {};

    /// EN LOS ORE EL RECIPE PUEDE SER CERO!!!!
    for (int i = 1; i <= recipesCount; i++) {
      newRecipes['$i'] = RecipeItem.copyWith(item.recipes['$i']!);
    }
    return MaterialItem(
      fact: item.fact,
      materialId: item.materialId,
      materialName: item.materialName,
      ore: item.ore,
      powerInput: item.powerInput,
      recipes: newRecipes,
    );
  }
}

class RecipeItem {
  double output = 0.0;
  double outputPm = 0.0;
  double outputModifiedPm = 0.0;
  Map<String, Ingredient> materials = {};

  RecipeItem({
    this.output = 0.0,
    this.outputPm = 0.0,
    this.outputModifiedPm = 0.0,
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
      output: json['output'] ?? 0.0,
      outputPm: json['output_pm'] ?? 0.0,
      materials: ingredients,
    );
  }

  factory RecipeItem.copyWith(RecipeItem item) {
    int materialsCount = item.materials.length;
    Map<String, Ingredient> newIngredients = {};

    /// EN LOS ORE EL RECIPE PUEDE SER CERO!!!!
    for (int i = 1; i <= materialsCount; i++) {
      newIngredients['$i'] = Ingredient.copyWith(item.materials['$i']!);
    }
    return RecipeItem(
      materials: newIngredients,
      output: item.output,
      outputModifiedPm: item.outputModifiedPm,
      outputPm: item.outputPm,
    );
  }
}

class Ingredient {
  String materialName = "";
  int materialId = 0;
  double input = 0.0;
  double inputPm = 0.0;
  double inputModifiedPm = 0.0;

  Ingredient({
    this.materialName = "",
    this.materialId = 0,
    this.input = 0.0,
    this.inputPm = 0.0,
    this.inputModifiedPm = 0.0,
  });

  factory Ingredient.fromJson(json) {
    return Ingredient(
      materialName: json['materialName'] ?? '',
      materialId: json['materialId'] ?? 0,
      input: json['input'] ?? 0.0,
      inputPm: json['input_pm'] ?? 0.0,
    );
  }

  factory Ingredient.copyWith(Ingredient item) {
    return Ingredient(
      input: item.input,
      inputModifiedPm: item.inputModifiedPm,
      inputPm: item.inputPm,
      materialId: item.materialId,
      materialName: item.materialName,
    );
  }
}
