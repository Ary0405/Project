import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:swapsta/models/swap.dart';
import 'package:swapsta/providers/bottom_nav_visibility_provider.dart';
import 'package:swapsta/widgets/swap_swappable_row.dart';

class swaphistorylist extends StatefulWidget {
  final String searchQuery;

  const swaphistorylist({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  State<swaphistorylist> createState() => _swaphistorylistState();
}

class _swaphistorylistState extends State<swaphistorylist> {
  final authUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    String formatDate(String d) {
      DateTime dt = DateTime.parse(d);
      String formattedDate = DateFormat('d MMMM, y').format(dt);
      return formattedDate;
    }

    final ScrollController scrollController = ScrollController();

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('swaps').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final data = snapshot.data?.docs;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final histSwaps = data?.map((item) {
            var dataTemp = item.data() as Map<dynamic, dynamic>;
            if ((dataTemp['ownerId'] == authUser.email ||
                dataTemp['requesterId'] == authUser.email) &&
            dataTemp['status'] == 'swapped') {
              return Swap(
                id: dataTemp['id'],
                requesterId: dataTemp['requesterId'],
                requesterName: dataTemp['requesterName'],
                requesterImage: dataTemp['requesterImage'],
                ownerId: dataTemp['ownerId'],
                ownerName: dataTemp['ownerName'],
                ownerImage: dataTemp['ownerImage'],
                requesterItemId: dataTemp['requestItemId'],
                requesterItemName: dataTemp['requesterItemName'],
                requesterItemImages:
                    List<String>.from(dataTemp['requesterItemImages']),
                requesterItemDescription: dataTemp['requesterItemDescription'],
                requesterItemCategory: dataTemp['requesterItemCategory'],
                requesterItemCreatedAt:
                    DateTime.parse(dataTemp['requesterItemCreatedAt']),
                requesterItemUpdatedAt:
                    DateTime.parse(dataTemp['requesterItemUpdatedAt']),
                requesterItemCondition:
                    dataTemp['requesterItemCondition'].toDouble(),
                ownerItemId: dataTemp['ownerItemId'],
                ownerItemName: dataTemp['ownerItemName'],
                ownerItemImages: List<String>.from(dataTemp['ownerItemImages']),
                ownerItemDescription: dataTemp['ownerItemDescription'],
                ownerItemCategory: dataTemp['ownerItemCategory'],
                ownerItemCreatedAt:
                    DateTime.parse(dataTemp['ownerItemCreatedAt']),
                ownerItemUpdatedAt:
                    DateTime.parse(dataTemp['ownerItemUpdatedAt']),
                ownerItemCondition: dataTemp['ownerItemCondition'].toDouble(),
                isAccepted: dataTemp['status'] == 'requested' ? false : true,
                createdAt: DateTime.parse(dataTemp['createdAt']),
              );
            } else {
              return [];
            }
          }).toList();
          final _hisSwaps = histSwaps?.whereType<Swap>().toList();
          final keywordIncludedSwaps = _hisSwaps
              ?.where((sentSwap) =>
                  sentSwap.ownerName
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()) ||
                  sentSwap.requesterName
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()))
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
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                itemCount: keywordIncludedSwaps?.length,
                controller: scrollController,
                itemBuilder: (ctx, i) {
                  return Wrap(children: [
                    Stack(
                      children: [
                        Card(
                          shadowColor: Colors.transparent,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                SwapSwappableRow(
                                  swap: keywordIncludedSwaps?[i],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'Completed Swap on ' +
                                        formatDate(keywordIncludedSwaps![i]
                                            .createdAt.toString()),
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * .36,
                            MediaQuery.of(context).size.height * .09,
                            0,
                            0,
                          ),
                          child: Image.asset(
                            'assets/img/done_arrow.png',
                            height: 70,
                          ),
                        )
                      ],
                    ),
                  ]);
                },
              );
            },
          );
        });
  }
}
