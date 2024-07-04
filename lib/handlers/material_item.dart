class MaterialItem {
  String materialName = "";
  String fact = "";
  int materialId = 0;
  Map<String, RecipeItem> recipes = {};

  MaterialItem({
    this.materialName = "",
    this.fact = "",
    this.materialId = 0,
    this.recipes = const {},
  });

  factory MaterialItem.fromJson(json) {
    return MaterialItem(
      materialName: json['materialName'] ?? '',
      fact: json['fact'] ?? '',
      materialId: json['materialId'] ?? 0,
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
}
