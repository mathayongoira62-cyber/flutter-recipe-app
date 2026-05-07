import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/provider/favorite_provider.dart';
import 'package:recipe_app/utils/constants/colors.dart';

class FoodDetail extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodDetail({super.key, required this.documentSnapshot});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
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
      ),
    );
  }
}
