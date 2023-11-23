import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../models/swappable.dart';
import '../providers/bottom_nav_visibility_provider.dart';
import 'swappable_card.dart';

class WishlistTab extends StatelessWidget {
  WishlistTab({
    Key? key,
    required this.wishlistedSwappables,
  }) : super(key: key);

  final List<Swappable> wishlistedSwappables;
  final ScrollController scrollController = ScrollController();
  final authUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('wishlist')
            .doc(authUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data as DocumentSnapshot;
          final items = data['items'];
          final wishlistedSwappablesFinal = items
              .map((item) => Swappable(
                    id: item['id'],
                    name: item['name'],
                    description: item['description'],
                    condition: item['condition'],
                    ownerId: item['ownerId'],
                    imageUrls: List<String>.from(item['imageUrls']),
                    category: item['category'],
                    ownerName: item['ownerName'],
                    ownerImageUrl: item['ownerImageUrl'],
                    swapped: item['swapped'],
                    swapRequests: item['swapRequests'],
                    updatedAt: item['updatedAt'].toDate(),
                    createdAt: item['createdAt'].toDate(),
                  ))
              .toList();
          return Consumer<BottomBarVisibilityProvider>(
              builder: (context, bottomBarVisibilityProvider, child) {
            scrollController.addListener(() {
              final direction = scrollController.position.userScrollDirection;

              if (direction == ScrollDirection.forward) {
                if (!bottomBarVisibilityProvider.isVisible) {
                  bottomBarVisibilityProvider.show();
                }
              } else if (direction == ScrollDirection.reverse) {
                if (bottomBarVisibilityProvider.isVisible) {
                  bottomBarVisibilityProvider.hide();
                }
              }
            });
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              itemCount: wishlistedSwappablesFinal.length,
              controller: scrollController,
              itemBuilder: (ctx, i) {
                return SwappableCard(
                  swappable: wishlistedSwappablesFinal[i],
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.4),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            );
          });
        });
  }
}
