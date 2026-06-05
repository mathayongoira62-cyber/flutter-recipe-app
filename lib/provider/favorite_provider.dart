import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> get favorites => _favoriteIds;

  FavoriteProvider();


  // toggle favorite state

  Future<void> toggleFavorite(DocumentSnapshot product) async {
    final user = _auth.currentUser;
    if (user == null) {
      await _ensureSignedIn();
    }

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final productId = product.id;

    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
      await _removeFavorite(uid, productId);
    } else {
      _favoriteIds.add(productId);
      await _addFavorite(uid, productId);
    }

    notifyListeners();
  }


  //check if product is favorite
  bool isFavorite(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }

  Future<void> _ensureSignedIn() async {
    if (_auth.currentUser != null) return;
    await _auth.signInAnonymously();
  }

  // add favorite to firestore under current user
  Future<void> _addFavorite(String uid, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('userFavorites')
          .doc(productId)
          .set({
        'isFavorite': true,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // remove favorite from firestore under current user
  Future<void> _removeFavorite(String uid, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('userFavorites')
          .doc(productId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // load favorites from firestore for current user
  Future<void> loadFavorites() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      await _ensureSignedIn();
    }

    final finalUid = _auth.currentUser?.uid;
    if (finalUid == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(finalUid)
          .collection('userFavorites')
          .get();

      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }


  // Static method to access the provider from any context
  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
