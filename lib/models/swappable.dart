import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapsta/models/swap.dart';

class Swappable {
  final String id;
  final String name;
  final List<String> imageUrls;
  final String description;
  final String category;
  final String ownerName;
  final String ownerId;
  final String ownerImageUrl;
  final double condition;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryEmoji;
  final DateTime? swappedAt;
  final int? swapRequests;
  final bool? swapped;

  Swappable({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.description,
    required this.category,
    required this.ownerName,
    required this.ownerId,
    required this.ownerImageUrl,
    required this.condition,
    required this.createdAt,
    required this.updatedAt,
    this.categoryEmoji,
    this.swapRequests,
    this.swappedAt,
    required this.swapped,
  });
}

class SwappableProvider extends ChangeNotifier {
  List<Swappable> _swappables = [];
  bool isFetching = false;
  List<Swap> _sentSwaps = [];
  List<Swap> _recievedSwaps = [];
  List<Swap> _historySwaps = [];
  List<Swap> get recievedSwaps => _recievedSwaps;
  List<Swap> get sentSwaps => _sentSwaps;
  List<Swap> get historySwap => _historySwaps;
  List<Swappable> get swappables => _swappables;
  SwappableProvider() {
    fetchSwappables();
    fetchSwaps(); // Call the function to fetch data from Firebase
  }

  void clearData() {
    _sentSwaps = [];
    _recievedSwaps = [];
  }

  Future<void> fetchSwappables() async {
    isFetching = true;
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('items').get();
      final swappables = querySnapshot.docs.map((doc) {
        final data = doc.data();
        if (data['swapped'] == false) {
          return Swappable(
            id: doc.id,
            name: data['name'],
            imageUrls: List<String>.from(data['imageUrls']),
            description: data['description'],
            category: data['category'],
            ownerName: data['ownerName'],
            ownerId: data['ownerId'],
            ownerImageUrl: data['ownerImageUrl'],
            condition: data['condition'].toDouble(),
            createdAt: data['createdAt'].toDate(),
            updatedAt: data['updatedAt'].toDate(),
            swapRequests: data['swapRequests'],
            swapped: data['swapped'],
          );
        } else {
          return [];
        }
      }).toList();

      _swappables = swappables.whereType<Swappable>().toList();
      print(_swappables);
      isFetching = false;
      notifyListeners();
    } catch (error) {
      print('Error fetching swappables: $error');
    }
  }

  Future<void> fetchSwaps() async {
    clearData();
    try {
      final authUser = FirebaseAuth.instance.currentUser!;
      final querySnapshot =
          await FirebaseFirestore.instance.collection('swaps').get();
      final requestSwappables = querySnapshot.docs.map((doc) {
        final data = doc.data();
        if (data['requesterId'] == authUser.email &&
            data['status'] == 'requested') {
          return Swap(
            id: data['id'],
            requesterId: data['requesterId'],
            requesterName: data['requesterName'],
            requesterImage: data['requesterImage'],
            ownerId: data['ownerId'],
            ownerName: data['ownerName'],
            ownerImage: data['ownerImage'],
            requesterItemId: data['requestItemId'],
            requesterItemName: data['requesterItemName'],
            requesterItemImages: List<String>.from(data['requesterItemImages']),
            requesterItemDescription: data['requesterItemDescription'],
            requesterItemCategory: data['requesterItemCategory'],
            requesterItemCreatedAt:
                DateTime.parse(data['requesterItemCreatedAt']),
            requesterItemUpdatedAt:
                DateTime.parse(data['requesterItemUpdatedAt']),
            requesterItemCondition: data['requesterItemCondition'].toDouble(),
            ownerItemId: data['ownerItemId'],
            ownerItemName: data['ownerItemName'],
            ownerItemImages: List<String>.from(data['ownerItemImages']),
            ownerItemDescription: data['ownerItemDescription'],
            ownerItemCategory: data['ownerItemCategory'],
            ownerItemCreatedAt: DateTime.parse(data['ownerItemCreatedAt']),
            ownerItemUpdatedAt: DateTime.parse(data['ownerItemUpdatedAt']),
            ownerItemCondition: data['ownerItemCondition'].toDouble(),
            isAccepted: data['status'] == 'requested' ? false : true,
          );
        } else {
          return [];
        }
      }).toList();
      _sentSwaps = requestSwappables.whereType<Swap>().toList();

      final recievedSwappables = querySnapshot.docs.map((doc) {
        final data = doc.data();
        if (data['ownerId'] == authUser.email &&
            data['status'] == 'requested') {
          return Swap(
            id: data['id'],
            requesterId: data['requesterId'],
            requesterName: data['requesterName'],
            requesterImage: data['requesterImage'],
            ownerId: data['ownerId'],
            ownerName: data['ownerName'],
            ownerImage: data['ownerImage'],
            requesterItemId: data['requestItemId'],
            requesterItemName: data['requesterItemName'],
            requesterItemImages: List<String>.from(data['requesterItemImages']),
            requesterItemDescription: data['requesterItemDescription'],
            requesterItemCategory: data['requesterItemCategory'],
            requesterItemCreatedAt:
                DateTime.parse(data['requesterItemCreatedAt']),
            requesterItemUpdatedAt:
                DateTime.parse(data['requesterItemUpdatedAt']),
            requesterItemCondition: data['requesterItemCondition'].toDouble(),
            // requesterItemCategoryEmoji: entry['requesterItemCategoryEmoji'],
            ownerItemId: data['ownerItemId'],
            ownerItemName: data['ownerItemName'],
            ownerItemImages: List<String>.from(data['ownerItemImages']),
            ownerItemDescription: data['ownerItemDescription'],
            ownerItemCategory: data['ownerItemCategory'],
            ownerItemCreatedAt: DateTime.parse(data['ownerItemCreatedAt']),
            ownerItemUpdatedAt: DateTime.parse(data['ownerItemUpdatedAt']),
            ownerItemCondition: data['ownerItemCondition'].toDouble(),
            // ownerItemCategoryEmoji: entry['ownerItemCategoryEmoji'],
            isAccepted: data['status'] == 'requested' ? false : true,
          );
        } else {
          return [];
        }
      }).toList();
      _recievedSwaps = recievedSwappables.whereType<Swap>().toList();

      final historySwappables = querySnapshot.docs.map((doc) {
        final data = doc.data();
        if ((data['ownerId'] == authUser.email ||
                data['requesterId'] == authUser.email) &&
            data['status'] == 'swapped') {
          return Swap(
            id: data['id'],
            requesterId: data['requesterId'],
            requesterName: data['requesterName'],
            requesterImage: data['requesterImage'],
            ownerId: data['ownerId'],
            ownerName: data['ownerName'],
            ownerImage: data['ownerImage'],
            requesterItemId: data['requestItemId'],
            requesterItemName: data['requesterItemName'],
            requesterItemImages: List<String>.from(data['requesterItemImages']),
            requesterItemDescription: data['requesterItemDescription'],
            requesterItemCategory: data['requesterItemCategory'],
            requesterItemCreatedAt:
                DateTime.parse(data['requesterItemCreatedAt']),
            requesterItemUpdatedAt:
                DateTime.parse(data['requesterItemUpdatedAt']),
            requesterItemCondition: data['requesterItemCondition'].toDouble(),
            // requesterItemCategoryEmoji: entry['requesterItemCategoryEmoji'],
            ownerItemId: data['ownerItemId'],
            ownerItemName: data['ownerItemName'],
            ownerItemImages: List<String>.from(data['ownerItemImages']),
            ownerItemDescription: data['ownerItemDescription'],
            ownerItemCategory: data['ownerItemCategory'],
            ownerItemCreatedAt: DateTime.parse(data['ownerItemCreatedAt']),
            ownerItemUpdatedAt: DateTime.parse(data['ownerItemUpdatedAt']),
            ownerItemCondition: data['ownerItemCondition'].toDouble(),
            // ownerItemCategoryEmoji: entry['ownerItemCategoryEmoji'],
            isAccepted: data['status'] == 'requested' ? false : true,
            createdAt: DateTime.parse(data['createdAt']),
          );
        } else {
          return [];
        }
      });
      _historySwaps = historySwappables.whereType<Swap>().toList();
      notifyListeners();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }
}
