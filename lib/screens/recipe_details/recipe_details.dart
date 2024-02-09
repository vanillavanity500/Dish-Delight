// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dish_delight/model/recipes_model_list.dart';
import 'package:dish_delight/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final int id;
  const RecipeDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final api = ApiService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int id = args['id']; 
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: FutureBuilder<dynamic>(
          future: api.fetchRecipeById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Ups Something went wrong.'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              Recipes recipe = snapshot.data;
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 350,
                      child: Image.network(
                        recipe.image ?? '',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                recipe.creditsText ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                color: Colors.grey.shade100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.time,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "${recipe.readyInMinutes} min",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.heart,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "${recipe.aggregateLikes}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/calories.png',
                                          height: 20,
                                          width: 20,
                                          color: Colors.amber.shade600,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          recipe.healthScore.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Description',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900),
                              ),
                              Text(
                                recipe.summary ?? '',
                                textAlign: TextAlign.left,
                                maxLines: 10,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Ingredients',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: recipe.extendedIngredients!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: ListTile(
                                      tileColor: Colors.grey.shade100,
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          recipe.extendedIngredients![index]
                                                  .image ??
                                              '',
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              height: 40,
                                              width: 40,
                                            );
                                          },
                                        ),
                                      ),
                                      title: Text(
                                        recipe.extendedIngredients![index]
                                                .name ??
                                            '',
                                        style: TextStyle(
                                            color: Colors.blue.shade800),
                                      ),
                                      subtitle: Text(recipe
                                              .extendedIngredients![index]
                                              .aisle ??
                                          ''),
                                      trailing: Text(
                                        "${recipe.extendedIngredients![index].measures!.metric!.amount} g",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Instructions',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                child: Text(
                                  recipe.instructions ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('Oops Something went wrong.'),
              );
            }
          }),
    );
  }
}
