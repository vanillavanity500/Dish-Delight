class RecipeModel {
  List<RecipeResults>? Reciperesults;
  int? offset;
  int? number;
  int? totalRecipeResults;

  RecipeModel({this.Reciperesults, this.offset, this.number, this.totalRecipeResults});

  RecipeModel.fromJson(Map<String, dynamic> json) {
    if (json['Reciperesults'] != null) {
      Reciperesults = <RecipeResults>[];
      json['Reciperesults'].forEach((v) {
        Reciperesults!.add(RecipeResults.fromJson(v));
      });
    }
    offset = json['offset'];
    number = json['number'];
    totalRecipeResults = json['totalRecipeResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (Reciperesults != null) {
      data['Reciperesults'] = Reciperesults!.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    data['number'] = number;
    data['totalRecipeResults'] = totalRecipeResults;
    return data;
  }
}

class RecipeResults {
  int? id;
  String? title;
  String? image;
  String? imageType;

  RecipeResults({this.id, this.title, this.image, this.imageType});

  RecipeResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    imageType = json['imageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['imageType'] = imageType;
    return data;
  }
}