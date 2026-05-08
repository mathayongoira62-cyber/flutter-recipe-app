import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/provider/favorite_provider.dart';
import 'package:recipe_app/provider/quantity.dart';
import 'package:recipe_app/utils/constants/colors.dart';
import 'package:recipe_app/widgets/icon_button.dart';
import 'package:recipe_app/widgets/quantity_increment_decrement.dart';
import 'package:provider/provider.dart';

class FoodDetail extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodDetail({super.key, required this.documentSnapshot});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<double> baseAmounts = widget.documentSnapshot['ingredientAmount']
          .map<double>((amount) => double.parse(amount.toString()))
          .toList();

      Provider.of<QuantityProvider>(
        context,
        listen: false,
      ).setBaseIngredientAmounts(baseAmounts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavoriteButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // this is for the Image
                Hero(
                  tag: widget.documentSnapshot['image'],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.documentSnapshot['image']),
                      ),
                    ),
                  ),
                ),

                //this is for the button
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      CIconButton(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      CIconButton(icon: Iconsax.notification, pressed: () {}),
                    ],
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            //for drag handle task
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Iconsax.flash_1, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.documentSnapshot['cal']} Cal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      Text(
                        " . ",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                        ),
                      ),
                      Icon(Iconsax.clock, size: 20, color: Colors.grey),

                      Text(
                        "${widget.documentSnapshot['time']} Min",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  // this is for the rating
                  Row(
                    children: [
                      Icon(Iconsax.star1, color: Colors.amberAccent),
                      Text(
                        widget.documentSnapshot['rate'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("/5"),
                      SizedBox(width: 5),
                      Text(
                        "${widget.documentSnapshot['reviews'.toString()]} Reviews",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ingredient",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),
                          Text(
                            "How may servings?",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.increaseQuantity(),
                        onRemove: () => quantityProvider.decreaseQuantity(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // list of ingredients
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ingredients images
                      Column(
                        children: [
                          ...widget.documentSnapshot['ingredientImage']
                              .map<Widget>(
                                (imageUrl) => Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(imageUrl),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),

                      const SizedBox(width: 20),

                      // ingredient names
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.documentSnapshot['ingredientName']
                            .map<Widget>(
                              (ingredient) => SizedBox(
                                height: 60,
                                child: Center(
                                  child: Text(
                                    ingredient,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      // ingredient amount
                      const Spacer(),
                      Column(
                        children: quantityProvider.updateIngredientAmounts
                            .map<Widget>(
                              (amount) => SizedBox(
                                height: 60,
                                child: Center(
                                  child: Text(
                                    "${amount}gm",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton startCookingAndFavoriteButton(
    FavoriteProvider provider,
  ) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: Text(
              "Star Cooking",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              shape: CircleBorder(
                side: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
            ),
            onPressed: () {
              setState(() {
                provider.toggleFavorite(widget.documentSnapshot);
              });
            },
            icon: Icon(
              provider.isFavorite(widget.documentSnapshot)
                  ? Iconsax.heart5
                  : Iconsax.heart,
              color: provider.isFavorite(widget.documentSnapshot)
                  ? Colors.red
                  : Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
