import 'dart:convert';

import 'package:dish_delight/model/recipe_model.dart';
import 'package:dish_delight/screens/recipe_details/recipe_details.dart';
import 'package:dish_delight/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _apiService = ApiService();
  static const String apiKey = '70b022e11d1c4d3eb3b695d4e5e38c57';
  static const String apiBaseURL = 'https://api.spoonacular.com/recipes';

  List<dynamic> _searchResults = [];

  Future<List<dynamic>>? futureData;

  @override
  void initState() {
    futureData = _apiService.fetchTotalRecipes(number: 50);
    super.initState();
  }

  void _searchRecipes(String query) async {
    try {
      final results = await _apiService.searchRecipes(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // code to handle menu button press
          },
        ),
        title: const Text(
          'Dish Delight',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: RecipeSearchDelegate(
                  searchController: _searchController,
                  onSubmitted: _searchRecipes,
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Oops! Something went wrong!'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasData) {
            return _buildRecipesList(snapshot.data ?? []);
          } else {
            return const Center(
              child: Text('Ups Something went wrong!'),
            );
          }
        },
      ),
    );
  }
}

class RecipeSearchDelegate extends SearchDelegate<String> {
  final TextEditingController searchController;
  final Function(String) onSubmitted;
  final ApiService apiService = ApiService();
  RecipeSearchDelegate(
      {required this.searchController, required this.onSubmitted});

  @override
  String get searchFieldLabel => 'Search Recipes';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      onSubmitted(query);
      return const SizedBox.shrink();
    } else {
      return const Center(
        child: Text('Please enter a search query.'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return FutureBuilder<List<dynamic>>(
        future: apiService.searchRecipes(query),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Oops! Something went wrong.'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final List<dynamic> searchResults = snapshot.data!;
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> result = searchResults[index];
                return ListTile(
                  title: Text(result['title']),
                  onTap: () {
                    onSubmitted(result['title']);
                    close(context, result['title']);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('No results found.'),
            );
          }
        },
      );
    }
  }
}

Widget _buildLoadingState() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    height: 120,
    child: ListView.separated(
      itemCount: 5, // replace with actual number of recipes
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          height: 120,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
    ),
  );
}

Widget _buildRecipesList(List<dynamic> dataList) {
  List<RecipeResults> recipes = [];
  for (var data in dataList) {
    recipes.add(RecipeResults.fromJson(data));
  }

  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: recipes.length, // replace with actual number of recipes
    itemBuilder: (BuildContext context, int index) {
      RecipeResults recipe = recipes[index];
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/recipe_details', arguments: {'id': recipe.id!}); 
                },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                // width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    recipe.image ?? '',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.0,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'ID: ${recipe.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.0,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return const SizedBox(height: 8);
    },
  );
}
