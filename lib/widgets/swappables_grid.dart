import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:swapsta/widgets/sort_modal.dart';
import '../models/swappable.dart';
import '../providers/bottom_nav_visibility_provider.dart';
import '../widgets/swappable_card.dart';
import 'package:provider/provider.dart';

class SwappablesGrid extends StatelessWidget {
  final String filter;
  final String searchQuery;
  final Sort order;
  const SwappablesGrid(
      {Key? key,
      required this.filter,
      required this.searchQuery,
      required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final swappableProvider = Provider.of<SwappableProvider>(context);
    final isFetching = swappableProvider.isFetching;

    final ScrollController scrollController = ScrollController();

    return (!isFetching)
        ? StreamBuilder(
            stream: FirebaseFirestore.instance.collection('items').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              final data = snapshot.data?.docs;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final swappables = data?.map((item) {
                if (item['swapped'] == false) {
                  print(item);
                  return Swappable(
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
                  );
                } else {
                  return [];
                }
              }).toList();
              final _swappables = swappables?.whereType<Swappable>().toList();
              print(_swappables);
              final categoryWiseSwappables = filter == 'All Categories'
                  ? _swappables
                  : _swappables
                      ?.where((swappable) => swappable.category == filter)
                      .toList();
              final keywordIncludedSwappables = categoryWiseSwappables
                  ?.where((swappable) =>
                      swappable.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      swappable.description
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      swappable.ownerName
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                  .toList();
              final filteredSwappables =
                  sortSwappables(keywordIncludedSwappables!, order);

              return Consumer<BottomBarVisibilityProvider>(
                builder: (context, bottomBarVisibilityProvider, child) {
                  scrollController.addListener(() {
                    final direction =
                        scrollController.position.userScrollDirection;

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
                    itemCount: filteredSwappables.length,
                    controller: scrollController,
                    itemBuilder: (ctx, i) {
                      return SwappableCard(
                        swappable: filteredSwappables[i],
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
                },
              );
            })
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

List<Swappable> sortSwappables(List<Swappable> swappables, Sort order) {
  switch (order) {
    case Sort.added:
      swappables.sort((a, b) => -1 * a.createdAt.compareTo(b.createdAt));
      break;
    case Sort.updated:
      swappables.sort((a, b) => -1 * a.createdAt.compareTo(b.createdAt));
      break;
    case Sort.condition:
      swappables.sort((a, b) => -1 * a.condition.compareTo(b.condition));
      break;
  }
  return swappables;
}
