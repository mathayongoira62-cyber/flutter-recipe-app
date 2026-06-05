import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FoodItemSkeleton extends StatelessWidget {
  const FoodItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(right: 10),

      child: Shimmer.fromColors(

        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // image skeleton
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            const SizedBox(height: 10),

            // title skeleton
            Container(
              width: 120,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 10),

            // subtitle skeleton
            Container(
              width: 80,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}