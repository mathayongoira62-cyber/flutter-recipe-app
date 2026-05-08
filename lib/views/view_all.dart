import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/utils/constants/colors.dart';
import 'package:recipe_app/widgets/food_display.dart';
import 'package:recipe_app/widgets/icon_button.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference completeApp = FirebaseFirestore.instance.collection(
    "Complete-Flutter-App",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,

      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,

        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CIconButton(
            icon: Icons.arrow_back_ios_new,
            pressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        title: const Text(
          "Quick & Easy",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        actions: [
          CIconButton(icon: Iconsax.notification, pressed: () {}),
          const SizedBox(width: 15),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 5),

        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: completeApp.snapshots(),

              builder: (context, streamSnapshot) {
                // Loading
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (streamSnapshot.hasError) {
                  return Center(child: Text("Something went wrong"));
                }

                // No data
                if (!streamSnapshot.hasData ||
                    streamSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                // Data available
                return GridView.builder(
                  itemCount: streamSnapshot.data!.docs.length,

                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                  ),

                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];

                    return Column(
                      children: [
                        FoodItemsDisplay(documentSnapshot: documentSnapshot),
                        Row(
                          children: [
                            Icon(Iconsax.star1, color: Colors.amberAccent),
                            Text(
                              documentSnapshot['rate'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("/5"),
                            SizedBox(width: 5),
                            Text(
                              "${documentSnapshot['reviews'.toString()]} Reviews",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
