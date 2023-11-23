import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? id;
  String? fullName;
  String? email;
  String? imageUrl;
  bool? loggedIn;
  Map<String, bool> wishlist;

  Auth({
    required this.id,
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.wishlist,
    required this.loggedIn,
  });

  final authUser = FirebaseAuth.instance.currentUser!;

  var wishRef = FirebaseFirestore.instance.collection('wishlist');
  var items = [];
  var data;
  Future<void> dataFetch() async {
    data = await wishRef.doc(authUser.email).get();
  }

  Future<bool> dataExists() async {
    var data = await wishRef.doc(authUser.email).get();
    return data.exists;
  }

  Future<bool> itemExists(id) async {
    var data = await wishRef.doc(authUser.email).get();
    // notifyListeners();
    return data.data()?['items'].any(
          (obj) => obj['id'] == id,
        );
  }

  void toggleWishlist(String id) {
    var key = wishlist.containsKey(id);
    if (key) {
      wishlist.remove(id);
    } else {
      wishlist[id] = true;
    }
    notifyListeners();
  }

  void toggleAuthState(bool value) {
    loggedIn = value;
    notifyListeners();
  }
}
