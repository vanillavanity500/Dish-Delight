import 'dart:convert';
import 'package:dish_delight/model/recipes_model_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = '70d8eb9f2a8c4b2ca8e6842ba69e58e5';
  static const String apiBaseURL = 'https://api.spoonacular.com/recipes';

  Future<List<dynamic>> fetchTotalRecipes({required int number}) async {
    try {
      final response = await http.get(
          Uri.parse('$apiBaseURL/complexSearch?apiKey=$apiKey&number=$number'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Failed to load top-rated recipes');
      }
    } catch (e) {
      throw Exception('[Failed to fetch top-rated recipes]: $e');
    }
  }

  Future<Recipes> fetchRecipeById(int id) async {
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/recipes/$id/information?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      return Recipes.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch recipe');
    }
  }

  Future<List<dynamic>> fetchTopRatedRecipes() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiBaseURL/complexSearch?apiKey=$apiKey&sort=rating&number=10'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'] ?? [];
      } else {
        throw Exception('Failed to load top-rated recipes');
      }
    } catch (e) {
      throw Exception('[Failed to fetch top-rated recipes]: $e');
    }
  }

  Future<List<dynamic>> fetchVegetarianRecipes() async {
    final response = await http.get(Uri.parse(
        '$apiBaseURL/complexSearch?apiKey=$apiKey&diet=vegetarian&number=10'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load vegetarian recipes');
    }
  }

  Future<List<dynamic>> fetchQuickAndEasyRecipes() async {
    final response = await http.get(Uri.parse(
        '$apiBaseURL/complexSearch?apiKey=$apiKey&maxReadyTime=30&number=10'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load quick and easy recipes');
    }
  }

  Future<List<dynamic>> fetchBudgetFriendlyRecipes() async {
    final response = await http.get(Uri.parse(
        '$apiBaseURL/complexSearch?apiKey=$apiKey&maxPrice=10&number=10'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load budget-friendly recipes');
    }
  }

  Future<List<dynamic>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse(
          '$apiBaseURL/recipes/complexSearch?apiKey=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> recipes = json.decode(response.body)['results'];
      return recipes;
    } else {
      throw Exception('Failed to search recipes');
    }
  }

}
